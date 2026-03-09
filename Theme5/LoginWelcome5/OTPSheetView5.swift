import SwiftUI

struct OTPSheetView5: View {
    @Binding var path : NavigationPath
    let email: String
    @State var otp: String = ""
    let isMobile : Bool
    
    @State private var timerCount = 20
    @State private var timerRunning = true
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            
            Text("Verify your \(isMobile ? "mobile number" : "email address")")
                .font(.headline)
            
            Text("Please enter the 4-digit verification code sent to you at \(email)")
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            // OTP Field
            TextField("Enter OTP here", text: $otp)
                .keyboardType(.numberPad)
                .onChange(of: otp) {_,newValue in
                    otp = String(newValue.filter { $0.isNumber }.prefix(4))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4))
                )
            
            // Resend Section
            if timerRunning {
                Text("Resend code in \(timerCount) seconds")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            } else {
                Button("Resend Code") {
                    startTimer()
                }
                .font(.system(size: 12))
            }
            
            // Verify Button
            Button {
                print("OTP BUTTON CLICKED"+otp)
                dismiss()
                path.append(Route.TabView5)
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "lock.fill")
                    Text("Verify OTP")
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(otp.count == 4 ? Color.blue : Color.gray.opacity(0.3))
                )
                .foregroundColor(otp.count == 4 ? .white : .gray)
            }
            .disabled(otp.count != 4)
            
        }
        .padding()
        .onAppear {
            startTimer()
        }
    }
    
    func startTimer() {
        timerRunning = true
        timerCount = 20
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timerCount > 0 {
                timerCount -= 1
            } else {
                timerRunning = false
                timer.invalidate()
            }
        }
    }
}
