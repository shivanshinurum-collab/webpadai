import SwiftUI

struct HomeTabView2: View {
    @Binding var path : NavigationPath
    @State var showMenu : Bool = false
    private let menuWidth: CGFloat = 330
    
    let imageTab : String = UserDefaults.standard.string(forKey: "thumbnail") ?? ""
    let titleTab : String = UserDefaults.standard.string(forKey: "categoryName") ?? ""
    
    var body: some View {
        
        if(!showMenu){
            HStack{
                Button{
                    showMenu.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal")
                       
                }
                
                Spacer()
                
                Button{
                    openWhatsApp(number: "9907677712")
                }label: {
                    Image("whatsapp")
                        .resizable()
                        .frame(width: 40,height: 40)
                        .cornerRadius(15)
                }
                
                Button{
                    path.append(Route.NotificationView)
                } label: {
                    Image(systemName: "bell.fill")
                        
                }
                
            }
            .padding(.horizontal)
            .font(.title)
            .foregroundColor(uiColor.white)
            .background(uiColor.ButtonBlue)
        }
        ZStack(alignment:.leading){
            
            TabView{
                TabHome2(path: $path)
                    .tabItem{
                        TabItemView2(title: "Home", image: "house.fill")
                    }
                TabNotes2(path: $path)
                    .tabItem{
                        TabItemView2(title: "Notes", image: "list.bullet.clipboard.fill")
                    }
                TabTestSeries2(path : $path)
                    .tabItem{
                        TabItemView2(title: "Test Series", image: "list.bullet.clipboard.fill")
                    }
                VideoTab2(path:$path)
                    .tabItem{
                        TabItemView2(title: "Videos", image: "play.circle.fill")
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
                
            
            SideBar2(path: $path)
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
struct TabItemView2: View {
    var title: String
    var image: String

    var body: some View {
        VStack(spacing: 4) {
            
            Image(systemName: image)
                .font(.system(size: 12 , weight: .medium))
                .foregroundColor(.black)
            /*Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)*/

            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.black)
        }
    }
}

