class UserModel{
  int id;
  String identificationNo;
  String firstName;
  String middleName;
  String lastName;
  String gender;
  String dob;
  int categoryID;
  String religion;
  String mobileNo;
  String image;
  String bloodGroup;
  String commissionFlat;
  String commissionPercentage;
  int userTypeId;
  int franchiseId;
  String email;
  String emailVerifiedAt;
  int status;
  String createdAt;
  String updatedAt;
  String imageURL;

  UserModel({
    required this.id,
    required this.identificationNo,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.categoryID,
    required this.religion,
    required this.mobileNo,
    required this.image,
    required this.bloodGroup,
    required this.commissionFlat,
    required this.commissionPercentage,
    required this.userTypeId,
    required this.franchiseId,
    required this.email,
    required this.emailVerifiedAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.imageURL,
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['id'],
      identificationNo: json['identification_no'],
      firstName: json['first_name'],
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'],
      gender: json['gender'] ?? '',
      dob: json['dob'],
      categoryID: json['category_id'],
      religion: json['religion'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      image: json['image'] ?? '',
      bloodGroup: json['blood_group'] ?? '',
      commissionFlat: json['commission_flat'] ?? '',
      commissionPercentage: json['commission_percentage'] ?? '',
      userTypeId: json['user_type_id'],
      franchiseId: json['franchise_id'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'] ?? '',
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      imageURL: json['img_url'],
    );
  }
}