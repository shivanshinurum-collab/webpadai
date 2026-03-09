import SwiftUI

struct DrawerView : View {
    @Binding var path : NavigationPath
    @State private var showDeleteDialog = false

    var size = 25
    var body: some View {
        
        
        VStack(alignment: .leading , spacing: 15){
            ZStack(alignment: .bottom){
                RoundedRectangle(cornerRadius: 26 , style: .continuous)
                    .foregroundColor(.clear)
                    .background(.blue.opacity(0.7))
                Text(uiString.DrawerTitle)
                    .font(.system(size: 30))
                    .foregroundColor(uiColor.white)
                    .bold()
                    .padding(.bottom)
                    
            }.frame( width: 300, height: 200)
           
            VStack(alignment: .leading,spacing:22){
                
                Button{
                    path.append(Route.EditProfileView)
                }label:{
                    Image(systemName: "person")
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerEditProfile)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                Button{
                    path.append(Route.BookmarkView(url: apiURL.bookmarkPage , title: "Bookmark"))
                }label:{
                    Image(systemName: "bookmark")
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerBookmark)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                Button{
                    path.append(Route.NoticeBoardView)
                }label:{
                    Image(systemName: "newspaper")
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerNotice)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                Button{
                    path.append(Route.PaymentHistoryView)
                }label:{
                    Image(systemName: "indianrupeesign.arrow.trianglehead.counterclockwise.rotate.90")
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerPayment)
                        .multilineTextAlignment(.leading)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                
/*
                Button{
                    path.append(Route.BatchActivateView)
                }label:{
                    Text("</>")
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerBatch)
                        .multilineTextAlignment(.leading)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                
 */
                Button{
                    path.append(Route.AttendanceView)
                }label:{
                    Image(systemName: "person.badge.shield.checkmark")
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerAttendance)
                        .multilineTextAlignment(.leading)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                Button{
                    path.append(Route.RefferNEarnView)
                }label:{
                    Image(systemName: "person.line.dotted.person")
                        .font(.system(size: 15))
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerReffer)
                        .multilineTextAlignment(.leading)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                Button{
                    UserLogOut()
                    path.removeLast(path.count)
                    
                    
                }label:{
                    Image(systemName: "power")
                        .frame(maxWidth: 40)
                        
                    Text(uiString.DrawerLogOut)
                        .multilineTextAlignment(.leading)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                Button{
                    showDeleteDialog = true
                }label:{
                    Image("deleteUser")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 35)
                        
                    Text("Delete Account")
                        .multilineTextAlignment(.leading)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                
            }.padding(.leading , 20)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .background(.white)
        Spacer()
            .confirmationDialog(
                "Are you sure you want to delete your account?",
                isPresented: $showDeleteDialog,
                titleVisibility: .visible
            ) {
                
                Button("Yes, Delete", role: .destructive) {
                    DeleteUser()
                }
                
                Button("Cancel", role: .cancel) {
                    
                }
            }

            
    }
    func DeleteUser() {
        let defaults = UserDefaults.standard

            defaults.removeObject(forKey: "studentId")
            defaults.removeObject(forKey: "userEmail")
            defaults.removeObject(forKey: "fullName")
            defaults.removeObject(forKey: "enrollmentId")
            defaults.removeObject(forKey: "image")
            defaults.removeObject(forKey: "country_code")
            defaults.removeObject(forKey: "mobile")
            defaults.removeObject(forKey: "versionCode")
            defaults.removeObject(forKey: "batchId")
            defaults.removeObject(forKey: "batchName")
            defaults.removeObject(forKey: "referred_by")
            defaults.removeObject(forKey: "affiliate_id")
            defaults.removeObject(forKey: "wallet")
            defaults.removeObject(forKey: "adminId")
            defaults.removeObject(forKey: "paymentType")
            defaults.removeObject(forKey: "admissionDate")
            defaults.removeObject(forKey: "languageName")
            defaults.removeObject(forKey: "transactionId")
            defaults.removeObject(forKey: "amount")
            defaults.removeObject(forKey: "isMobile")
            defaults.removeObject(forKey: "goal")
            defaults.removeObject(forKey: "icon")
            defaults.removeObject(forKey: "user")
            defaults.removeObject(forKey: "isLoggedIn")
        
        print("User Logged Out")
        
        NotificationCenter.default.post(
            name: NSNotification.Name("LoginStatusChanged"),
            object: nil
        )
        
        path.removeLast(path.count)
    }

    func UserLogOut(){
        let defaults = UserDefaults.standard

            defaults.removeObject(forKey: "studentId")
            defaults.removeObject(forKey: "userEmail")
            defaults.removeObject(forKey: "fullName")
            defaults.removeObject(forKey: "enrollmentId")
            defaults.removeObject(forKey: "image")
            defaults.removeObject(forKey: "country_code")
            defaults.removeObject(forKey: "mobile")
            defaults.removeObject(forKey: "versionCode")
            defaults.removeObject(forKey: "batchId")
            defaults.removeObject(forKey: "batchName")
            defaults.removeObject(forKey: "referred_by")
            defaults.removeObject(forKey: "affiliate_id")
            defaults.removeObject(forKey: "wallet")
            defaults.removeObject(forKey: "adminId")
            defaults.removeObject(forKey: "paymentType")
            defaults.removeObject(forKey: "admissionDate")
            defaults.removeObject(forKey: "languageName")
            defaults.removeObject(forKey: "transactionId")
            defaults.removeObject(forKey: "amount")
            defaults.removeObject(forKey: "isMobile")
            defaults.removeObject(forKey: "goal")
            defaults.removeObject(forKey: "icon")
            defaults.removeObject(forKey: "user")
            defaults.removeObject(forKey: "isLoggedIn")
        
        NotificationCenter.default.post(
            name: NSNotification.Name("LoginStatusChanged"),
            object: nil
        )
        
    }
}

