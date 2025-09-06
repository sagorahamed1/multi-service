class ApiConstants{
  // static const String baseUrl = "http://192.168.10.80:8080/api/v1";
  // static const String imageBaseUrl = "http://192.168.10.80:8080";
  static const String baseUrl = "https://server.fixitprosapp.com/api/v1";
  static const String imageBaseUrl = "https://server.fixitprosapp.com/uploads";




  static const String signUpEndPoint = "/auth/register";
  static const String loginUpEndPoint = "/auth/login";
  static const String changePassword = "/auth/change-password";
  static const String verifyEmailEndPoint = "/auth/verify-email";
  static const String forgotPasswordEndPoint = "/auth/forgot-password";
  static const String resetPasswordEndPoint = "/auth/reset-password";
  static const String uploadEndPoint = "/upload";
  static const String getAllToolsEndPoint = "/tool";
  static const String getAllExperienceEndPoint = "/experience";
  static const String resendOtpEndPoint = "/auth/resend-otp";
  static const String mechanicBasicInfoEndPoint = "/mechanic/basic-info";
  static const String experienceCertificationsEndPoint = "/mechanic/experience-certifications";
  static const String mechanicToolsEndPoint = "/mechanic/tools";
  static const String mechanicEmploymentHistoriesEndPoint = "/mechanic/employment-history";
  static const String referenceEndPoint = "/mechanic/reference";
  static const String additionalInformationEndPoint = "/mechanic/why-on-site";
  static const String mechanicResumeCertificateEndPoint = "/mechanic/resume-certificate";
  static const String getProfileEndPoint = "/user/me";
  static const String carModel = "/car-model";
  static const String chatUser = "/message/thread/";
  static  String message(String id) => "/message/${id}";
  static const String postJob = "/job";
  static const String initBookingCustomer = "/job-process/customer";
  static const String feedBack = "/job-process/customer/feedback";
  static const String paymentRefundRequest = "/payment/refund/request";
  static const String findMechanicRadius = "/user/radius/mechanic";
  static const String privacyPolicy = "/setting";
  static const String adminSupport = "/setting/support";
  static const String radiusLimits = "/setting/radius-limits";
  static const String addBalance = "/payment/add-balance";
  static const String withdrawRequest = "/payment/withdraw/request";
  static const String jobRequest = "/job-process/provider/do-request";
  static  String addServiceProvider(String id) => "/job-process/provider/add-services/$id";
  static  String jobProcessCompleteProvider(String id) => "/job-process/provider/$id";
  static const String customerBookingEndPoint = "/job-process/customer";
  static const String progress = "/job?page=1&limit=100";
  static const String getCustomerServices = "/job-process/customer";
  static const String getProviderDetails = "/job-process/provider";
  static const String getAllServiceEndPoint = "/service";
  static  String changeStatus (String id) => "/job-process/provider/$id";
  static  String bookingAllPaginationFilters = "/job-process/provider";
  static  String paymentHistory = "/payment/history?limit=100";
  static  String allHistories (String page,limit) => "/job-process/provider?page=1&limit=11&sortField=createdAt&sortOrder=desc";
  static  String getAllJobProvider(String page, radius) => "/job/provider/$radius?page=$page&limit=10000";


  /// =============================================> Tow Track ============================================>

  static const String towTrackBasicInfoEndPoint = "/tow-truck/basic-info";
  static const String towTrackCompanyInfoEndPoint = "/tow-truck/company-info";
  static const String towTrackLicenseComplianceEndPoint = "/tow-truck/licensing-compliance";
  static const String towTrackVehicleEndPoint = "/tow-truck/vehicles";
  static const String towTrackServiceCoverageEndPoint = "/tow-truck/service-coverage";
  static const String towBusinessRequirementsEndPoint = "/tow-truck/business-req";

}