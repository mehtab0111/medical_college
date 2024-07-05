import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Services/location.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/awsconfig.dart';
import 'package:medical_college/model/student_model.dart';
import 'package:medical_college/provider/student_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FaceDetectionScreen extends StatefulWidget {
  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CameraController? _controller;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  XFile? _capturedFile;
  late List<CameraDescription> _cameras;
  bool _isFrontCamera = false;
  bool _isCameraInitialized = false;

  bool isLoading = false;

  File? _image;

  double matchPercentage = 0.0;

  Map<String, dynamic> matchedData = {};
  Future<void> compareImages(pickedFile) async {
    try {
      List<Student> studentList = Provider.of<StudentProvider>(context, listen: false).studentList;
      List<String> imageUrls = [];
      double matchPercentage = 0.0;
      String matchedImageUrl = '';
      bool isMatchFound = false;

      // Collect all image URLs from the documents
      List userList = [];
      for (var item in studentList) {
        // Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (item.image != '' && item.imageURL != '') {
          imageUrls.add(item.imageURL + item.image);
        }
      }

      // Compare faces and find the match
      for (var image in imageUrls) {
        matchPercentage = await compareFaces(image, pickedFile.path);
        if (matchPercentage > 90) {
          matchedImageUrl = image;
          // Find the matching document data
          for (var item in studentList) {
            // Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            if ('${item.imageURL}${item.image}' == matchedImageUrl) {
              // matchedData = item;
              saveAttendance(item);
              toastMessage(message: 'Attendance saved');
              isMatchFound = true; // Mark match as found
              break; // Exit the inner loop once the match is found
            }
          }
          if (isMatchFound) {
            break; // Exit the outer loop once the match is found
          }
        }
      }

      if (matchedData != null) {
        // Store the matched document data or perform any further actions
        print('Matched image URL: $matchedImageUrl with percentage: $matchPercentage');
        print('Matched document data: $matchedData');
        // You can store this data in Firestore or any other storage
      }

      // If no match was found, show a message
      if (!isMatchFound) {
        // Replace this with your method to show a message, e.g., using a dialog or a snackbar
        toastMessage(message: 'No matching image found, scan again');
      }

    } catch (e) {
      print('Error fetching images: $e');
    }
  }



  List<String> labels = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableLandmarks: true,
        enableContours: true,
      ),
    );
  }

  Future<void> _initializeCamera([CameraDescription? cameraDescription]) async {
    try {
      _cameras = await availableCameras();
      final camera = cameraDescription ?? _cameras.first;

      _controller = CameraController(camera, ResolutionPreset.ultraHigh, enableAudio: false);
      await _controller?.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
      _startFaceDetection();
    } catch (e) {
      print('Error initializing camera: $e');
      setState(() {
        _isCameraInitialized = false;
      });
    }
  }

  void _flipCamera() async {
    if (_cameras.length > 1) {
      _isFrontCamera = !_isFrontCamera;
      final camera = _isFrontCamera ? _cameras.last : _cameras.first;
      await _controller?.dispose();
      setState(() {
        _isCameraInitialized = false;
      });
      _initializeCamera(camera);
    }
  }

  void _startFaceDetection() {
    _controller?.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;

      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
      final InputImageRotation imageRotation = _rotationIntToImageRotation(_controller!.description.sensorOrientation);
      final InputImageFormat inputImageFormat = _imageFormatFromRawValue(image.format.raw);

      final inputImageMetadata = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes.first.bytesPerRow,
      );

      final inputImage = InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);

      _faceDetector.processImage(inputImage).then((faces) async {
        if (faces.isNotEmpty) {
          // Stop the camera
          await _controller?.stopImageStream();
          setState(() {
            _capturedFile = null;
          });
          _captureImage();
        }
        _isDetecting = false;
      }).catchError((e) {
        _isDetecting = false;
        print('Error processing image: $e');
        _restartCamera();
      });
    });
  }

  InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  InputImageFormat _imageFormatFromRawValue(int rawValue) {
    switch (rawValue) {
      case 17: // ImageFormat.NV21
        return InputImageFormat.nv21;
      case 35: // ImageFormat.YUV_420_888
        return InputImageFormat.yuv420;
      default:
        return InputImageFormat.bgra8888; // default format
    }
  }

  Future<void> _captureImage() async {
    print('Start Capturing');
    try {
      final XFile file = await _controller!.takePicture();
      setState(() {
        _capturedFile = file;
      });
      // Handle the captured image, e.g., save it or display it
      print('Captured image: ${file.path}');

      setState(() {
        isLoading = true;
      });
      compareImages(_capturedFile).whenComplete((){
        setState(() {
          isLoading = false;
        });
        // toastMessage(message: 'Scan a proper image');
        _restartCamera();
      });

    } catch (e) {
      print('Error capturing image: $e');
      _restartCamera();
    }
  }

  void _restartCamera() {
    _controller?.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;

      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
      final InputImageRotation imageRotation = _rotationIntToImageRotation(_controller!.description.sensorOrientation);
      final InputImageFormat inputImageFormat = _imageFormatFromRawValue(image.format.raw);

      final inputImageMetadata = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes.first.bytesPerRow,
      );

      final inputImage = InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);

      _faceDetector.processImage(inputImage).then((faces) async {
        if (faces.isNotEmpty) {
          // Stop the camera
          await _controller?.stopImageStream();
          setState(() {
            _capturedFile = null;
          });
          _captureImage();
        }
        _isDetecting = false;
      }).catchError((e) {
        _isDetecting = false;
        print('Error processing image: $e');
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _faceDetector.close();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text('Student Attendance'),
        actions: [
          // TextButton(
          //   onPressed: () async {
          //     stopProjectVersion();
          //   },
          //   child: Text('Stop Model'),
          // ),
          // TextButton(
          //   onPressed: () {
          //     startProjectVersion();
          //   },
          //   child: Text('Start Model'),
          // ),
        ],
      ),
      body: !_isCameraInitialized ? Center(child: CircularProgressIndicator()) : _capturedFile != null ? SingleChildScrollView(
      // body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: roundedShadedDesign(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location', style: kBoldStyle()),
                    // Text(LocationService.userLocation),
                    // kRowText('Latitude: ', '${LocationService.userLatitude}'),
                    // kRowText('Longitude: ', '${LocationService.userLongitude}'),
                    Text('Time: ${DateFormat('dd-MM-yyyy - hh:mm a').format(DateTime.parse('${DateTime.now()}'))}'),
                  ],
                ),
              ),
            ),

            // if(matchedData['name'] != null)
            // Text('${matchedData['name']}'),
            // if(matchedData['image'] != null)
            // Container(
            //   height: 80,
            //   width: 80,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: NetworkImage(matchedData['image']),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            kSpace(),

            if(isLoading != false)
            Container(
              // width: MediaQuery.of(context).size.width*0.8,
              padding: EdgeInsets.all(10),
              decoration: roundedShadedDesign(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.4),
                      image: DecorationImage(
                        image: AssetImage('images/faceDetection.gif'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text('Detecting\nFace', textAlign: TextAlign.center,),
                ],
              ),
            ),
            if(matchedData == {})
            Text('Scan a proper Image'),

            if(_image != null)
            Image.file(File(_image!.path), height: 200,),

            // if(employeeName != '')
            // matchPercentage > 90 ?
            // Column(
            //   children: [
            //     Text('Match Result: $matchPercentage'),
            //     Text('You are logged in'),
            //   ],
            // ) : Text("Scan a proper image"),
            kSpace(),
            // if(employeeName != '')
            KButton(
              // onClick: _pickImage,
              onClick: (){
                _restartCamera();
              },
              title: 'Scan Image',
            ),

            // KButton(
            //   onClick: giveAttendance,
            //   title: 'Save Attendance',
            // ),
            kBottomSpace(),
          ],
        ),
      // ),
      ) : Stack(
        children: [
          CameraPreview(_controller!),
          Positioned(
            top: 50,
            right: 20,
            child: FloatingActionButton(
              onPressed: _flipCamera,
              child: Icon(Icons.flip_camera_ios),
            ),
          ),
        ],
      ),
    );
  }

  // String userID = '';
  void saveAttendance(Student item) async {
    String url = APIData.saveAttendance;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode([{
        "attendance": "present",
        "course_id": "${item.courseId}",
        "date": DateFormat('dd-MM-yyyy').format(DateTime.now()),
        "first_name": item.firstName.toString(),
        "last_name": item.lastName.toString(),
        "middle_name": item.middleName.toString(),
        "semester_id": "${item.semesterId}",
        "session_id": "${item.sessionId}",
        "subject_id": "1",
        "user_id": item.userTypeId,
        "_class": "new",
        "topic_name": "tets"
      }]),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Attendance Saved');
    } else {
      print(response.statusCode);
    }
  }
}
