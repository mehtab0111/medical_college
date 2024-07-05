
class Members {
  int id;
  String identificationNo;
  String firstName;
  String middleName;
  String lastName;
  String gender;
  DateTime dob;
  int categoryId;
  String categoryName;
  String religion;
  int mobileNo;
  String imageURL;
  String image;
  int emergencyPhoneNumber;
  String bloodGroup;
  int userTypeId;
  String userType;
  String email;
  String epfNumber;
  String? basicSalary;
  String location;
  String contractType;
  String bankAccountNumber;
  String bankName;
  String ifscCode;
  String currentAddress;
  String bankBranchName;
  String permanentAddress;
  String qualification;
  String workExperience;
  String materialStatus;
  String dateOfJoining;
  int designationId;
  int departmentId;
  String designationName;
  String departmentName;

  Members({
    required this.id,
    required this.identificationNo,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.categoryId,
    required this.categoryName,
    required this.religion,
    required this.mobileNo,
    required this.imageURL,
    required this.image,
    required this.emergencyPhoneNumber,
    required this.bloodGroup,
    required this.userTypeId,
    required this.userType,
    required this.email,
    required this.epfNumber,
    this.basicSalary,
    required this.location,
    required this.contractType,
    required this.bankAccountNumber,
    required this.bankName,
    required this.ifscCode,
    required this.currentAddress,
    required this.bankBranchName,
    required this.permanentAddress,
    required this.qualification,
    required this.workExperience,
    required this.materialStatus,
    required this.dateOfJoining,
    required this.designationId,
    required this.departmentId,
    required this.designationName,
    required this.departmentName,
  });

  factory Members.fromJson(Map<String, dynamic> json) {
    return Members(
      id: json['id'],
      identificationNo: json['identification_no'],
      firstName: json['first_name'],
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'],
      gender: json['gender'] ?? '',
      dob: DateTime.parse(json['dob']),
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      religion: json['religion'] ?? '',
      mobileNo: json['mobile_no'] ?? 0,
      imageURL: json['img_url'] ?? '',
      image: json['image'] ?? '',
      emergencyPhoneNumber: json['emergency_phone_number'] ?? 0,
      bloodGroup: json['blood_group'] ?? '',
      userTypeId: json['user_type_id'],
      userType: json['user_type'],
      email: json['email'],
      epfNumber: json['epf_number'] ?? '',
      basicSalary: json['basic_salary'],
      location: json['location'] ?? '',
      contractType: json['contract type'] ?? '',
      bankAccountNumber: json['bank_account_number'].toString(),
      bankName: json['bank_name'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      currentAddress: json['current_address'] ?? '',
      bankBranchName: json['bank_branch_name'] ?? '',
      permanentAddress: json['permanent_address'] ?? '',
      qualification: '${json['qualification']}',
      workExperience: '${json['work_experience']}',
      materialStatus: json['material_status'] ?? '',
      dateOfJoining: json['date_of_joining'] ?? '',
      designationId: json['designation_id'] ?? 0,
      departmentId: json['department_id'] ?? 0,
      designationName: json['designation_name'] ?? '',
      departmentName: json['department_name'] ?? '',
    );
  }
}
