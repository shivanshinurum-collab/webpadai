import SwiftUI

struct AddressFormView: View {

    @Binding var path: NavigationPath

    @State private var name = UserDefaults.standard.string(forKey: "fullName") ?? ""
    @State private var email = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    @State private var phone = UserDefaults.standard.string(forKey: "mobile") ?? ""
    @State private var state = ""
    @State private var city = ""
    @State private var address = ""
    @State private var pincode = ""

    @State private var showError = false
    @State private var errorMessage = ""

    var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !phone.isEmpty &&
        !state.isEmpty &&
        !city.isEmpty &&
        !address.isEmpty &&
        !pincode.isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {

            // 🔹 Header
            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: uiString.backSize))
                        .foregroundColor(.white)
                }

                Spacer()

                Text("Shipping Address")
                    .font(.system(size: uiString.titleSize).bold())
                    .foregroundColor(.white)

                Spacer()
            }
            .padding()
            .background(uiColor.ButtonBlue)

            ScrollView {
                VStack(spacing: 16) {

                    formField("Full Name", text: $name, keyboard: .default)
                    formField("Email Address", text: $email, keyboard: .emailAddress)

                    formField("Mobile Number", text: $phone, keyboard: .numberPad)
                        .onChange(of: phone) { _, newValue in
                            phone = String(newValue.filter { $0.isNumber }.prefix(10))
                        }

                    formField("State", text: $state, keyboard: .default)
                    formField("City", text: $city, keyboard: .default)

                    addressField()

                    formField("Pincode", text: $pincode, keyboard: .numberPad)
                        .onChange(of: pincode) { _, newValue in
                            pincode = String(newValue.filter { $0.isNumber }.prefix(6))
                        }

                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    Button {
                        validateForm()
                    } label: {
                        Text("Save Address")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(uiColor.ButtonBlue)
                            .cornerRadius(12)
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Text Field
    func formField(
        _ title: String,
        text: Binding<String>,
        keyboard: UIKeyboardType
    ) -> some View {

        let isNumberField = keyboard == .numberPad

        return VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)

            TextField(title, text: text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(isNumberField ? .never : .words)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            showError && text.wrappedValue.isEmpty
                            ? Color.red
                            : Color.gray.opacity(0.3),
                            lineWidth: 1
                        )
                )
        }
    }

    // MARK: - Address Field
    func addressField() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Full Address")
                .font(.subheadline)
                .foregroundColor(.gray)

            TextEditor(text: $address)
                .frame(height: 100)
                .padding(8)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            showError && address.isEmpty
                            ? Color.red
                            : Color.gray.opacity(0.3),
                            lineWidth: 1
                        )
                )
        }
    }

    // MARK: - Validation
    func validateForm() {

        showError = true
        errorMessage = ""

        guard isFormValid else {
            errorMessage = "All fields are required"
            return
        }

        if phone.count != 10 {
            errorMessage = "Mobile number must be 10 digits"
            return
        }

        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address"
            return
        }

        // ✅ SUCCESS
        showError = false

        print("Form Submitted Successfully")
        print("Name:", name)
        print("Email:", email)
        print("Phone:", phone)
        print("State:", state)
        print("City:", city)
        print("Address:", address)
        print("Pincode:", pincode)
        
        //if(batch?.batchOfferPrice != "0"){
/*        RazorpayManager.shared.startPayment(
            amount: 1,
            description: "Test Payment"
        )
 */       //}
        
    }

    func isValidEmail(_ email: String) -> Bool {
        let regex =
        #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        return NSPredicate(format: "SELF MATCHES %@", regex)
            .evaluate(with: email)
    }
}
