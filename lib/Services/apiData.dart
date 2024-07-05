import 'package:medical_college/Services/serviceManager.dart';

class APIData {

  // static const String baseURL = 'https://rgoi.in/college_api/public/api/';
  // static const String baseURL = 'https://devanthosting.cloud/demo_erp/api/public/api/';
  static const String baseURL = 'https://devanthosting.cloud/icare_college/icare_api/public/api/'; //medical college

  static const String login = '${baseURL}login';
  static const String logout = '${baseURL}logout';
  static const String getLoggedInUserData = '${baseURL}getLoggedInUserData';

  static const String dashboard = '${baseURL}dashboard';

  static const String getCourse = '${baseURL}getCourse';
  static const String saveCourse = '${baseURL}saveCourse';
  static const String updateCourse = '${baseURL}updateCourse';
  static const String deleteCourse = '${baseURL}deleteCourse';
  static const String getSemester = '${baseURL}getSemester';
  static const String saveSemester = '${baseURL}saveSemester';
  static const String updateSemester = '${baseURL}updateSemester';
  static const String deleteSemester = '${baseURL}deleteSemester';
  static const String getSession = '${baseURL}getSession';
  static const String getTeachers = '${baseURL}getTeachers';
  static const String getStudents = '${baseURL}getStudents';
  static const String getSubject = '${baseURL}getSubject';
  static const String saveSubject = '${baseURL}saveSubject';
  static const String updateSubject = '${baseURL}updateSubject';
  static const String deleteSubject = '${baseURL}deleteSubject';
  static const String getClass = '${baseURL}getClass';
  static const String getSubjectGroup = '${baseURL}getSubjectGroup';
  static const String saveSubjectGroup = '${baseURL}saveSubjectGroup';
  static const String updateSubjectGroup = '${baseURL}updateSubjectGroup';
  static const String deleteSubjectGroup = '${baseURL}deleteSubjectGroup';
  static const String getSemesterTimeTableByCourseAndSemesterId = '${baseURL}getSemesterTimeTableByCourseAndSemesterId';
  static const String getSemesterTimeTableByTeacherId = '${baseURL}getSemesterTimeTableByTeacherId';
  static const String saveSemesterTimeTable = '${baseURL}saveSemesterTimeTable';
  static const String updateSemesterTeacher = '${baseURL}updateSemesterTeacher';
  static const String getAssignedSemesterTeacher = '${baseURL}getAssignedSemesterTeacher';
  static const String deleteTeachersAssign = '${baseURL}deleteTeachersAssign';
  static const String promoteStudents = '${baseURL}promoteStudents';

  static const String getStudentAttendance = '${baseURL}getStudentAttendance';
  static const String getStudentOwnAttendance = '${baseURL}getStudentOwnAttendance';
  static const String saveAttendance = '${baseURL}saveAttendance';
  static const String saveStaffAttendance = '${baseURL}saveStaffAttendance';

  ///HR
  static const String getStaffAttendance = '${baseURL}getStaffAttendance';
  static const String getLeave = '${baseURL}getLeave';
  static const String saveLeave = '${baseURL}saveLeave';
  static const String updateLeave = '${baseURL}updateLeave';
  static const String deleteLeave = '${baseURL}deleteLeave';
  static const String getLeavesBy = '${baseURL}getLeavesBy';
  static const String updateApproval = '${baseURL}updateApproval';
  static const String getLeaveList = '${baseURL}getLeaveList';
  static const String saveLeaveList = '${baseURL}saveLeaveList';
  static const String updateLeaveList = '${baseURL}updateLeaveList';
  static const String deleteLeaveList = '${baseURL}deleteLeaveList';
  // static const String getCategory = '${baseURL}getCategory';
  static const String getLeaveType = '${baseURL}getLeaveType';
  static const String saveLeaveType = '${baseURL}saveLeaveType';
  static const String updateLeaveType = '${baseURL}updateLeaveType';
  static const String deleteLeaveType = '${baseURL}deleteLeaveType';
  static const String getAllMembers = '${baseURL}getAllMembers';
  static const String deleteMember = '${baseURL}deleteMember';
  static const String getDepartment = '${baseURL}getDepartment';
  static const String saveDepartment = '${baseURL}saveDepartment';
  static const String updateDepartment = '${baseURL}updateDepartment';
  static const String deleteDepartment = '${baseURL}deleteDepartment';
  static const String getDesignation = '${baseURL}getDesignation';
  static const String saveDesignation = '${baseURL}saveDesignation';
  static const String updateDesignation = '${baseURL}updateDesignation';
  static const String deleteDesignation = '${baseURL}deleteDesignation';

  static const String getAllUsers = '${baseURL}getAllUsers';
  static const String getUserTypes = '${baseURL}getUserTypes';
  // static const String userDetails = '${baseURL}user_details';
  static const String saveStudent = '${baseURL}saveStudent';
  static const String updateStudent = '${baseURL}updateStudent';
  static const String changeStudentStatus = '${baseURL}changeStudentStatus';

  ///Report
  static const String getStudentReport = '${baseURL}getStudentReport';
  static const String getAttendancePercentage = '${baseURL}getAttendancePercentage';
  static const String getFeesCollectionReport = '${baseURL}getFeesCollectionReport';
  static const String getDueFeesReport = '${baseURL}getDueFeesReport';

  static const String getRolesAndPermission = '${baseURL}getRolesAndPermission';
  static const String getMenuManagement = '${baseURL}getMenuManagement';
  static const String getRolesAndPermissionForUpdate = '${baseURL}getRolesAndPermissionForUpdate';
  static const String updateRoleAndPermissions = '${baseURL}updateRoleAndPermissions';
  static const String getMenuForUpdate = '${baseURL}getMenuForUpdate';
  static const String updateMenuManagement = '${baseURL}updateMenuManagement';

  static const String getAgent = '${baseURL}getAgent';
  static const String getCategory = '${baseURL}getCategory';
  static const String getFranchise = '${baseURL}getFranchise';
  static const String getWeekdays = '${baseURL}getWeekdays';

  static Map<String, String> kHeader = {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${ServiceManager.tokenID}',
  };

}