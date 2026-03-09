import SwiftUI
import Combine

struct WelcomeView5: View {
    
    @Binding var path: NavigationPath
    
    @State private var index = 0
    @State private var banners: [HomeBannerData] = []
    @State private var fileBaseURL = ""
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    @State private var showMobile = false
    @State private var showLogin = false
    @State private var mobile = ""
    
    @State private var showOTPSheet = false
    @State private var otp = ""
    
    //  Validation States
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack{
            if showLogin || showOTPSheet {
                Color.black.opacity(0.12)
            }
            VStack {
                
                Spacer()
                
                TabView(selection: $index) {
                    ForEach(banners.indices, id: \.self) { i in
                        AsyncImage(
                            url: URL(string: fileBaseURL + banners[i].banner)
                        ) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .tag(i)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 200)
                .onReceive(timer) { _ in
                    withAnimation {
                        index = banners.isEmpty ? 0 : (index + 1) % banners.count
                    }
                }
                
                Spacer()
                
                // MARK: - Bottom Login Section
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Login or Signup")
                        .font(.headline)
                    
                    HStack {
                        Text("Please enter your \(showMobile ? "mobile number" : "email address") or")
                            .font(.system(size: 12))
                        
                        Button {
                            showMobile.toggle()
                        } label: {
                            Text("continue with \(showMobile ? "email" : "phone number")")
                                .font(.system(size: 12))
                        }
                    }
                    
                    Button {
                        mobile = ""
                        errorMessage = ""
                        showLogin = true
                    } label: {
                        HStack(spacing: 5) {
                            
                            if showMobile {
                                Text("+91")
                                
                                Rectangle()
                                    .frame(width: 1, height: 28)
                                
                                Text("Mobile Number")
                            } else {
                                Rectangle()
                                    .frame(width: 1, height: 28)
                                    .foregroundColor(.clear)
                                
                                Text("eg. emailAddress@gmail,com")
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 11)
                                .stroke(lineWidth: 1)
                        )
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                }
                .padding()
                .background(Color.white)
                .shadow(color: .black.opacity(0.2),
                        radius: 10,
                        x: 0,
                        y: -5)
            }
            //.background(.white)
            .navigationBarBackButtonHidden(true)
            .blur(radius: showLogin || showOTPSheet ? 3 : 0)
            .onAppear {
                fetchHomeBanners()
            }
        }
        // MARK: - LOGIN SHEET
        
        .sheet(isPresented: $showLogin) {
            VStack(alignment: .leading, spacing: 12) {
                
                Text("Login or Signup")
                    .font(.headline)
                
                HStack {
                    Text("Please enter your \(showMobile ? "mobile number" : "email address") or")
                        .font(.system(size: 12))
                    
                    Button {
                        mobile = ""
                        showMobile.toggle()
                        showError = false
                    } label: {
                        Text("continue with \(!showMobile ? "phone number" : "email")")
                            .font(.system(size: 12))
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    HStack(spacing: 8) {
                        
                        if showMobile {
                            Text("+91")
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 1, height: 24)
                            
                            TextField("Mobile Number", text: $mobile)
                                .keyboardType(.numberPad)
                                .onChange(of: mobile) {_, newValue in
                                    mobile = newValue.filter { $0.isNumber }
                                    showError = false
                                }
                            
                        } else {
                            TextField("eg. emailAddress@gmail,com", text: $mobile)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .onChange(of: mobile) {_, _ in
                                    showError = false
                                }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                showError ? Color.red : Color.gray.opacity(0.4),
                                lineWidth: 1
                            )
                    )
                    
                    //  Error Text
                    if showError {
                        Text(errorMessage)
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                            .padding(.horizontal, 4)
                    }
                }
                
                // MARK: - Button
                
                Button {
                    if showMobile {
                        validateMobile()
                    } else {
                        validateEmail()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: "lock.fill")
                        Text("Proceed Securely")
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(mobile.isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                    )
                    .foregroundColor(mobile.isEmpty ? .gray : .white)
                }
                .disabled(mobile.isEmpty)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.white)
            .presentationDetents([.height(300)])
            .presentationBackground(.white)
        }
        
        // MARK: - OTP SHEET
        
        .sheet(isPresented: $showOTPSheet) {
            OTPSheetView5(
                path: $path,
                email: mobile,
                isMobile: showMobile,
                
            )
            .presentationDetents([.height(300)])
            .presentationCornerRadius(25)
            .presentationBackground(.white)
        }
    }
    
    
    
    func validateMobile() {
        let trimmed = mobile.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            showError = true
            errorMessage = "Mobile number is required"
            return
        }
        
        if trimmed.count != 10 {
            showError = true
            errorMessage = "Enter valid 10 digit mobile number"
            return
        }
        
        showError = false
        showLogin = false
        showOTPSheet = true
    }
    
    func validateEmail() {
        let trimmedEmail = mobile.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedEmail.isEmpty {
            showError = true
            errorMessage = "Email is required"
            return
        }
        
        if !isValidEmail(trimmedEmail) {
            showError = true
            errorMessage = "Enter valid email address"
            return
        }
        
        showError = false
        showLogin = false
        showOTPSheet = true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let regex =
        #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        
        return NSPredicate(format: "SELF MATCHES %@", regex)
            .evaluate(with: email)
    }
    
    func fetchHomeBanners() {
        guard let url = URL(string: apiURL.getHomeBanner ) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(" Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(HomeBannerModel.self, from: data)
                DispatchQueue.main.async {
                    self.banners = response.data
                    self.fileBaseURL = response.filesUrl
                }
            } catch {
                print(" Decode Error:", error)
            }
        }.resume()
    }
    
}





/*import SwiftUI
import Combine

struct WelcomeView4 : View{
    
    @Binding var path : NavigationPath
    
    @State var index = 0
    @State private var banners: [HomeBannerData] = []
    @State private var fileBaseURL = ""
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State var isLoading = true
    
    @State var showMobile = false
    @State var showLogin = false
    @State var mobile = ""
    
    @State private var showOTPSheet = false
    @State private var otp = ""
    @State private var timerCount = 20

    
    var body: some View {
        VStack{
            Spacer()
            TabView(selection: $index) {
                ForEach(banners.indices, id: \.self) { i in
                    AsyncImage(
                        url: URL(string: fileBaseURL + banners[i].banner)
                    ) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page)
            .frame(height: 200)
            .onReceive(timer) { _ in
                withAnimation {
                    index = banners.isEmpty ? 0 : (index + 1) % banners.count
                }
            }
            
            Spacer()
            
            
            
            VStack(alignment: .leading,spacing: 10){
                Text("Login or Signup")
                
                HStack{
                    Text("Please enter your \(showMobile ? "mobile number" : "email address") or")
                        .font(.system(size: 11.5))
                    
                    Button{
                        showMobile.toggle()
                    }label: {
                        Text("continue with \(showMobile ? "email" : "phone number")")
                            .font(.system(size: 12))
                    }
                }
                
                Button {
                    showLogin.toggle()
                } label: {
                    HStack(spacing: 5) {
                        
                        if showMobile {
                            Text("+91")
                            
                            Rectangle()
                                .frame(width: 1, height: 28)
                            
                            Text("Mobile Number")
                        } else {
                            Rectangle()
                                .frame(width: 1, height: 28)
                                .foregroundColor(.clear)
                            
                            Text("eg. emailAddress@gmail,com")
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)   // 👈 IMPORTANT
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(lineWidth: 1)
                    )
                    .contentShape(Rectangle())    // 👈 VERY IMPORTANT
                }
                .buttonStyle(.plain)


                
            }.padding(.horizontal)
                .padding(.vertical)
                .background(Color.white)
                .shadow(color: .black.opacity(0.2),
                        radius: 10,
                        x: 0,
                        y: -5)
        }
        .sheet(isPresented: $showOTPSheet) {
            OTPSheetView4(
                email: mobile,
                otp: $otp,
                isMobile: showMobile
            )
            .frame(maxWidth: .infinity , maxHeight: .infinity)
            .presentationDetents([.height(300)])
            .background(Color.white)
            .presentationCornerRadius(25)
        }.background(.white)


        .sheet(isPresented: $showLogin){
            VStack(alignment: .leading,spacing: 10){
                Text("Login or Signup")
                
                HStack{
                    Text("Please enter your \(showMobile ? "mobile number" : "email address") or")
                        .font(.system(size: 11.5))
                    
                    Button{
                        mobile = ""
                        showMobile.toggle()
                    }label: {
                        Text("continue with \(showMobile ? "phone number" : "email")")
                            .font(.system(size: 12))
                    }
                }
                
                
                VStack(spacing: 12) {
                    
                    HStack(spacing: 8) {
                        
                        if showMobile {
                            Text("+91")
                                .foregroundColor(.black)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 1, height: 24)
                            
                            TextField("Mobile Number", text: $mobile)
                                .keyboardType(.numberPad)
                            
                                .onChange(of: mobile) {_, newValue in
                                    mobile = newValue.filter { $0.isNumber }
                                }
                            
                        } else {
                            TextField("eg. emailAddress@gmail,com", text: $mobile)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)   // 👈 IMPORTANT
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    
                    
                }
                .padding(.horizontal)
                
                
                Button {
                    otp = ""
                    showLogin.toggle()
                    showOTPSheet.toggle()
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: "lock.fill")
                        Text("Proceed Securely")
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(mobile.isEmpty ? uiColor.lightGrayText : uiColor.ButtonBlue)
                    )
                    .foregroundColor(mobile.isEmpty ? .gray : .white)
                }
                .disabled(mobile.isEmpty)
                
                
                
            }
            .frame(maxWidth: .infinity , maxHeight: .infinity)
            .padding(.horizontal)
                .padding(.vertical)
                .background(Color.white)
                .presentationDetents([.height(270)])
        }
        
        
        .navigationBarBackButtonHidden(true)
        .onAppear{
            fetchHomeBanners()
        }
    }
    
   
    
    func fetchHomeBanners() {
        guard let url = URL(string: apiURL.getHomeBanner ) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(HomeBannerModel.self, from: data)
                DispatchQueue.main.async {
                    self.banners = response.data
                    self.fileBaseURL = response.filesUrl
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
    
    
}
*/

