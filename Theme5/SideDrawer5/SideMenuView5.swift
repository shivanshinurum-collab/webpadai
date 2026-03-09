import SwiftUI

struct SideMenuView5: View {
    @Binding var path : NavigationPath
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Profile Header
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 50 , height: 20)
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.gray)
                        
                        Text("Test")
                            .font(.headline)
                        
                        Text("Organization Code GDCCLASS")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)
                    .padding(.horizontal)
                    
                    
                    Divider()
                    
                    // MARK: - Menu Items
                    
                    VStack(spacing: 18) {
                        Button{
                            
                        }label: {
                            MenuRow(icon: "graduationcap", title: "Course Certificates")
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow(icon: "arrow.down.circle", title: "Offline Downloads", isNew: true)
                        }.buttonStyle(.plain)
                        
                        Button{
                            path.append(Route.FreeMaterialSide5)
                        }label: {
                            MenuRow(icon: "folder", title: "Free Material")
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow(icon: "text.bubble", title: "Students Testimonial", isNew: true)
                        }.buttonStyle(.plain)
                        
                        Button{
                            path.append(Route.EditProfileView5)
                        }label: {
                            MenuRow(icon: "person", title: "Edit Profile")
                        }.buttonStyle(.plain)
                        
                        Button{
                            path.append(Route.SettingView5)
                        }label: {
                            MenuRow(icon: "gearshape", title: "Settings")
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow(icon: "questionmark.circle", title: "How to use the App", isNew: true)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow(icon: "shield", title: "Privacy Policy")
                        }.buttonStyle(.plain)
                        
                        Button{
                            path.append(Route.PaymentView5)
                        }label: {
                            MenuRow(icon: "creditcard", title: "Payments")
                        }.buttonStyle(.plain)
                        
                        
                        Divider()
                        
                        Button{
                            
                        }label: {
                            MenuRow(icon: "globe", title: "Website")
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow(icon: "camera", title: "Instagram")
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow(icon: "f.circle", title: "Facebook")
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow(icon: "bird", title: "Twitter")
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow(icon: "phone", title: "Whatsapp")
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow(icon: "envelope", title: "Postal Form")
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow(icon: "arrow.triangle.2.circlepath", title: "Regular Updates")
                        }.buttonStyle(.plain)
                        
                        
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 30)
                }
            }.scrollIndicators(.hidden)
            
            
            // MARK: - Bottom Button
            
            Button {
                print("Share on Facebook")
            } label: {
                HStack {
                    Image("f")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25 , height: 25)
                        .background(.white)
                        .cornerRadius(6)
                        .padding(2)
                    Text("Share on facebook")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea()
    }
}

struct MenuRow: View {
    
    var icon: String
    var title: String
    var isNew: Bool = false
    
    var body: some View {
        HStack {
            
            Image(systemName: icon)
                .frame(width: 22)
                .foregroundColor(.gray)
            
            Text(title)
                .font(.system(size: 15))
            
            Spacer()
            
            if isNew {
                Text("NEW")
                    .font(.system(size: 10))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

