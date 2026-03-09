import SwiftUI

struct RegisterView: View {
    
    @Binding var path: NavigationPath
    
    @State private var name: String = ""
    @State private var mobileOrEmail: String = ""
    @State private var referral: String = ""
    
    @State private var nameError: Bool = false
    @State private var inputError: Bool = false
    @State private var errorMessage: String = ""
    
    // If exists → Email flow
    let isMobile :Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            // MARK: - Back Button
            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.system(size: uiString.backSize))
                }
                Spacer()
            }
            
            Text("Please enter your details before \ncontinue")
                .font(.system(size: uiString.titleSize).bold())
            
            // MARK: - Fields
            VStack(spacing: 12) {
                
                // Name Field
                TextField("Enter Name", text: $name)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(nameError ? Color.red : uiColor.DarkGrayText.opacity(0.6), lineWidth: 1)
                    )
                    .onChange(of: name) { _, _ in
                        nameError = false
                        errorMessage = ""
                    }
                
                
                // MARK: - Email OR Mobile Field
                
                if isMobile{
                    
                    // EMAIL FIELD
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        
                        TextField("Email Address", text: $mobileOrEmail)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .onChange(of: mobileOrEmail) { _, newValue in
                                mobileOrEmail = newValue.trimmingCharacters(in: .whitespaces)
                                inputError = false
                                errorMessage = ""
                            }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(inputError ? Color.red : uiColor.DarkGrayText.opacity(0.6), lineWidth: 1)
                    )
                    
                } else {
                    
                    // MOBILE FIELD
                    HStack {
                        Image("flag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        Text("+91")
                        
                        TextField("Mobile Number", text: $mobileOrEmail)
                            .keyboardType(.numberPad)
                            .onChange(of: mobileOrEmail) { _, newValue in
                                mobileOrEmail = newValue.filter { $0.isNumber }
                                if mobileOrEmail.count > 10 {
                                    mobileOrEmail = String(mobileOrEmail.prefix(10))
                                }
                                inputError = false
                                errorMessage = ""
                            }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(inputError ? Color.red : uiColor.DarkGrayText.opacity(0.6), lineWidth: 1)
                    )
                }
                
                
                // Referral
                TextField("Referral Code (Optional)", text: $referral)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(uiColor.DarkGrayText.opacity(0.6), lineWidth: 1)
                    )
                
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            // MARK: - Continue Button
            Button {
                validateAndProceed()
            } label: {
                Text("Continue")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(uiColor.ButtonBlue)
                    .cornerRadius(25)
            }
            .padding(.bottom)
        }
        .padding(.horizontal, 22)
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            dismissKeyboard()
        }
    }
}

// MARK: - VALIDATION
extension RegisterView {
    
    func validateAndProceed() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedInput = mobileOrEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            nameError = true
            errorMessage = "Please enter your name"
            return
        }
        
        if trimmedInput.isEmpty {
            inputError = true
            errorMessage = isMobile ?
            uiString.LoginEmailNullError :
            "Please enter mobile number"
            return
        }
        
        if isMobile {
            // EMAIL VALIDATION
            if !isValidEmail(trimmedInput) {
                inputError = true
                errorMessage = uiString.LoginEmailValidError
                return
            }
        } else {
            // MOBILE VALIDATION
            if trimmedInput.count != 10 {
                inputError = true
                errorMessage = "Please enter valid 10 digit mobile number"
                return
            }
        }
        
        // All Valid
        nameError = false
        inputError = false
        errorMessage = ""
        
        APICall(namee: trimmedName, numberr: trimmedInput)
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let regex =
        #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        
        return NSPredicate(format: "SELF MATCHES %@", regex)
            .evaluate(with: email)
    }
}


// MARK: - API CALL
extension RegisterView {
    
    func APICall(namee: String, numberr: String) {
        
        let token = UserDefaults.standard.string(forKey: "FCMToken")
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        let app_version = "55"
        
        var components = URLComponents(string: apiURL.updateStudentDetail)
        
        components?.queryItems = [
            URLQueryItem(name: "mobile_email", value: numberr),
            URLQueryItem(name: "isFromMobile", value: isMobile  ? "1" : "0"),
            URLQueryItem(name: "name", value: namee),
            URLQueryItem(name: "student_id", value: student_id),
            URLQueryItem(name: "versionCode", value: app_version),
            URLQueryItem(name: "token", value: token),
        ]
        
        guard let url = components?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("❌ Network Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("❌ No Data")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(CheckOTP.self, from: data)
                
                DispatchQueue.main.async {
                    if let studentData = response.studentData {
                        next(studentData: studentData)
                    }
                }
                
            } catch {
                print("❌ Decode Error:", error)
            }
            
        }.resume()
    }
    
    
    func next(studentData: StudentData) {
        UserDefaults.standard.set(studentData.studentId, forKey: "studentId")
        UserDefaults.standard.set(studentData.userEmail, forKey: "userEmail")
        UserDefaults.standard.set(studentData.fullName, forKey: "fullName")
        UserDefaults.standard.set(studentData.enrollmentId, forKey: "enrollmentId")
        UserDefaults.standard.set(studentData.image, forKey: "image")
        UserDefaults.standard.set(studentData.country_code, forKey: "country_code")
        UserDefaults.standard.set(studentData.mobile, forKey: "mobile")
        UserDefaults.standard.set("55", forKey: "versionCode")
        UserDefaults.standard.set(studentData.affiliate_id, forKey: "affiliate_id")
        UserDefaults.standard.set(studentData.paymentType, forKey: "paymentType")
        UserDefaults.standard.set(studentData.admissionDate, forKey: "admissionDate")
        UserDefaults.standard.set(studentData.languageName, forKey: "languageName")
        
        path.append(Route.RegistrationLocationView)
    }
}



/*
import SwiftUI

struct RegisterView: View {
    @Binding var path: NavigationPath
    
    @State private var name: String = ""
    @State private var number: String = ""
    @State private var referral: String = ""
    
    @State private var nameError: Bool = false
    @State private var numberError: Bool = false
    @State private var errorMessage: String = ""
    
    let isMobile = UserDefaults.standard.string(forKey: "isMobile")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            // Back Button
            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.system(size: uiString.backSize))
                }
                Spacer()
            }
            
            Text("Please enter your details before \ncontinue")
                .font(.system(size: uiString.titleSize).bold())
            
            // MARK: - Fields
            VStack(spacing: 12) {
                
                // Name
                TextField("Enter Name", text: $name)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(nameError ? Color.red : uiColor.DarkGrayText.opacity(0.6), lineWidth: 1)
                    )
                    .onChange(of: name) { _, _ in
                        nameError = false
                    }
                
                
                // Mobile Number
                if (isMobile != nil) {
                    HStack {
                        
                        Image(systemName: "envelope")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.gray)
                        
                        TextField("Email Address", text: $number)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .onChange(of: number) { _, newValue in
                                number = newValue.trimmingCharacters(in: .whitespaces)
                                numberError = false
                            }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(numberError ? Color.red : uiColor.DarkGrayText.opacity(0.6), lineWidth: 1)
                    )
                }else{
                    HStack {
                        Image("flag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        Text("+91")
                        
                        TextField("Mobile Number", text: $number)
                            .keyboardType(.numberPad)
                            .onChange(of: number) { _, newValue in
                                // Only digits + max 10
                                number = newValue.filter { $0.isNumber }
                                if number.count > 10 {
                                    number = String(number.prefix(10))
                                }
                                numberError = false
                            }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(numberError ? Color.red : uiColor.DarkGrayText.opacity(0.6), lineWidth: 1)
                    )
                }
                
                
                // Referral (Optional)
                TextField("Referral Code (Optional)", text: $referral)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(uiColor.DarkGrayText.opacity(0.6), lineWidth: 1)
                    )
                
                // Error Message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            // MARK: - Continue Button
            Button {
                MobileValidate()
            } label: {
                Text("Continue")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(uiColor.ButtonBlue)
                    .cornerRadius(25)
            }
            .padding(.bottom)
        }
        .padding(.horizontal, 22)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            NotificationCenter.default.post(
                name: NSNotification.Name("LoginStatusChanged"),
                object: nil
            )
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }
    
    func Emailvalidate() {
        let trimmedEmail = number.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedEmail.isEmpty {
            numberError = true
            errorMessage = uiString.LoginEmailNullError
            return
        }
        
        if !isValidEmail(trimmedEmail) {
            numberError = true
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
    
    // MARK: - Validation
    func MobileValidate() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNumber = number.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            nameError = true
            errorMessage = "Please enter your name"
            return
        }
        
        if trimmedNumber.isEmpty {
            numberError = true
            errorMessage = "Please enter mobile number"
            return
        }
        
        if trimmedNumber.count != 10 {
            numberError = true
            errorMessage = "Please enter valid 10 digit mobile number"
            return
        }
        
        // All Valid
        errorMessage = ""
        nameError = false
        numberError = false
        
        // Navigate / API Call
        APICall(namee: trimmedName , numberr: trimmedNumber)
    }
    
    
    
    func APICall(namee : String , numberr : String){
        
        let token = UserDefaults.standard.string(forKey: "FCMToken")
        let app_version = "55"
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        let isMobile = UserDefaults.standard.string(forKey: "isMobile")
        
        
        var components = URLComponents(
            string: apiURL.updateStudentDetail
        )
        
        components?.queryItems = [
            URLQueryItem(name: "mobile_email", value: numberr),
            URLQueryItem(name: "isFromMobile", value: (isMobile != nil) ? "1" : "0" ),
            //URLQueryItem(name: "refercode", value: referral),
            URLQueryItem(name: "name", value: namee),
            URLQueryItem(name: "student_id", value: student_id),
            URLQueryItem(name: "versionCode", value: app_version),
            URLQueryItem(name: "token" , value: token),
        ]
        
        guard let url = components?.url else { return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("❌ Network Error:", error.localizedDescription)
                return
            }

            guard let data = data else {
                print("❌ No data received")
                return
            }

            // 🔍 PRINT FULL RESPONSE
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("📥 RAW SERVER RESPONSE:")
                print(rawResponse)
            }

            do {
                let response = try JSONDecoder().decode(CheckOTP.self, from: data)
                
                print("✅ Decoded Response:" , response)
                print("   Status:", response.status)
                print("   Message:", response.msg)
                print(" Response     : ", response.studentData ?? "")
                
                DispatchQueue.main.async {
                    next(studentData: response.studentData!)
                }

            } catch {
                print("❌ JSON Decode Error:", error)
            }

        }.resume()
    }
    
    func next(studentData : StudentData){
        UserDefaults.standard.set(studentData.studentId, forKey: "studentId")
        UserDefaults.standard.set(studentData.userEmail, forKey: "userEmail")
        UserDefaults.standard.set(studentData.fullName, forKey: "fullName")
        UserDefaults.standard.set(studentData.enrollmentId, forKey: "enrollmentId")
        UserDefaults.standard.set(studentData.image, forKey: "image")
        UserDefaults.standard.set(studentData.country_code, forKey: "country_code")
        UserDefaults.standard.set(studentData.mobile, forKey: "mobile")
        UserDefaults.standard.set("55", forKey: "versionCode")
        UserDefaults.standard.set(studentData.affiliate_id, forKey: "affiliate_id")
        UserDefaults.standard.set(studentData.paymentType, forKey: "paymentType")
        UserDefaults.standard.set(studentData.admissionDate, forKey: "admissionDate")
        UserDefaults.standard.set(studentData.languageName, forKey: "languageName")
        
        path.append(Route.RegistrationLocationView)
    }
    
}
*/
