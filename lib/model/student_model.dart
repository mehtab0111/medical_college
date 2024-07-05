class Student {
  final int id;
  final String identificationNo;
  final String firstName;
  final String middleName;
  final String lastName;
  final String gender;
  final String dob;
  final String religion;
  final String mobileNo;
  final String imageURL;
  final String image;
  final int categoryId;
  final String categoryName;
  final String bloodGroup;
  final int userTypeId;
  final String userType;
  final String email;
  final int sessionId;
  final String session;
  final int courseId;
  final String courseName;
  final int semesterId;
  final String semesterName;
  final String admissionDate;
  final String fatherName;
  final String fatherOccupation;
  final String fatherPhone;
  final String motherName;
  final String motherOccupation;
  final String guardianName;
  final String guardianEmail;
  final int admissionStatus;
  final String maritalStatus;
  final int emergencyPhoneNumber;
  final String currentAddress;
  final String permanentAddress;
  final String motherPhone;
  final String guardianRelation;
  final String guardianOccupation;
  final String guardianPhone;
  final String guardianAddress;
  final int agentId;
  final int status;
  final int franchiseId;
  final double amount;
  final String paymentDate;
  final String modeOfPayment;
  final String transactionId;
  final double refund;
  final int cautionMoneyId;
  final String cautionMoneyPaymentDate;
  final String cautionMoneyModeOfPayment;
  final String cautionMoneyTransactionId;
  final String cautionMoney;
  final double cautionMoneyDeduction;
  final String refundModeOfPayment;
  final String refundTransactionId;
  final double refundedAmount;
  final String refundPaymentDate;
  final double cautionMoneyRefund;
  final String rollNo;
  final String registrationNo;

  Student({
    required this.id,
    required this.identificationNo,
    required this.firstName,
    this.middleName = '',
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.religion,
    required this.mobileNo,
    this.imageURL = '',
    this.image = '',
    required this.categoryId,
    required this.categoryName,
    required this.bloodGroup,
    required this.userTypeId,
    required this.userType,
    required this.email,
    required this.sessionId,
    required this.courseId,
    required this.courseName,
    required this.semesterId,
    required this.semesterName,
    required this.session,
    required this.admissionDate,
    required this.fatherName,
    required this.fatherOccupation,
    required this.fatherPhone,
    required this.motherName,
    required this.motherOccupation,
    required this.guardianName,
    required this.guardianEmail,
    required this.admissionStatus,
    required this.maritalStatus,
    required this.emergencyPhoneNumber,
    required this.currentAddress,
    required this.permanentAddress,
    required this.motherPhone,
    required this.guardianRelation,
    required this.guardianOccupation,
    required this.guardianPhone,
    required this.guardianAddress,
    required this.agentId,
    required this.status,
    required this.franchiseId,
    required this.amount,
    required this.paymentDate,
    required this.modeOfPayment,
    required this.transactionId,
    required this.refund,
    required this.cautionMoneyId,
    required this.cautionMoneyPaymentDate,
    required this.cautionMoneyModeOfPayment,
    required this.cautionMoneyTransactionId,
    required this.cautionMoney,
    required this.cautionMoneyDeduction,
    required this.refundModeOfPayment,
    required this.refundTransactionId,
    required this.refundedAmount,
    required this.refundPaymentDate,
    required this.cautionMoneyRefund,
    required this.rollNo,
    required this.registrationNo,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      identificationNo: '${json['identification_no']}',
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      religion: json['religion'] ?? '',
      mobileNo: '${json['mobile_no']}',
      imageURL: json['img_url'] ?? '',
      image: json['image'] ?? '',
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      bloodGroup: json['blood_group'] ?? '',
      userTypeId: json['user_type_id'] ?? 0,
      userType: json['user_type'] ?? '',
      email: json['email'] ?? '',
      sessionId: json['session_id'] ?? 0,
      courseId: json['course_id'] ?? 0,
      courseName: json['course_name'].toString(),
      semesterId: json['semester_id'] ?? 0,
      semesterName: json['semester'].toString(),
      session: json['session'] ?? '',
      admissionDate: json['admission_date'] ?? '',
      fatherName: json['father_name'] ?? '',
      fatherOccupation: json['father_occupation'] ?? '',
      fatherPhone: json['father_phone'].toString(),
      motherName: json['mother_name'] ?? '',
      motherOccupation: json['mother_occupation'] ?? '',
      guardianName: json['guardian_name'] ?? '',
      guardianEmail: json['guardian_email'] ?? '',
      admissionStatus: json['admission_status'] ?? 0,
      maritalStatus: json['material_status'] ?? '',
      emergencyPhoneNumber: json['emergency_phone_number'] ?? 0,
      currentAddress: json['current_address'] ?? '',
      permanentAddress: json['permanent_address'] ?? '',
      motherPhone: json['mother_phone'].toString(),
      guardianRelation: json['guardian_relation'] ?? '',
      guardianOccupation: json['guardian_occupation'] ?? '',
      guardianPhone: json['guardian_phone'].toString(),
      guardianAddress: json['guardian_address'] ?? '',
      agentId: json['agent_id'] ?? 0,
      status: json['status'] ?? 0,
      franchiseId: json['franchise_id'] ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentDate: json['payment_date'] ?? '',
      modeOfPayment: json['mode_of_payment'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      refund: (json['refund'] as num?)?.toDouble() ?? 0.0,
      cautionMoneyId: json['caution_money_id'] ?? 0,
      cautionMoneyPaymentDate: json['caution_money_payment_date'] ?? '',
      cautionMoneyModeOfPayment: json['caution_money_mode_of_payment'] ?? '',
      cautionMoneyTransactionId: '${json['caution_money_transaction_id']}',
      cautionMoney: '${json['caution_money']}',
      cautionMoneyDeduction: (json['caution_money_deduction'] as num?)?.toDouble() ?? 0.0,
      refundModeOfPayment: json['refund_mode_of_payment'] ?? '',
      refundTransactionId: json['refund_transaction_id'] ?? '',
      refundedAmount: (json['refunded_amount'] as num?)?.toDouble() ?? 0.0,
      refundPaymentDate: json['refund_payment_date'] ?? '',
      cautionMoneyRefund: (json['caution_money_refund'] as num?)?.toDouble() ?? 0.0,
      rollNo: json['roll_no'].toString(),
      registrationNo: json['registration_no'].toString(),
    );
  }
}