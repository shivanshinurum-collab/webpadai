import SwiftUI

struct TabView5: View {
    @Binding var path : NavigationPath
    @State var showMenu : Bool = false
    private let menuWidth: CGFloat = 330
    
    
    
    var body: some View {
        
        if(!showMenu){
            HStack{
                Button{
                    showMenu.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
                
                Text("MARINE WISDOM ")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal)
                
                Spacer()
                
                
                Button{
                    path.append(Route.Notification5)
                } label: {
                    Image(systemName: "bell.fill")
                        
                }
                
            }
            .padding(.horizontal)
            .font(.title)
            .foregroundColor(uiColor.white)
            .padding(.bottom)
            .background(uiColor.ButtonBlue)
        }
        ZStack(alignment:.leading){
            
            TabView{
                HomeTabView5(path: $path)
                    .tabItem{
                        TabItemView2(title: "Home", image: "house.fill")
                    }
                BatchesTabView5()
                    .tabItem{
                        TabItemView2(title: "Batches", image: "person.2")
                    }
                CourseTabView5(path: $path)
                    .tabItem{
                        TabItemView2(title: "Courses", image: "books.vertical")
                    }
                ChatsTabView5(path: $path)
                    .tabItem{
                        TabItemView2(title: "Chats", image: "message.fill")
                    }
                BooksTabView5(path: $path)
                    .tabItem{
                        TabItemView2(title: "Books", image: "book.fill")
                    }
                
            }
            if showMenu {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                }
            }
                
            
            SideMenuView5(path: $path)
                .frame(width: menuWidth)
                .offset(x: showMenu ? 0 : -menuWidth)
                .animation(.easeInOut, value: showMenu)
                .disabled(!showMenu)
  
            
        }//.background(SwipeBackEnabler())
        .onAppear{
            NotificationCenter.default.post(
                name: NSNotification.Name("LoginStatusChanged"),
                object: nil
            )
        }
        .navigationBarBackButtonHidden(true)
           
    }
    
    func openWhatsApp(number: String) {
            let urlString = "https://wa.me/\(number)"
            if let url = URL(string: urlString),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    
}


