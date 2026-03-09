import SwiftUI

struct LoginEmailView: View {
    @Binding var path: NavigationPath
    
    @State private var email: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer().frame(height: 40)
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 230,height: 210)
            
            VStack(alignment: .leading, spacing: 6) {
                
                HStack(spacing: 4) {
                    Text(uiString.LoginTitle)
                        .foregroundColor(uiColor.DarkGrayText)
                        .bold()
                        .font(.system(size: 20))
                    
                    Text(uiString.AppName)
                        .foregroundColor(uiColor.ButtonBlue)
                        .font(.system(size: 22))
                        .bold()
                }
                
                Text(uiString.LoginSubTitle)
                    .foregroundColor(uiColor.DarkGrayText)
                    .font(.system(size: 20))
                
                Text(uiString.LoginSubHead)
                    .foregroundColor(uiColor.ButtonBlue)
                    .font(.system(size: 20))
            }
            
            
            VStack(alignment: .leading, spacing: 6) {
                
                HStack(spacing: 12) {
                    Image(systemName: "envelope")
                        .font(.system(size: 22))
                    
                    TextField(uiString.LoginEmailField, text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    showError ? uiColor.Error : uiColor.lightGrayText,
                                    lineWidth: 1.5
                                )
                        )
                        .onChange(of: email) { _ , _ in
                            showError = false
                        }
                }
                
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(uiColor.Error)
                        .font(.caption)
                }
            }
            .padding(.horizontal, 30)
            
            
            Button {
                validate()
            } label: {
                Text(uiString.LoginButton)
                    .foregroundColor(uiColor.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(uiColor.ButtonBlue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            
            
            Button {
                if path.count > 1 {
                    path.removeLast(path.count - 1)
                }
                path.append(Route.loginNumView)
            } label: {
                Text(uiString.LoginWithMobile)
                    .foregroundColor(uiColor.DarkGrayText)
                    .font(.system(size: 20))
                    .bold()
            }
            .padding(.top, 2)
            
            Spacer()
        }
        .background(uiColor.white)
        .onTapGesture {
            dismissKeyboard()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    func validate() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedEmail.isEmpty {
            showError = true
            errorMessage = uiString.LoginEmailNullError
            return
        }
        
        if !isValidEmail(trimmedEmail) {
            showError = true
            errorMessage = uiString.LoginEmailValidError
            return
        }
        
        showError = false
        sendEmai(email: trimmedEmail)
        //path.append(Route.OTPView(user: trimmedEmail))
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let regex =
        #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        
        return NSPredicate(format: "SELF MATCHES %@", regex)
            .evaluate(with: email)
    }
    
    
    
    func sendEmai(email: String) {
        
        let token = UserDefaults.standard.string(forKey: "FCMToken")
        let device_name = UIDevice.current.name
        let osVersion = UIDevice.current.systemVersion
        let app_version = "55"
        
        var components = URLComponents(
            string: apiURL.generateOTP
        )
        
        components?.queryItems = [
            URLQueryItem(name: "mobile_email", value: email),
            URLQueryItem(name: "isFromMobile", value: "0"),
            URLQueryItem(name: "device_name", value: device_name),
            URLQueryItem(name: "app_version", value: app_version),
            URLQueryItem(name: "device_os_version", value: osVersion),
            URLQueryItem(name: "token" , value: token),
        ]
        
        guard let url = components?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            //path.append(Route.OTPView(user: "+91\(mobile)"))
            DispatchQueue.main.async {
                path.append(Route.OTPView(user: email , isMobile: false) )
            }
                    
            
        }.resume()
    }
}

