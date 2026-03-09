import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}



struct LoginNumView: View {
    @Binding var path: NavigationPath
    
    @State private var mobileNumber: String = ""
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
                        .foregroundColor(.text)
                        .bold()
                        .font(.system(size: 20))
                    
                    Text(uiString.AppName)
                        .foregroundColor(.blue)
                        .font(.system(size: 22))
                        .bold()
                }
                
                Text(uiString.LoginSubTitle)
                    .foregroundColor(.text)
                    .font(.system(size: 20))
                
                Text(uiString.LoginSubHead)
                    .foregroundColor(.blue)
                    .font(.system(size: 20))
            }
            
            
            VStack(alignment: .leading, spacing: 6) {
                
                HStack(spacing: 12) {
                    
                    // Country Code
                    HStack(spacing: 6) {
                        Text("🇮🇳")
                        Text("+91")
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                showError ? Color.red : Color.gray.opacity(0.4),
                                lineWidth: 1.5
                            )
                    )
                    
                    // Mobile TextField
                    TextField(uiString.LoginMobileField, text: $mobileNumber)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    showError ? Color.red : Color.gray.opacity(0.4),
                                    lineWidth: 1.5
                                )
                        )
                        .onChange(of: mobileNumber) { _, newValue in
                            // Allow only digits & max 10 characters
                            mobileNumber = newValue.filter { $0.isNumber }
                            if mobileNumber.count > 10 {
                                mobileNumber = String(mobileNumber.prefix(10))
                            }
                            showError = false
                        }
                }
                
                // Error Message
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding(.horizontal, 30)
            
            // MARK: - Login Button
            Button {
                validate()
            } label: {
                Text(uiString.LoginButton)
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            
            // MARK: - Login With Email
            Button {
                if path.count > 1 {
                    path.removeLast(path.count - 1)
                }
                path.append(Route.loginEmailView)
            } label: {
                Text(uiString.LoginWithEmail)
                    .foregroundColor(.text)
                    .font(.system(size: 20))
                    .bold()
            }
            .padding(.top, 2)
            
            Spacer()
        }
        .background(Color.white)
        .onTapGesture {
            dismissKeyboard()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Validation
    func validate() {
        let trimmedNumber = mobileNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedNumber.isEmpty {
            showError = true
            errorMessage = uiString.LoginMobileNullError
            return
        }
        
        if trimmedNumber.count != 10 {
            showError = true
            errorMessage = uiString.LoginMobileValidError
            return
        }
        
        showError = false
        let num = String(trimmedNumber)
        print(num)
        sendMobileNumber(mobile: num)
    }
    
    
    func sendMobileNumber(mobile: String) {
        let token = UserDefaults.standard.string(forKey: "FCMToken")
        let device_name = UIDevice.current.name
        let osVersion = UIDevice.current.systemVersion
        let app_version = "55"
        
        var components = URLComponents(
            string: apiURL.generateOTP
        )
        
        components?.queryItems = [
            URLQueryItem(name: "mobile_email", value: mobile),
            URLQueryItem(name: "isFromMobile", value: "1"),
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
                path.append(Route.OTPView(user: mobile , isMobile: true))
            }
                    
            
        }.resume()
    }
}
