struct apiURL {
//    https://webpadhai.com/api/home/general_setting
    static let mainURL = "https://webpadhai.com/"
    //static let mainURL = "https://vaishnavionlineclasses.in/"
    static let baseURL = mainURL + "api/"
    
    //https://webpadhai.com/api/MobileApi/generateOTP
    
    //static let mainURL = "https://app2.lmh-ai.in/"
    //static let baseURL = mainURL + "api/"
    
    /// Question of Day
    //static let questionOfDay = "https://drpawar.in/question-day/1"
    static let questionOfDay = mainURL + "question-day/1"
    
    // MARK: - Login
    static let loginBanners = mainURL + "ajaxcall/api_login_banners"
    static let generateOTP = baseURL + "MobileApi/generateOTP"
    static let checkOTP = baseURL + "MobileApi/checkOTP"
    
    
    
    // MARK: - Register
    static let updateCustomDetail = baseURL + "MobileApi/updateCustomDetail"
    static let getCustomField = baseURL + "MobileApi/getCustomField"
    static let updateStudentDetail = baseURL + "MobileApi/updateStudentDetail"
    
    // MARK: - Home
    static let getCategoryData = baseURL + "HomeNew/getCategoryData"
    static let getNotification = baseURL + "home/get_notification"
    
    // MARK: - Study Tab
    static let myCourse = baseURL + "home/myCourse"
    static let getTestSeriesBatch = baseURL + "Home/getTestSeriesBatch"
    static let getHomeBanner = baseURL + "home/getHomeBanner"
    static let getSubCategoryList = baseURL + "HomeNew/getSubcategoryList/"
    static let getBatchByCatSubCat = baseURL + "Home/getBatchByCatSubCat"
    static let getStoreContent = baseURL + "HomeNew/getStoreContent/"
    static let getTestimonial = baseURL + "HomeNew/getTestimonial"
    
    // MARK: - About Course
    static let appliedCoupon = baseURL + "Home/appliedCoupon"
    static let getBatchDetail = baseURL + "Home/getBatchDetail"
    static let checkActiveLiveClass = baseURL + "Home/checkActiveLiveClass"
    static let getContentDetail = baseURL + "HomeNew/getContentDetail"
    static let manageContent = baseURL + "HomeNew/manage_content/"
    
    // MARK: - Documents
    static let docBatchImage = baseURL + "uploads/batch_image/"
    static let docExamPanel = baseURL + "exam-panel/"
    static let docVideoImg = baseURL + "uploads/video/"
    static let docVideo = baseURL + "uploads/"
    
    // MARK: - Drawer
    static let profileUpdate = baseURL + "home/profile_update"
    static let bookmarkPage = mainURL + "bookmark_page/QJYvEnPAMfImtzN3O-4W1A"
    static let activateBatch = baseURL + "home/add_activation_batch_code"
    static let getAttendance = baseURL + "home/getAttendance"
    static let getProfile = baseURL + "home/getProfile/"
    static let getNotice = baseURL + "home/get_notice"
    static let getPaymentHistory = baseURL + "home/get_payment_history"
    
    // MARK: - General Settings - Payment IDs
    static let generalSetting = baseURL + "home/general_setting"
    
    // MARK: - Payment - Batch Assignment
    static let batchAssignToStudent = baseURL + "MobileApi/batchAssignToStudent"
    
    
    
//    static let limbusmed = "https://limbusmed.com/api/"
//    
//    static let selectGoal2 = limbusmed + "Theme3/getBatchWithCategory"
//    
//    static let getNotes2 =  limbusmed + "Theme3/getFolderForVideo/"
//    static let getTestItem2 = limbusmed +  "Theme3/getListByType/Exam/"
//    static let getVideoItem2 = limbusmed +  "Theme3/getListByType/Video/"
//    static let getDocItem2 =  limbusmed + "Theme3/getListByType/Document/"
     //MARK: - Theme 2
    static let selectGoal2 = baseURL + "Theme3/getBatchWithCategory"
    
    static let getNotes2 =  baseURL + "Theme3/getFolderForVideo/"
    static let getTestItem2 = baseURL +  "Theme3/getListByType/Exam/"
    static let getVideoItem2 = baseURL +  "Theme3/getListByType/Video/"
    static let getDocItem2 =  baseURL + "Theme3/getListByType/Document/"
    
}
// https://webpadhai.com/api/Theme3/getListByType/Video/
//https://limbusmed.com/api/Theme3/getListByType/Document/{batchId}/{folder_id}

/*struct apiURL {
    
   /* static let mainURL = "https://marinewisdom.com/"
    static let apiV2 = "api/v2/"
    static let baseURL = "\(apiURL.mainURL)\(apiURL.apiV2)"*/
    static let baseURL = "https://app2.lmh-ai.in/"
    
    
    static let qustionOfDay = "https://drpawar.in/question-day/1"
    
    
    //Login Banners
    static let loginBanners = "\(apiURL.baseURL)ajaxcall/api_login_banners"
    
    
    ///LOGIN
    //Generate OTP
    static let generateOTP = "\(apiURL.baseURL)api/MobileApi/generateOTP"
    //Check OTP
    static let checkOTP = "\(apiURL.baseURL)api/v2/MobileApi/checkOTP"
    
    //       https://marinewisdom.com/api/v2/MobileApi/checkOTP
 
    ///REGISTER
    //Update Custom Detail
    static let updateCustomDetail = "\(apiURL.baseURL)api/MobileApi/updateCustomDetail"
    //Get Custom Field
    static let getCustomField = "\(apiURL.baseURL)api/MobileApi/getCustomField"
    //Update Student Details
    static let updateStudentDetail = "\(apiURL.baseURL)api/MobileApi/updateStudentDetail"
    
    
    
    ///HOME
    //Get Category Data
    static let getCategoryData = "\(apiURL.baseURL)api/HomeNew/getCategoryData"
    //Get Notification
    static let getNotification = "\(apiURL.baseURL)api/home/get_notification"
    
    
    ///Study TAB
    //My Course
    static let myCourse = "\(apiURL.baseURL)api/home/myCourse"
    
    //Get Test SeriesBatch
    static let getTestSeriesBatch = "\(apiURL.baseURL)api/Home/getTestSeriesBatch"
    
    //Get Home Banner
    static let getHomeBanner = "\(apiURL.baseURL)api/home/getHomeBanner"
    
    //Get Sub Category List
    static let getSubCategoryList = "\(apiURL.baseURL)api/HomeNew/getSubcategoryList/"
    
    //Get Batch By Cat SubCat
    static let getBatchByCatSubCat = "\(apiURL.baseURL)api/Home/getBatchByCatSubCat"
    
    //Get Store Content
    static let getStoreContent = "\(apiURL.baseURL)api/HomeNew/getStoreContent/"
    
    //Get Testimonial
    static let getTestimonial = "\(apiURL.baseURL)api/HomeNew/getTestimonial"
    
    
    ///ABOUT COURSE
    //Applied Coupon
    static let appliedCoupon = "\(apiURL.baseURL)api/v2/Home/appliedCoupon"
    //Get Batch Detail
    static let getBatchDetail = "\(apiURL.baseURL)api/Home/getBatchDetail"
    //Check Active Live Class
    static let checkActiveLiveClass = "\(apiURL.baseURL)api/Home/checkActiveLiveClass"
    //Get Content Detail
    static let getContentDetail = "\(apiURL.baseURL)api/HomeNew/getContentDetail"
    //Manage Course Content
    static let manageContent = "\(apiURL.baseURL)api/HomeNew/manage_content/"
    
    
    ///DOCUMENT
    //Doc Batch Image
    static let DocbatchImage = "\(apiURL.baseURL)uploads/batch_image/"
    //Doc Exam Panel
    static let DocexamPanel = "\(apiURL.baseURL)exam-panel/"
    //Doc Video Image
    static let DocVideoImg = "\(apiURL.baseURL)uploads/video/"
    //Doc Video
    static let DocVideo = "\(apiURL.baseURL)uploads/"
    
    
    
    ///DRWAER  SIDE BAR
    static let profileUpdate = "\(apiURL.baseURL)api/home/profile_update"
    //Bookmark Page
    static let BookmarkPage = "\(apiURL.baseURL)/bookmark_page/QJYvEnPAMfImtzN3O-4W1A"
    //Activate Batch
    static let activateBatch = "\(apiURL.baseURL)api/home/add_activation_batch_code"
    //Get Attendance
    static let getAttendance = "\(apiURL.baseURL)api/v2/home/getAttendance"
    //Get Profile
    static let getProfile = "\(apiURL.baseURL)api/home/getProfile/"
    //Get Notice
    static let getNotice = "\(apiURL.baseURL)api/home/get_notice"
    //Get Payment History
    static let getPaymentHistory = "\(apiURL.baseURL)api/home/get_payment_history"
   
    
    
    
    //General Settings
    static let generalSetting = "\(apiURL.baseURL)api/v2/home/general_setting"
    
    
    ///Theme 2
    static let SelectGoal2 = "\(apiURL.baseURL)api/Theme3/getBatchWithCategory"
    
    
    
    
    //static let getNotes2 = "\(apiURL.baseURL)api/Theme3/getFolderForVideo/"
    static let getNotes2 = "https://limbusmed.com/api/Theme3/getFolderForVideo/"
}
*/
