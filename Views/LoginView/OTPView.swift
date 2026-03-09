import SwiftUI

struct OTPView: View {
    
    
    
    @Binding var path: NavigationPath
    
    @State private var otp: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedIndex: Int?
    
    @State private var timeRemaining = 14
    @State private var timerActive = true
    @State private var timer: Timer?
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isVerifying = false
    
    let user: String
    let isMobile: Bool 
    
    var body: some View {
        VStack(spacing: 24) {
            
            // Back Button
            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .font(.system(size: uiString.backSize))
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Text(uiString.OTPTitile)
                .font(.system(size: uiString.titleSize).bold())
            
            Image("OTPIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
            
            Text(uiString.OTPSubTitle)
                .foregroundColor(.gray)
            
            Text(user)
                .bold()
            
            // OTP Input Fields
            HStack(spacing: 14) {
                ForEach(0..<4, id: \.self) { index in
                    OTPTextField(
                        text: $otp[index],
                        isFocused: focusedIndex == index,
                        showError: showError,
                        isDisabled: isVerifying,
                        onTextChange: { newValue in
                            handleTextChange(at: index, newValue: newValue)
                        },
                        onBackspace: {
                            handleBackspace(at: index)
                        }
                    )
                    .focused($focusedIndex, equals: index)
                }
            }
            
            // Error Message
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .transition(.opacity)
            }
            
            // Loading Indicator
            if isVerifying {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            // Resend Timer
            HStack {
                Spacer()
                if timerActive {
                    Text("\(uiString.OTPResendCodeIn) \(timeRemaining)s")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                } else {
                    Button(uiString.OTPResend) {
                        resendOTP()
                    }
                    .foregroundColor(.blue)
                    .bold()
                    .disabled(isVerifying)
                }
            }
            .padding(.trailing, 25)
            
            Spacer()
        }
        .onAppear {
            startTimer()
            // Small delay to ensure UI is ready
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                focusedIndex = 0
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Handle Text Change
    private func handleTextChange(at index: Int, newValue: String) {
        // Filter only numbers
        let filtered = newValue.filter { $0.isNumber }
        
        // Handle paste of multiple digits
        if filtered.count > 1 {
            handlePaste(filtered, startingAt: index)
            return
        }
        
        // Single digit entry
        if filtered.count == 1 {
            otp[index] = filtered
            showError = false
            
            // Move to next field
            if index < 3 {
                focusedIndex = index + 1
            } else {
                // Last field filled, hide keyboard and verify
                focusedIndex = nil
                autoVerifyOTP()
            }
        } else if filtered.isEmpty {
            otp[index] = ""
        }
    }
    
    // MARK: - Handle Backspace
    private func handleBackspace(at index: Int) {
        if otp[index].isEmpty {
            // Current field is empty, move to previous field
            if index > 0 {
                focusedIndex = index - 1
                // Clear the previous field
                otp[index - 1] = ""
            }
        } else {
            // Current field has value, just clear it
            otp[index] = ""
        }
        showError = false
    }
    
    // MARK: - Handle Paste
    private func handlePaste(_ pastedText: String, startingAt index: Int) {
        let digits = Array(pastedText.filter { $0.isNumber })
        
        for (offset, digit) in digits.enumerated() {
            let targetIndex = index + offset
            if targetIndex < 4 {
                otp[targetIndex] = String(digit)
            }
        }
        
        // Move focus to next empty field or last field
        if let nextEmpty = otp.firstIndex(where: { $0.isEmpty }) {
            focusedIndex = nextEmpty
        } else {
            focusedIndex = nil
            autoVerifyOTP()
        }
        
        showError = false
    }
    
    // MARK: - Auto Verify OTP
    private func autoVerifyOTP() {
        let enteredOTP = otp.joined()
        
        guard enteredOTP.count == 4 else { return }
        guard !isVerifying else { return }
        
        checkOTP(email: user, isMobile: isMobile, otp: enteredOTP)
    }
    
    // MARK: - On Verification Success
    private func onVerified(studentData: StudentData) {
        // Store user login status
        UserDefaults.standard.set(user, forKey: "user")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        
        // Store student data
        UserDefaults.standard.set(studentData.studentId, forKey: "studentId")
        UserDefaults.standard.set(studentData.userEmail, forKey: "userEmail")
        UserDefaults.standard.set(studentData.fullName, forKey: "fullName")
        UserDefaults.standard.set(studentData.enrollmentId, forKey: "enrollmentId")
        UserDefaults.standard.set(studentData.image, forKey: "image")
        UserDefaults.standard.set(studentData.country_code, forKey: "country_code")
        UserDefaults.standard.set(studentData.mobile, forKey: "mobile")
        UserDefaults.standard.set("55", forKey: "versionCode")
        UserDefaults.standard.set(studentData.batchId, forKey: "batchId")
        UserDefaults.standard.set(studentData.batchName, forKey: "batchName")
        UserDefaults.standard.set(studentData.referred_by, forKey: "referred_by")
        UserDefaults.standard.set(studentData.affiliate_id, forKey: "affiliate_id")
        UserDefaults.standard.set(studentData.wallet, forKey: "wallet")
        UserDefaults.standard.set(studentData.adminId, forKey: "adminId")
        UserDefaults.standard.set(studentData.paymentType, forKey: "paymentType")
        UserDefaults.standard.set(studentData.admissionDate, forKey: "admissionDate")
        UserDefaults.standard.set(studentData.languageName, forKey: "languageName")
        UserDefaults.standard.set(studentData.transactionId, forKey: "transactionId")
        UserDefaults.standard.set(studentData.amount, forKey: "amount")
        UserDefaults.standard.set(isMobile, forKey: "isMobile")
        
        print("userEmail =",studentData.userEmail)
        print("mobile =",studentData.mobile)
        
        print("Student Data Saving = ",studentData)
        // Navigate based on user data completeness
        if studentData.fullName.isEmpty && studentData.enrollmentId.isEmpty && studentData.userEmail.isEmpty {
            path.append(Route.RegistrationView(isMobile: isMobile))
        }
        else if studentData.fullName.isEmpty && studentData.enrollmentId.isEmpty && studentData.mobile.isEmpty {
            path.append(Route.RegistrationView(isMobile: isMobile))
        }
        else if !studentData.fullName.isEmpty && !studentData.enrollmentId.isEmpty && !studentData.userEmail.isEmpty {
            path.append(Route.SelectGoalView)
        }
    }
    
    
    // MARK: - Timer Functions
    private func startTimer() {
        timeRemaining = 14
        timerActive = true
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerActive = false
                timer?.invalidate()
            }
        }
    }
    
    // MARK: - Resend OTP
    private func resendOTP() {
        otp = Array(repeating: "", count: 4)
        showError = false
        focusedIndex = 0
        startTimer()
        
        GenerateOTP.sendOTP(email: user, isMobile: isMobile)
    }
    
    // MARK: - Check OTP API Call
    private func checkOTP(email: String, isMobile: Bool, otp: String) {
        isVerifying = true
        showError = false
        
        let token = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        let deviceName = UIDevice.current.name
        let osVersion = UIDevice.current.systemVersion
        let appVersion = "55"
        let versionCode = "55"
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        var components = URLComponents(string: apiURL.checkOTP)
        
        components?.queryItems = [
            URLQueryItem(name: "mobile_email", value: email),
            URLQueryItem(name: "device_name", value: deviceName),
            URLQueryItem(name: "device_id", value: deviceId),
            URLQueryItem(name: "app_version", value: appVersion),
            URLQueryItem(name: "device_os_version", value: osVersion),
            URLQueryItem(name: "isFromMobile", value: isMobile ? "1" : "0"),
            URLQueryItem(name: "otp", value: otp),
            URLQueryItem(name: "versionCode", value: versionCode),
            URLQueryItem(name: "token", value: token)
        ]
        
        guard let url = components?.url else {
            DispatchQueue.main.async {
                self.isVerifying = false
                self.showError = true
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isVerifying = false
            }
            
            if let error = error {
                print("❌ Network Error:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = "Network error. Please try again."
                    self.clearOTPFields()
                }
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = "No response from server"
                    self.clearOTPFields()
                }
                return
            }
            
            // Print response for debugging
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("📥 RAW SERVER RESPONSE:")
                print(rawResponse)
            }
            
            do {
                let response = try JSONDecoder().decode(CheckOTP.self, from: data)
                
                print("✅ Decoded Response: ", response)
                print("   Status:", response.status)
                print("   Message:", response.msg)
                
                DispatchQueue.main.async {
                    if response.status == "1" ||
                       response.status.lowercased() == "true" ||
                       response.status.lowercased() == "success",
                       let studentData = response.studentData {
                        
                        print("✅ OTP VERIFIED SUCCESSFULLY")
                        self.onVerified(studentData: studentData)
                        
                    } else {
                        print("❌ OTP VERIFICATION FAILED")
                        print("   Server Message:", response.msg)
                        self.showError = true
                        self.errorMessage = response.msg.isEmpty ? uiString.OTPInvalidError : response.msg
                        self.clearOTPFields()
                    }
                }
                
            } catch {
                print("❌ JSON Decode Error:", error)
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = "Invalid server response"
                    self.clearOTPFields()
                }
            }
            
        }.resume()
    }
    
    // MARK: - Clear OTP Fields
    private func clearOTPFields() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.otp = Array(repeating: "", count: 4)
            self.focusedIndex = 0
        }
    }
}

// MARK: - Custom OTP TextField Component
struct OTPTextField: View {
    @Binding var text: String
    let isFocused: Bool
    let showError: Bool
    let isDisabled: Bool
    let onTextChange: (String) -> Void
    let onBackspace: () -> Void
    
    var body: some View {
        CustomTextField(
            text: $text,
            onTextChange: onTextChange,
            onBackspace: onBackspace
        )
        .keyboardType(.numberPad)
        .multilineTextAlignment(.center)
        .frame(width: 55, height: 55)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    showError ? .red : (isFocused ? .blue : Color.gray.opacity(0.3)),
                    lineWidth: 2
                )
        )
        .disabled(isDisabled)
    }
}

// MARK: - Custom TextField with Backspace Detection
struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    let onTextChange: (String) -> Void
    let onBackspace: () -> Void
    
    func makeUIView(context: Context) -> UITextField {
        let textField = BackspaceTextField()
        textField.delegate = context.coordinator
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
        
        // Set backspace callback
        textField.onBackspace = { [weak textField] in
            guard let textField = textField else { return }
            if textField.text?.isEmpty ?? true {
                onBackspace()
            }
        }
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: CustomTextField
        
        init(_ parent: CustomTextField) {
            self.parent = parent
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            let newText = textField.text ?? ""
            parent.text = newText
            parent.onTextChange(newText)
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Allow backspace
            if string.isEmpty {
                return true
            }
            
            // Allow only single digit
            if string.count == 1 && string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
                return true
            }
            
            // Allow paste of multiple digits
            if string.count > 1 {
                return true
            }
            
            return false
        }
    }
}

// MARK: - Custom UITextField with Backspace Detection
class BackspaceTextField: UITextField {
    var onBackspace: (() -> Void)?
    
    override func deleteBackward() {
        let wasEmpty = text?.isEmpty ?? true
        super.deleteBackward()
        
        if wasEmpty {
            onBackspace?()
        }
    }
}


/*import SwiftUI

struct OTPView: View {
    @Binding var path: NavigationPath
    
    @State private var otp: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedIndex: Int?
    
    @State private var timeRemaining = 14
    @State private var timerActive = true
    @State private var timer: Timer?
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isVerifying = false
    
    let user: String
    let isMobile: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            
            // Back Button
            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Text(uiString.OTPTitile)
                .font(.headline)
            
            Image("OTPIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
            
            Text(uiString.OTPSubTitle)
                .foregroundColor(.gray)
            
            Text(user)
                .bold()
            
            // OTP Input Fields
            HStack(spacing: 14) {
                ForEach(0..<4, id: \.self) { index in
                    TextField("", text: $otp[index])
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .frame(width: 55, height: 55)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    showError
                                    ? .red
                                    : (focusedIndex == index ? .blue : Color.gray.opacity(0.3)),
                                    lineWidth: 2
                                )
                        )
                        .focused($focusedIndex, equals: index)
                        .disabled(isVerifying)
                        .onChange(of: otp[index]) { _, newValue in
                            
                            // Allow only digits
                            otp[index] = newValue.filter { $0.isNumber }
                            
                            // Keep only 1 digit
                            if otp[index].count > 1 {
                                otp[index] = String(otp[index].last!)
                            }
                            
                            showError = false
                            
                            // Move focus forward
                            if !otp[index].isEmpty {
                                if index < 3 {
                                    focusedIndex = index + 1
                                } else {
                                    focusedIndex = nil
                                    autoVerifyOTP()
                                }
                            }
                        }
                }
            }
            
            // Error Message
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            // Loading Indicator
            if isVerifying {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            // Resend Timer
            HStack {
                Spacer()
                if timerActive {
                    Text("\(uiString.OTPResendCodeIn) \(timeRemaining)")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                } else {
                    Button(uiString.OTPResend) {
                        resendOTP()
                    }
                    .foregroundColor(.blue)
                    .bold()
                    .disabled(isVerifying)
                }
            }
            .padding(.trailing, 25)
            
            Spacer()
        }
        .onAppear {
            startTimer()
            focusedIndex = 0
        }
        .onDisappear {
            timer?.invalidate()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Auto Verify OTP
    func autoVerifyOTP() {
        let enteredOTP = otp.joined()
        
        guard enteredOTP.count == 4 else { return }
        guard !isVerifying else { return }
        
        // Call the API to verify OTP
        let otp = String(enteredOTP)
        checkOTP(email: user, isMobile: isMobile, otp: otp)
    }

    // MARK: - On Verification Success
    func onVerified(studentData: StudentData) {
        print(studentData.fullName)
        print(studentData.enrollmentId)
        print(studentData.userEmail)
        
        // Store user login status
        UserDefaults.standard.set(user, forKey: "user")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        
        // Store student data
        UserDefaults.standard.set(studentData.studentId, forKey: "studentId")
        //UserDefaults.standard.set("1", forKey: "studentId")
        UserDefaults.standard.set(studentData.userEmail, forKey: "userEmail")
        UserDefaults.standard.set(studentData.fullName, forKey: "fullName")
        UserDefaults.standard.set(studentData.enrollmentId, forKey: "enrollmentId")
        UserDefaults.standard.set(studentData.image, forKey: "image")
        UserDefaults.standard.set(studentData.country_code, forKey: "country_code")
        UserDefaults.standard.set(studentData.mobile, forKey: "mobile")
        UserDefaults.standard.set("55", forKey: "versionCode")
        UserDefaults.standard.set(studentData.batchId, forKey: "batchId")
        UserDefaults.standard.set(studentData.batchName, forKey: "batchName")
        UserDefaults.standard.set(studentData.referred_by, forKey: "referred_by")
        UserDefaults.standard.set(studentData.affiliate_id, forKey: "affiliate_id")
        UserDefaults.standard.set(studentData.wallet, forKey: "wallet")
        UserDefaults.standard.set(studentData.adminId, forKey: "adminId")
        UserDefaults.standard.set(studentData.paymentType, forKey: "paymentType")
        UserDefaults.standard.set(studentData.admissionDate, forKey: "admissionDate")
        UserDefaults.standard.set(studentData.languageName, forKey: "languageName")
        UserDefaults.standard.set(studentData.transactionId, forKey: "transactionId")
        UserDefaults.standard.set(studentData.amount, forKey: "amount")
        UserDefaults.standard.set(isMobile, forKey: "isMobile")
        
        if(studentData.fullName == "" && studentData.enrollmentId == "" && studentData.userEmail == "" ) {
            path.append(Route.RegistrationView)
        }
        if(studentData.fullName != "" && studentData.enrollmentId != "" && studentData.userEmail != "" ) {
            path.append(Route.SelectGoalView)
        }
        // Navigate to next screen
        
    }
    
    // MARK: - Timer Functions
    func startTimer() {
        timeRemaining = 14
        timerActive = true
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerActive = false
                timer?.invalidate()
            }
        }
    }
    
    // MARK: - Resend OTP
    func resendOTP() {
        otp = Array(repeating: "", count: 4)
        showError = false
        focusedIndex = 0
        startTimer()
        
        GenerateOTP.sendOTP(email: user, isMobile: isMobile)
    }
    
    func checkOTP(email: String, isMobile: Bool, otp: String) {
        isVerifying = true
        showError = false

        let token = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        let deviceName = UIDevice.current.name
        let osVersion = UIDevice.current.systemVersion
        let appVersion = "55"
        let versionCode = "55"
        
        // Try without country_code first, or use the actual phone country code
        let countryCode = "+1"  // Or whatever your actual country code is
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""

        var components = URLComponents(
            string: apiURL.checkOTP
        )

        components?.queryItems = [
            URLQueryItem(name: "mobile_email", value: email),
            //(name: "country_code", value: countryCode),
            URLQueryItem(name: "device_name", value: deviceName),
            URLQueryItem(name: "device_id", value: deviceId),
            URLQueryItem(name: "app_version", value: appVersion),
            URLQueryItem(name: "device_os_version", value: osVersion),
            URLQueryItem(name: "isFromMobile", value: isMobile ? "1" : "0"),
            URLQueryItem(name: "otp", value: otp),
            URLQueryItem(name: "versionCode", value: versionCode),
            URLQueryItem(name: "token", value: token)
        ]

        guard let url = components?.url else {
            isVerifying = false
            showError = true
            errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isVerifying = false
            }

            if let error = error {
                print("❌ Network Error:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                    self.clearOTPFields()
                }
                return
            }

            guard let data = data else {
                print("❌ No data received")
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = "No response from server"
                    self.clearOTPFields()
                }
                return
            }

            // 🔍 PRINT FULL RESPONSE
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("📥 RAW SERVER RESPONSE:")
                print(rawResponse)
               
            }

            do {
                let response = try JSONDecoder().decode(CheckOTP.self, from: data)
                
                print("✅ Decoded Response:")
                print("   Status:", response.status)
                print("   Message:", response.msg)
                
                DispatchQueue.main.async {
                    if response.status == "1"
                        || response.status.lowercased() == "true"
                        || response.status.lowercased() == "success",
                       let studentData = response.studentData {
                        
                        print("✅ OTP VERIFIED SUCCESSFULLY")
                        self.onVerified(studentData: studentData)

                    } else {
                        print("❌ OTP VERIFICATION FAILED")
                        print("   Server Message:", response.msg)
                        self.showError = true
                        self.errorMessage = response.msg.isEmpty
                            ? uiString.OTPInvalidError
                            : response.msg
                        self.clearOTPFields()
                    }
                }

            } catch {
                print("❌ JSON Decode Error:", error)
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = "Invalid server response"
                    self.clearOTPFields()
                }
            }

        }.resume()
    }
    
    // MARK: - Clear OTP Fields
    func clearOTPFields() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            otp = Array(repeating: "", count: 4)
            focusedIndex = 0
        }
    }
}
*/
