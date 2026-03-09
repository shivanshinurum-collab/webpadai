import SwiftUI

struct NavigationManager: View {
   @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path){
        SplashView(path: $path)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .loginNumView:
                        LoginNumView(path: $path)
                    case .loginEmailView:
                       LoginEmailView(path: $path)
                    case .WelcomeView:
                        WelcomeView(path: $path)
                    case .OTPView(let user , let isMobile):
                        OTPView(path: $path , user: user , isMobile: isMobile)
                        
                    case .HomeView :
                        HomeTabVew(path: $path)
                        
                    case .SelectGoalView:
                        SelectGoalView(path: $path)
                    case .EditProfileView:
                        EditProfile(path: $path)
                    case .BookmarkView(let url , let title):
                        Bookmark(path: $path,url: url , title: title)
                    case .NoticeBoardView:
                        NoticeBoardView(path: $path)
                    case .PaymentHistoryView:
                        PaymentHistory(path: $path)
                    case .BatchActivateView:
                        ActivateBatch(path: $path)
                    case .AttendanceView:
                        AttendanceView(path: $path)
                    case .RefferNEarnView:
                        RefferNEarn(path: $path)
                          
                    case .MyBatchesView:
                        MyBatchesView(path: $path)
                        
                    case .MyDownloadsView:
                        //MyDownloads(path: $path)
                        DownloadsView(path: $path)
                        
                        
                    case .LiveChatView:
                        LiveChat()
                        
                    case .NotificationView:
                        NotificationView(path: $path)
                        
                    case .BuyCourseView(let course_id , let course_name):
                        BuyCourseView(path: $path, course_id: course_id,course_name: course_name)
                        
                    case .CourseCardView(let course):
                        CourseCardView(path: $path, course: course)
                    case .BatchesTabView:
                        BatchesTabView(path: $path)
                        
                    //case .MyCoursesAbout(let course_id):
                     //   AboutCourses(path: $path, course :course_id)
                        
                        
                    case .RegistrationView(let isMobile):
                        RegisterView(path: $path, isMobile: isMobile)
                    case .RegistrationLocationView:
                        RegisterLocationView(path: $path)
                        
                    case .temp :
                        temp()
                        
                        //Document View
                    case .PDFview(let url ,let title):
                        PDFView(pdfURL: url, title: title)
                        
                    case .VideoView(let url, let title):
                        VideoView(videoURL: url, title: title,path: $path)
                        
                    case .YouTubeView(let videoId, let title):
                        YouTubeVideoView(videoId: videoId, title: title,path: $path)
                        
                    case .AudioPlayerView(let url,let title):
                        AudioPlayerView(path: $path,audioURL: url, title: title)
                        
                    case .FoldersView(let BatchId, let FolderId):
                        FoldersView(path: $path, batch_id: BatchId, folder_id: FolderId)
                        
                    case .ExamView(let ExamUrl):
                        ExamView(url: ExamUrl)
                    case .ExamInfo(let title, let  dis, let  url):
                        ExamInfo(path: $path, title: title, discription: dis, url: url)
                        
                    case .StoreAbout(let Id):
                        StoreAboutView(path: $path,id: Id)
                        
                    case .AddressFormView:
                            AddressFormView(path: $path)
                        
                    case .AllDocView(let title, let url):
                        AllDocView(path: $path, url: url, title: title)
                        
                    case .DigitalEbookView:
                        DigitalEbookView(path: $path)
                    case .IAPView(let productId):
                        IAPView(productId: productId,path: $path)
                        
                        
                        //Theme 2
                    case .HomeTabView2:
                        HomeTabView2(path: $path)
                    case .SelectGoal2:
                        SelectGoal2(path: $path)
                    case .TestListView2(let folder_id, let folder_Name):
                        TestListView2(path : $path, folder_id: folder_id , folder_Name: folder_Name)
                        
                    case .NotesListView2(let folder_id , let folder_Name):
                        NotesListView2(path: $path,folder_id: folder_id, folder_Name: folder_Name)
                        
                    case .VideoListView2(let folder_id, let folder_Name):
                        VideoListView2(path: $path,folder_id: folder_id, folder_Name: folder_Name)
                        
                    
                        //Theme 5
                    case .WelcomeView5:
                        WelcomeView5(path: $path)
                    case .TabView5:
                        TabView5(path: $path)
                    case .Notification5:
                        Notification5(path: $path)
                    case .CourseBuy5:
                        CourseBuy5(path: $path)
                    case .courseCat5:
                        courseCat5(path: $path)
                    case .CourseList5:
                        CourseList5(path: $path)
                    case .FreeStudyMaterial5(let selectedTab):
                        FreeStudyMaterial5(path: $path,selectedTab: selectedTab)
                    case .filterView5:
                        filterView5(path: $path)
                    case .FreeVideosList5:
                        FreeVideosList5(path: $path)
                    case .PaymentView5:
                        PaymentView5(path: $path)
                    case .SettingView5:
                        SettingView5(path: $path)
                    case .EditProfileView5:
                        EditProfileView5(path: $path)
                    case .FreeMaterialSide5:
                        FreeMaterialSide5(path: $path)
                        
                    case .editEducationInfo5:
                        editEducationInfo5(path: $path)
                    case .editBasicInfo5:
                        editBasicInfo5(path: $path)
                    case .editAddressInfo5:
                        editAddressInfo5(path: $path)
                    case .loginMobile4:
                        loginMobile4(path: $path)
                    case .loginOTP4(let user , let isMobile):
                        loginOTP4(path: $path , user: user , isMobile: isMobile)
                    case .TabView4:
                        TabView4(path: $path)
                    case .courseContent4(let batchName , let discription , let id ,let image ):
                        courseContent4(path: $path , batchName: batchName , description: discription , id: id , image: image)
                    case .courseBuy4:
                        courseBuy4(path: $path)
                    }
                }
        }
        
    }
    
}



