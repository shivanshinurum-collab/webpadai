import SwiftUI

struct SideMenuView4: View {
    @Binding var path : NavigationPath
    @Binding var selectedTab: Int
    @Binding var showMenu: Bool
    @State private var showLogOut = false
    
    let userName = UserDefaults.standard.string(forKey: "fullName") ?? "PLAY STORE"
    let imageUrl = UserDefaults.standard.string(forKey: "image") ?? ""
    
    
    var body: some View {
        
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                
                VStack(spacing: 10) {
                    AsyncImage(url: URL(string: imageUrl)){ img in
                            img
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65 , height: 65)
                            .clipShape(.circle)
                        
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.red)
                    }
                    
                    
                    
                    Text("Student Portal")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    Text(userName)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                
                
                ScrollView{
                    VStack(alignment: .leading, spacing: 18) {
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "house.fill",
                                     title: "Home",
                                     index: 0,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "checkmark.circle",
                                     title: "Attendance",
                                     index: 1,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "play.rectangle",
                                     title: "Shorts",
                                     index: 2,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "doc.text",
                                     title: "Notices",
                                     index: 3,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "chart.bar",
                                     title: "Results",
                                     index: 4,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "book",
                                     title: "My Course",
                                     index: 5,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        Button{
                            path.append(Route.EditProfileView)
                        }label: {
                            HStack(spacing: 15) {
                                Image(systemName: "person")
                                    .frame(width: 22)
                                
                                Text("Profile")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                Color.clear
                            )
                            .cornerRadius(10)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "creditcard",
                                     title: "Payments",
                                     index: 7,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        
                        Button {
                            showLogOut.toggle()
                        } label: {
                            HStack(spacing: 15) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .frame(width: 22)
                                
                                Text("Logout")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                Color.clear
                            )
                            .cornerRadius(10)
                        }
                        
                    }
                    .padding(.horizontal)
                    
                }
            }
        }
        .frame(width: 280)
        .confirmationDialog(
            "Are you sure you want to LogOut?",
            isPresented: $showLogOut,
            titleVisibility: .visible
        ) {
            Button("Yes, LogOut", role: .destructive) {
                UserLogOut()
                path.removeLast(path.count)
            }
            
            Button("Cancel", role: .cancel) {
                
            }
        }
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


