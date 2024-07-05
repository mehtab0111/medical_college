
List<String> courseList = [
  'BMLT- Bachelor in Medical Laboratory Technology',
  'DMLT- Diploma in Medical Laboratory Technology',
  'MMLT- Master in Medical Laboratory Technology',
  'BPT - Bachelor of Physiotherapy',
  'MPT- Master of Physiotherapy in Orthopaedics',
  'MPT- Master of Physiotherapy in Neurology',
  'MHA- Master in Hospital Administration',
  'LAW',
  'B.TECH',
  'DEMO TECH',
  'BBA',
];

List<String> semesterList = [
  'Semester 1',
  'Semester 2',
  'Semester 3',
  'Semester 4',
  'Semester 5',
  'Semester 6',
  'Semester 7',
  'Semester 8',
];

class Student {
  int studentID;
  String admissionNo, studentName, fatherName, dob, mobile;
  bool pass;
  bool nextSessionStatus;
  Student({
    required this.studentID,
    required this.admissionNo,
    required this.studentName,
    required this.fatherName,
    required this.dob,
    required this.mobile,
    required this.pass,
    required this.nextSessionStatus,
  });
}

List<Student> studentList = [
  Student(studentID: 1,
    admissionNo: 'BMLT2122001', studentName: 'Ayan Kuila',
    fatherName: 'Satyanath Kuila', dob: '07/05/1999', mobile: '9685742536', pass: true, nextSessionStatus: true,
  ),
  Student(studentID: 2,
    admissionNo: 'BMLT2122002', studentName: 'Tithi Biswas',
    fatherName: 'Mr Biswas', dob: '07/05/1999', mobile: '1236547895', pass: true, nextSessionStatus: true,
  ),
  Student(studentID: 3,
    admissionNo: 'BMLT2122003', studentName: 'Suvendhu Patra',
    fatherName: 'Mr. Patra', dob: '07/05/1999', mobile: '9513578526', pass: true, nextSessionStatus: true,
  ),
];

List<String> roleList = [
  'Admin',
  'Teacher',
  'Accountant',
  'Librarian',
  'Receptionist',
  'Super Admin',
  'Dumy Roll',
  'Teacher With Special Permissions',
];

class Users {
  String userName, userID, course, fatherName, mobile;
  bool isAbled;
  Users({
    required this.userName,
    required this.userID,
    required this.course,
    required this.fatherName,
    required this.mobile,
    required this.isAbled,
  });
}

List<Users> userList = [
  Users(
    userName: 'ABHINABA KAR', userID: 'std216',
    course: 'BMLT- Bachelor in Medical Laboratory Technology(6th Sem)',
    fatherName: 'PULIN KAR', mobile: '8001137886', isAbled: true,
  ),
  Users(
    userName: 'AHAMMED SAYEED NIZAM', userID: 'std217',
    course: 'BMLT- Bachelor in Medical Laboratory Technology(6th Sem)',
    fatherName: 'NAZRUL ISLAM MOLLA', mobile: '8327688740', isAbled: true,
  ),
  Users(
    userName: 'AKASH PANDA', userID: 'std218',
    course: 'BMLT- Bachelor in Medical Laboratory Technology(6th Sem)',
    fatherName: 'SUBRATA PANDA', mobile: '9749561041', isAbled: true,
  ),
  Users(
    userName: 'ANJISNU DAS', userID: 'std219',
    course: 'BMLT- Bachelor in Medical Laboratory Technology(6th Sem)',
    fatherName: 'BISHNU GOPAL DAS', mobile: '9083949599', isAbled: true,
  ),
];

class Parent {
  String guardianName, userID, mobile;
  bool isAbled;
  Parent({
    required this.guardianName,
    required this.userID,
    required this.mobile,
    required this.isAbled,
  });
}

List<Parent> parentList = [
  Parent(
    guardianName: 'ABHINABA KAR', userID: 'std216',
    mobile: '8001137886', isAbled: true,
  ),
  Parent(
    guardianName: 'AHAMMED SAYEED NIZAM', userID: 'std217',
    mobile: '8327688740', isAbled: true,
  ),
  Parent(
    guardianName: 'AKASH PANDA', userID: 'std218',
    mobile: '9749561041', isAbled: true,
  ),
  Parent(
    guardianName: 'ANJISNU DAS', userID: 'std219',
    mobile: '9083949599', isAbled: true,
  ),
];


class Staff {
  String userID, name, email, role, designation, department, mobile;
  bool isAbled;
  Staff({
    required this.userID,
    required this.name,
    required this.email,
    required this.role,
    required this.designation,
    required this.department,
    required this.mobile,
    required this.isAbled,
  });
}

List<Staff> staffList = [
  Staff(
    userID: 'DITS004', name: 'BISWAJIT', email: 'dibyajyoti.dits+stafftest1@gmail.com',
    role: 'Teacher With Special Permissions', designation: 'HOD dept of MLT',
    department: 'MLT', mobile: '9002832828', isAbled: true,
  ),
  Staff(
    userID: 'DITS005', name: 'Tithi', email: 'tithi.dits@gmail.com',
    role: 'Teacher', designation: 'Lab Assistant',
    department: 'MLT', mobile: '9685742315', isAbled: true,
  ),
];

List<String> genderList = [
  'Male',
  'Female',
  'Others',
];

List<String> categoryList = [
  'UR',
  'OBC-A',
  'OBC-B',
  'SC',
  'ST',
  'Physically Challenged',
  'Others',
  'Test_Category',
  'Demo',
];

List<String> bloodGroupList = [
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-',
];

List<String> maritalList = [
  'Single',
  'Married',
  'Widowed',
  'Separated',
  'Not Specified',
];

List<String> departmentList = [
  'Masters of Public Health',
  'Masters of Optometry ( M. Optom)',
  'B.Sc in Data Science',
  'Masters of hospital Management (MHA)',
  'Bachelor of Optometry ( B. Optom)',
  'Bachelor of Business Administration ( Supply Chain Management )',
  'B.Sc in Gaming and Mobile Application',
  'Bachelor of Business Administration ( Hospital Management )',
  'Bachelor of Business Administration',
  'Library',
  'Training And Placement',
  'Admission',
  'Accounts',
  'Faculty',
  'Administration',
];

List<String> designationList = [
  'Training Placement Executive',
  'Training Placement Officer',
  'Janitor',
  'Office Boy',
  'Office Attendant',
  'Office Assistant',
  'Admission Executive',
  'Assistant Accounts Officer',
  'Accounts Officer',
  'Executive Assistant',
  'Librarian',
  'Office Executive',
  'HOD',
  'Associate Professor',
  'Assistant Professor',
  'Director',
  'Administrative Officer',
  'Admission officer',
];

List<String> sessionList = [
  '2020-21',
  '2021-22',
  '2022-23',
  '2023-24',
  '2024-25',
  '2025-26',
  '2026-27'
];

class Month {
  String id;
  String name;
  Month({
    required this.id,
    required this.name,
  });
}

List<Month> monthList = [
  Month(id: '01', name: 'January'),
  Month(id: '02', name: 'February'),
  Month(id: '03', name: 'March'),
  Month(id: '04', name: 'April'),
  Month(id: '05', name: 'May'),
  Month(id: '06', name: 'June'),
  Month(id: '07', name: 'July'),
  Month(id: '08', name: 'August'),
  Month(id: '09', name: 'September'),
  Month(id: '10', name: 'October'),
  Month(id: '11', name: 'November'),
  Month(id: '12', name: 'December'),
];

List<String> weekList = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

List<String> yearList = [
  '2024',
  '2023',
  '2022',
  '2021',
  '2020',
  '2019',
];

List<String> paymentMode = [
  'Cash',
  'Cheque',
  'Transfer To Bank',
  'Others',
];


List<String> religionList = [
  'Hinduism',
  'Buddhism',
  'Christianity',
  'Confucianism',
  'Islam',
  'Jainism',
  'Judaism',
  'Shinto',
  'Sikhism',
  'Taoism',
  'Zoroastrianism',
  'Others',
];
