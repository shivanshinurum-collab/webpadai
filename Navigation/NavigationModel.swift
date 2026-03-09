import Foundation

enum Route : Hashable {
    
    case loginNumView
    case loginEmailView
    case WelcomeView
    case OTPView(user:String , isMobile : Bool)
    case SelectGoalView
    case HomeView
    
    //Registration
    case RegistrationView(isMobile : Bool)
    case RegistrationLocationView
    
    //Side Bar
    case EditProfileView
    case BookmarkView(url : String , title : String)
    case NoticeBoardView
    case PaymentHistoryView
    case BatchActivateView
    case AttendanceView
    case RefferNEarnView
    
    
    // Study Tab
    case MyBatchesView
    case MyDownloadsView
    case LiveChatView
    case DigitalEbookView
    
    case NotificationView
    
    //Tabs
    case BatchesTabView
    case CourseCardView(course : batchData)
    case BuyCourseView(course_id : String , course_name :String)
    
  //  case MyCoursesAbout(course : batchData)
    
    case temp
    
    //Document View
    case PDFview(url: String , title: String)
    case VideoView(url: String , title : String)
    case YouTubeView(videoId: String , title : String)
    case AudioPlayerView(url : String , title : String)
    
    case FoldersView(BatchId : String,FolderId : String)
    
    case ExamView(ExamUrl : String)
    case ExamInfo(title : String , dis : String , url : String)
    
    case StoreAbout(Id : String)
    
    case AddressFormView
    
    case AllDocView(title : String , url : String)
    
    
    case IAPView(productId : String)
    
    
    
    ///Theme 3
    case HomeTabView2
    case SelectGoal2
    case TestListView2(folder_id : String , folder_Name : String)
    
    case NotesListView2(folder_id : String, folder_Name : String)
    
    case VideoListView2(folder_id : String, folder_Name : String)
    
    
    //Theme 4
    case loginMobile4
    case loginOTP4(user : String , isMobile : Bool)
    case TabView4
    case courseContent4(batchName : String , description: String , id : String , image : String)
    case courseBuy4
    
    
    
    
    //Theme5
    case WelcomeView5
    case TabView5
    case Notification5
    case CourseBuy5
    case courseCat5
    case CourseList5
    case FreeStudyMaterial5(selectedTab:Int)
    case filterView5
    case FreeVideosList5
    case PaymentView5
    case SettingView5
    case EditProfileView5
    case FreeMaterialSide5
    
    case editEducationInfo5
    case editBasicInfo5
    case editAddressInfo5
    
    
    
}
