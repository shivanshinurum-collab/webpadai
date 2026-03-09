import SwiftUI
struct SideBar2 :View {
    
    @Binding var path : NavigationPath
    var size = 25
    
    let course =  UserDefaults.standard.string(forKey: "goal") ?? ""
    @State private var showDeleteDialog = false
    let userName = UserDefaults.standard.string(forKey: "fullName") ?? "PLAY STORE TEAM"
    let imageUrl = UserDefaults.standard.string(forKey: "image") ?? ""
    
    var body: some View {
        VStack(alignment: .leading , spacing: 10){
            HStack{
                AsyncImage(url: URL(string: imageUrl)){ img in
                        img
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .clipShape(.circle)
                } placeholder: {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .clipShape(.circle)
                }
                
                Text(userName)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
            }
            Text("Your Course")
                .font(.title2)
                .foregroundColor(.white)
                .bold()
            Button{
                path.append(Route.SelectGoal2)
            }label: {
                HStack{
                    Text("\(course)")
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "greaterthan")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    
                }
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white)
                .padding(.bottom)
                .padding(.top)
            Button{
                
            }label: {
                Text("Buy Plan")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .bold()
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white)
                .padding(.bottom)
                .padding(.top)
            ScrollView{
                VStack(alignment: .leading,spacing:22){
                    
                    Button{
                        path.append(Route.EditProfileView)
                    }label:{
                        Image(systemName: "person")
                            .frame(maxWidth: 40)
                        Text(uiString.DrawerEditProfile)
                    }.font(.system(size: CGFloat(size)))
                    
                    Button{
                        path.append(Route.BookmarkView(url: apiURL.bookmarkPage , title: "Bookmark"))
                    }label:{
                        Image(systemName: "bookmark")
                            .frame(maxWidth: 40)
                        Text(uiString.DrawerBookmark)
                    }.font(.system(size: CGFloat(size)))
                    
                    Button{
                        path.append(Route.NoticeBoardView)
                    }label:{
                        Image(systemName: "newspaper")
                            .frame(maxWidth: 40)
                        Text(uiString.DrawerNotice)
                    }.font(.system(size: CGFloat(size)))
                    
                    Button{
                        path.append(Route.PaymentHistoryView)
                    }label:{
                        Image(systemName: "indianrupeesign.arrow.trianglehead.counterclockwise.rotate.90")
                            .frame(maxWidth: 40)
                        Text(uiString.DrawerPayment)
                            .multilineTextAlignment(.leading)
                    }.font(.system(size: CGFloat(size)))
                    
                    Button{
                        path.append(Route.BatchActivateView)
                    }label:{
                        Text("</>")
                            .frame(maxWidth: 40)
                        Text(uiString.DrawerBatch)
                            .multilineTextAlignment(.leading)
                    }.font(.system(size: CGFloat(size)))
                    
                    Button{
                        path.append(Route.AttendanceView)
                    }label:{
                        Image(systemName: "person.badge.shield.checkmark")
                            .frame(maxWidth: 40)
                        Text(uiString.DrawerAttendance)
                            .multilineTextAlignment(.leading)
                    }.font(.system(size: CGFloat(size)))
                    
                    Button{
                        path.append(Route.RefferNEarnView)
                    }label:{
                        Image(systemName: "person.line.dotted.person")
                            .font(.system(size: 15))
                            .frame(maxWidth: 40)
                        Text(uiString.DrawerReffer)
                            .multilineTextAlignment(.leading)
                    }.font(.system(size: CGFloat(size)))
                    
                    Button{
                        
                    }label:{
                        Image(systemName: "book.pages")
                            .frame(maxWidth: 40)
                            
                        Text("Privacy Policy")
                            .multilineTextAlignment(.leading)
                    }.font(.system(size: CGFloat(size)))
                    Button{
                         
                    }label:{
                        Image(systemName: "exclamationmark.message")
                            .frame(maxWidth: 40)
                            
                        Text("About App")
                            .multilineTextAlignment(.leading)
                    }.font(.system(size: CGFloat(size)))
                    
                    Button{
                        UserLogOut()
                        
                        
                        
                    }label:{
                        Image(systemName: "power")
                            .frame(maxWidth: 40)
                            
                        Text(uiString.DrawerLogOut)
                            .multilineTextAlignment(.leading)
                    }.font(.system(size: CGFloat(size)))
                    
                    Button{
                        showDeleteDialog = true
                    }label:{
                        Image(systemName: "person.slash")
                            .frame(maxWidth: 40)
                        /*Image("deleteUser")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 35)*/
                            
                        Text("Delete Account")
                            .multilineTextAlignment(.leading)
                    }.font(.system(size: CGFloat(size)))
                    
                    
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 0)
                }.foregroundColor(.white)
            }.scrollIndicators(.hidden)
            
            HStack{
                Spacer()
                VStack{
                    Text("v5.0.16")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("MARINE WISDOM")
                        .bold()
                        .foregroundColor(.white)
                }
                Spacer()
            }
            
        }
        .padding(.horizontal)
        .background(uiColor.ButtonBlue)
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
        UserDefaults.standard.set("", forKey: "batch_id")
        UserDefaults.standard.set("", forKey: "goal")
        UserDefaults.standard.set("", forKey: "icon")
        UserDefaults.standard.set("", forKey: "user")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        print("User Logged Out")
        
        path.removeLast(path.count)
    }
    
    func UserLogOut(){
        UserDefaults.standard.set("", forKey: "batch_id")
        UserDefaults.standard.set("", forKey: "goal")
        UserDefaults.standard.set("", forKey: "icon")
        UserDefaults.standard.set("", forKey: "user")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        path.removeLast(path.count)
    }
    
}

