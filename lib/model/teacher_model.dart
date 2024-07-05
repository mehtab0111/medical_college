class Teacher{
  int id;
  String identificationNo;
  String firstName;
  String middleName;
  String lastName;
  String gender;
  String dob;
  int categoryID;
  String categoryName;
  String religion;
  int mobileNo;
  int emergencyPhoneNumber;
  String bloodGroup;
  int userTypeId;
  String userType;
  String email;
  String epfNumber;
  int basicSalary;
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

  Teacher({
    required this.id,
    required this.identificationNo,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.categoryID,
    required this.categoryName,
    required this.religion,
    required this.mobileNo,
    required this.emergencyPhoneNumber,
    required this.bloodGroup,
    required this.userTypeId,
    required this.userType,
    required this.email,
    required this.epfNumber,
    required this.basicSalary,
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

  factory Teacher.fromJson(Map<String, dynamic> json){
    return Teacher(
      id: json['id'],
      identificationNo: json['identification_no'].toString(),
      firstName: json['first_name'],
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'],
      gender: json['gender'],
      dob: json['dob'],
      categoryID: json['category_id'],
      categoryName: json['category_name'],
      religion: json['religion'].toString(),
      mobileNo: json['mobile_no'] ?? 0,
      emergencyPhoneNumber: json['emergency_phone_number'] ?? 0,
      bloodGroup: json['blood_group'].toString(),
      userTypeId: json['user_type_id'],
      userType: json['user_type'],
      email: json['email'],
      epfNumber: json['epf_number'].toString(),
      basicSalary: json['basic_salary'] ?? 0,
      location: json['location'].toString(),
      contractType: json['contract_type'].toString(),
      bankAccountNumber: '${json['bank_account_number']}',
      bankName: json['bank_name'].toString(),
      ifscCode: json['ifsc_code'].toString(),
      currentAddress: json['current_address'].toString(),
      bankBranchName: json['bank_branch_name'].toString(),
      permanentAddress: json['permanent_address'].toString(),
      qualification: '${json['qualification']}',
      workExperience: json['work_experience'].toString(),
      materialStatus: json['material_status'].toString(),
      dateOfJoining: json['date_of_joining'] ?? '',
      designationId: json['designation_id'] ?? 0,
      departmentId: json['department_id'] ?? 0,
      designationName: json['designation_name'] ?? '',
      departmentName: json['department_name'] ?? '',
    );
  }
}