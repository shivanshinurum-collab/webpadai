import SwiftUI

struct TabView4: View {
    @Binding var path : NavigationPath
    
    @State private var selectedTab = 0
    @State var showMenu: Bool = false
    private let menuWidth: CGFloat = 280
    
    @State private var showLogOut = false
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            // MAIN CONTENT
            VStack(spacing: 0) {
                
                // Top Header
                if !showMenu {
                    HStack {
                        Button {
                            withAnimation {
                                showMenu.toggle()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                        
                        Text("MARINE WISDOM")
                            .font(.title3)
                            .bold()
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        Button {
                            showLogOut.toggle()
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .bold()
                        }
                    }
                    .padding(.horizontal)
                    .font(.title3)
                    .foregroundColor(.red)
                    .padding(.vertical, 10)
                    .background(.white)
                }
                
                // Main Content
                TabView(selection: $selectedTab) {
                    
                    HomeTab4(path: $path).tag(0)
                    AttendanceTabView4().tag(1)
                    ShortsView().tag(2)
                    NoticeTabView4().tag(3)
                    ResultTabView4().tag(4)
                    paymentHistory4().tag(7)
                    myCourse4(path: $path).tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Bottom Tab Bar
                HStack {
                    TabBarItem4(icon: "house.fill", title: "Home", index: 0, selectedTab: $selectedTab)
                    TabBarItem4(icon: "checkmark.circle", title: "Attendance", index: 1, selectedTab: $selectedTab)
                    TabBarItem4(icon: "play.rectangle.fill", title: "Shorts", index: 2, selectedTab: $selectedTab)
                    TabBarItem4(icon: "megaphone.fill", title: "Notice", index: 3, selectedTab: $selectedTab)
                    TabBarItem4(icon: "chart.bar.fill", title: "Results", index: 4, selectedTab: $selectedTab)
                }
                .padding()
                .background(Color.red)
            }
            .disabled(showMenu) // disable clicks when menu open
            
            
            // DARK OVERLAY
            if showMenu {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }
            }
            
            
            // SIDE MENU
            SideMenuView4(path: $path,selectedTab: $selectedTab, showMenu: $showMenu)
                .frame(width: menuWidth)
                .offset(x: showMenu ? 0 : -menuWidth)
                .animation(.easeInOut(duration: 0.3), value: showMenu)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
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

struct TabBarItem4: View {
    
    let icon: String
    let title: String
    let index: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        Button {
            selectedTab = index
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(selectedTab == index ? .white : .white.opacity(0.5))
            .frame(maxWidth: .infinity)
        }
    }
    
    
    
}




