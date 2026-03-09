import SwiftUI

struct HomeTabVew: View {
    @Binding var path : NavigationPath
    @State var showMenu : Bool = false
    private let menuWidth: CGFloat = 300
    
    let imageTab : String = UserDefaults.standard.string(forKey: "thumbnail") ?? ""
    let titleTab : String = UserDefaults.standard.string(forKey: "categoryName") ?? ""
    
    var body: some View {
        
        
        ZStack(alignment:.leading){
            TabView{
                StudyTabView(path: $path)
                    .tabItem{
                        TabItemView(title: "Study", image: "study")
                    }
                TestTabView(path: $path)
                    .tabItem{
                        TabItemView(title: "Test", image: "test")
                    }
                BatchesTabView(path: $path)
                    .tabItem{
                        TabItemView(title: "Batches", image: "batches")
                    }
                StoreTabView(path : $path)
                    .tabItem{
                        TabItemView(title: "Store", image: "store")
                    }
                ShortsTabView()
                    .tabItem{
                        TabItemView(title: "Shorts", image: "shorts")
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
                
            
            DrawerView(path: $path)
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
            .toolbar{
                
                
                ToolbarItem(placement: .topBarLeading){
                    Button{
                        showMenu.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.black)
                    }
                }
                
                if #available(iOS 26.0, *) {
                    ToolbarItem(placement: .topBarLeading){
                        Button{
                            path.append(Route.SelectGoalView)
                            //path.removeLast()
                        } label: {
                            HStack{
                                AsyncImage(url: URL(string: imageTab)){ img in
                                    img
                                        .image?.resizable()
                                        .scaledToFit()
                                        .frame(width: 22,height: 22)
                                }
                                
                                Text(titleTab)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    //.minimumScaleFactor(0.5)
                                    .frame(maxWidth: 115, alignment: .leading)

                                
                                Image(systemName: "chevron.right")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                
                            }.background(.clear)
                        }
                    }
                    //.sharedBackgroundVisibility(.hidden)
                }else{
                    ToolbarItem(placement: .topBarLeading){
                        Button{
                            path.append(Route.SelectGoalView)
                            //path.removeLast()
                        } label: {
                            HStack{
                                AsyncImage(url: URL(string: imageTab)){ img in
                                    img
                                        .image?.resizable()
                                        .scaledToFit()
                                        .frame(width: 22,height: 22)
                                }
                                
                                Text(titleTab)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                
                                Image(systemName: "chevron.right")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }.background(.clear)
                        }
                    }
                }
                
               ToolbarItem(placement: .topBarTrailing){
                    Button{
                        path.append(Route.NotificationView)
                    } label: {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.black)
                    }
                    
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        openWhatsApp(number: "9907677712")
                    }label: {
                        Image("whatsapp")
                            .resizable()
                            .frame(width: 40,height: 40)
                            .cornerRadius(15)
                    }
                }
                
            }.navigationBarHidden(showMenu)
    }
    
    func openWhatsApp(number: String) {
            let urlString = "https://wa.me/\(number)"
            if let url = URL(string: urlString),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    
    
    
}
struct TabItemView: View {
    var title: String
    var image: String

    var body: some View {
        VStack(spacing: 4) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)

            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.black)
        }
    }
}

