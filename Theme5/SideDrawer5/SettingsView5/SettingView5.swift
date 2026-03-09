import SwiftUI

struct SettingView5: View {
    
    @State var showAlert: Bool = false
    @Binding var path: NavigationPath
    @State var isOn: Bool = false
    @State var showLogOut : Bool = false
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 0) {
                
                // Header
                HStack(spacing: 20) {
                    Button {
                        path.removeLast()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: uiString.backSize))
                    }
                    .buttonStyle(.plain)
                    
                    Text("Settings")
                        .foregroundColor(.white)
                        .font(.system(size: uiString.titleSize))
                    
                    Spacer()
                }
                .padding()
                .background(uiColor.ButtonBlue)
                
                
                // Body
                VStack(spacing: 15) {
                    
                    Button {
                        withAnimation {
                            showAlert.toggle()
                        }
                    } label: {
                        HStack {
                            Text("Notification Settings")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(.horizontal)
                        .foregroundColor(.black)
                    }
                    .padding(9)
                    .background(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 8)
                    
                    
                    Button {
                        isOn.toggle()
                    } label: {
                        HStack {
                            Text("Enable Picture-in-Picture")
                            Spacer()
                            Toggle("", isOn: $isOn)
                                .labelsHidden()
                                .frame(width: 40, height: 20)
                        }
                        .padding(.horizontal)
                        .foregroundColor(.black)
                    }
                    .padding(9)
                    .background(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 8)
                    
                    
                    HStack(spacing: 25) {
                        Button {
                            
                        } label: {
                            VStack(spacing: 10) {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .padding(10)
                            .padding(.horizontal, 30)
                            .background(.white)
                        }
                        
                        Button {
                            
                        } label: {
                            VStack(spacing: 10) {
                                Image(systemName: "star.fill")
                                Text("Rate us")
                            }
                            .padding(10)
                            .padding(.horizontal, 30)
                            .background(.white)
                        }
                    }
                    
                    
                    Button {
                        showLogOut.toggle()
                    } label: {
                        Text("Sign Out")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .cornerRadius(12)
                            .padding(8)
                            .foregroundColor(uiColor.Error)
                    }
                    
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            Text("Version")
                            Text("1.12.11")
                        }
                        .font(.caption)
                    }
                    .padding(.horizontal, 8)
                    
                    
                    HStack {
                        Button {
                            
                        } label: {
                            Text("Terms & conditions")
                                .font(.caption)
                        }
                        
                        Text("of using the product")
                        
                        Spacer()
                    }
                    .font(.caption)
                    .padding(.horizontal, 35)
                    
                    
                    Button {
                        
                    } label: {
                        Text("Privacy Policy")
                            .font(.caption)
                    }
                    .padding(5)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: uiColor.ButtonBlue, radius: 1)
                    
                    Spacer()
                }
                .padding(.top)
                .background(uiColor.lightSystem)
            }
            .blur(radius: showAlert ? 3 : 0)
            
            
            if showAlert {
                
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showAlert = false
                        }
                    }
                
                NotificationAlert5 {
                    withAnimation {
                        showAlert = false
                    }
                }
                .transition(.scale)
            }
        }
        .confirmationDialog(
            "Are you sure you want to log out?",
            isPresented: $showLogOut,
            titleVisibility: .visible
        ) {
            Button("Log Out", role: .destructive) {
                UserLogOut()
            }
            
            Button("Cancel", role: .cancel) {
                showLogOut.toggle()
            }
        }
        
        .navigationBarBackButtonHidden(true)
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

/*
import SwiftUI

struct SettingView4 : View {
    
    @State var showAlert : Bool = false
    
    @Binding var path : NavigationPath
    
    @State var isOn : Bool = false
    
    var body: some View {
        
        HStack(spacing: 20){
            Button{
                path.removeLast()
            }label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.backSize))
            }.buttonStyle(.plain)
            
            Text("Settings")
                .foregroundColor(.white)
                .font(.system(size: uiString.titleSize))
            
            Spacer()
            
        }.padding()
            .background(uiColor.ButtonBlue)
            .blur(radius: showAlert ? 3 : 0)
            .overlay{
                if showAlert {
                    
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showAlert = false
                            }
                        }
                }
            }
        
        ZStack{
            VStack(spacing: 15){
                
                Button{
                    showAlert.toggle()
                }label: {
                    HStack{
                        Text("Notification Settings")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }.padding(.horizontal)
                        .foregroundColor(.black)
                }.padding(9)
                    .background(.white)
                    .cornerRadius(12)
                    .padding(.horizontal , 8)
                
                
                Button{
                    isOn.toggle()
                }label: {
                    HStack{
                        Text("Enable Picture-in-Picture")
                        Spacer()
                        Toggle("" , isOn: $isOn)
                            .labelsHidden()
                            .frame(width: 15,height: 12)
                        
                    }.padding(.horizontal)
                        .foregroundColor(.black)
                }.padding(9)
                    .background(.white)
                    .cornerRadius(12)
                    .padding(.horizontal , 8)
                
                
                HStack(spacing: 25){
                    Button{
                        
                    }label: {
                        VStack(spacing: 10){
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }.padding(10)
                            .padding(.horizontal ,30)
                            .background(.white)
                    }
                    
                    Button{
                        
                    }label: {
                        VStack(spacing: 10){
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }.padding(10)
                            .padding(.horizontal ,30)
                            .background(.white)
                    }
                    
                }
                
                
                Button{
                    
                }label: {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .cornerRadius(12)
                        .padding(8)
                        .foregroundColor(uiColor.Error)
                }
                
                HStack{
                    Spacer()
                    
                    VStack{
                        Text("Version")
                        Text("1.12.11")
                    }.font(.caption)
                    
                }.padding(.horizontal , 8)
                
                HStack{
                    Button{
                        
                    }label: {
                        Text("Terms & conditions")
                            .font(.caption)
                    }
                    
                    Text("of using the product")
                    
                    Spacer()
                }.font(.caption)
                    .padding(.horizontal , 35)
                
                
                Button{
                    
                }label: {
                    Text("Privacy Policy")
                        .font(.caption)
                }.padding(5)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: uiColor.ButtonBlue, radius: 1)
                
                
                Spacer()
            }
            .padding(.top)
            .background(uiColor.lightSystem)
            .blur(radius: showAlert ? 3 : 0)
            .navigationBarBackButtonHidden(true)
            
            if showAlert {
                
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showAlert = false
                        }
                    }
                
                NotificationAlert4{
                    withAnimation {
                        showAlert = false
                    }
                }
                .transition(.scale)
            }
            
        }
    }
}
*/
