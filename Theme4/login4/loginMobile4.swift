import SwiftUI

struct loginMobile4 : View {
    @Binding var path : NavigationPath
    
    @State private var mobileNumber: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    @State var email : String = ""
    @State var showMobile : Bool = true
    
    @State var process : Bool = false
    
    var body: some View {
        ZStack{
            
            LinearGradient(colors: [uiColor.ButtonBlue , .white], startPoint: .center, endPoint: .bottom)
            
                .ignoresSafeArea()
            VStack(alignment: .leading , spacing: 10){
                HStack{
                    Image(systemName: "graduationcap.fill")
                        .font(.title2)
                        .foregroundColor(uiColor.ButtonBlue)
                    
                    Text("Marine Wisdom")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Text("• Verified Institute")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(5)
                        .background(uiColor.cardLightGreen.opacity(0.4))
                        .cornerRadius(12)
                    
                    Spacer()
                }
                
                Text("Sign in")
                    .font(.title2)
                    .bold()
                Text("Choose Your role and continue learning")
                    .font(.caption)
                    .foregroundColor(uiColor.DarkGrayText)
                
                Text("Login as Student")
                    .font(.subheadline)
                    .padding(.vertical)
                
                
                if showMobile{
                    VStack(alignment: .leading, spacing: 6){
                        
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
                        
                        if showError {
                            Text(errorMessage)
                                .foregroundColor(uiColor.Error)
                                .font(.caption)
                        }
                        
                        HStack{
                            Spacer()
                            Button{
                                showMobile.toggle()
                                showError = false
                                errorMessage = ""
                            }label: {
                                Text("Login with email")
                                    .font(.subheadline)
                            }.disabled(process)
                        }
                    }
                }else{
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
                    
                    HStack{
                        Spacer()
                        Button{
                            showMobile.toggle()
                            showError = false
                            errorMessage = ""
                        }label: {
                            Text("Login with mobile")
                                .font(.subheadline)
                        }.disabled(process)
                    }
                    
                }
                
                Button{
                    if showMobile {
                        validateMobile()
                    }else{
                        validateEmail()
                    }
                }label: {
                    if !process{
                        Text("Continue")
                            .foregroundColor(.white)
                            .bold()
                            .frame(maxWidth: .infinity , maxHeight: 50)
                    }else{
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity , maxHeight: 50)
                    }
                }.background(uiColor.ButtonBlue)
                    .cornerRadius(25)
                    .disabled(process)
                
            }.padding(20)
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(19)
                .padding()
        }.navigationBarBackButtonHidden(true)
    }
    
    
    
    // MARK: - Validation
    func validateMobile() {
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
        process = true
        sendMobile(mobile: num)
    }
    
    
    func sendMobile(mobile: String) {
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
                //path.append(Route.OTPView(user: mobile , isMobile: true))
                path.append(Route.loginOTP4(user : mobile , isMobile : true))
            }
                    
            
        }.resume()
    }
    
    
    func validateEmail() {
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
        process = true
        sendEmail(email: trimmedEmail)
        //path.append(Route.OTPView(user: trimmedEmail))
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let regex =
        #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        
        return NSPredicate(format: "SELF MATCHES %@", regex)
            .evaluate(with: email)
    }
    
    
    
    func sendEmail(email: String) {
        
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
                path.append(Route.loginOTP4(user: email , isMobile: false) )
            }
                    
            
        }.resume()
    }
    
}

