import SwiftUI

struct SplashView: View {
    @Binding var path: NavigationPath
    
    @State private var isActive = false
    @State private var scale: CGFloat = 0.6
    @State private var opacity: Double = 0.0
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 290, height: 260)
                .foregroundColor(uiColor.black)
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(uiColor.white)
        .onAppear {
            // Reset state variables first
            scale = 0.6
            opacity = 0.0
            isActive = false
            
            // Then animate
            withAnimation(.easeOut(duration: 1.2)) {
                scale = 1.0
                opacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isActive = true
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: isActive) { oldValue, newValue in
            if newValue {
                
                
                let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
                
                //UserDefaults.standard.set("2", forKey: "studentId")
    //            path.append(Route.TabView4)
                if isLoggedIn {
                    path.append(Route.HomeView)
                    //path.append(Route.TabView4)
                } else {
                    path.append(Route.WelcomeView)
                    //path.append(Route.loginMobile4)
                }
            }
        }
    }
}
