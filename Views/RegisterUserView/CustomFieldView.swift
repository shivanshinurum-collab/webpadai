import SwiftUI

struct RegisterLocationView: View {
    @Binding var path: NavigationPath

    @State private var fields: [CustomField] = []
    @State private var fieldValues: [String: String] = [:]
    @State private var errorFields: Set<String> = []
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {

            // MARK: - Header
            ZStack {
                uiColor.ButtonBlue
                    .ignoresSafeArea(edges: .top)

                HStack {
                    Button {
                        path.removeLast()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: uiString.backSize))
                    }

                    Spacer()

                    Text("Custom Field")
                        .foregroundColor(.white)
                        .font(.system(size: uiString.titleSize).bold())

                    Spacer()
                }
                .font(.title2.bold())
                .padding(.horizontal)
                .padding(.top, 40)
            }
            .clipShape(
                RoundedCorner(radius: 25, corners: [.bottomLeft, .bottomRight])
            ).ignoresSafeArea()
            .frame(height: 60)

            // MARK: - Dynamic Fields
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    ForEach(fields) { field in
                        VStack(alignment: .leading, spacing: 6) {

                            Text("\(field.fieldName)\(field.isRequired ? "*" : "")")

                            TextField(
                                "Please enter \(field.fieldName.lowercased())",
                                text: Binding(
                                    get: { fieldValues[field.id, default: ""] },
                                    set: { fieldValues[field.id] = $0 }
                                )
                            )
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 11)
                                    .stroke(
                                        errorFields.contains(field.id)
                                        ? Color.red
                                        : uiColor.ButtonBlue,
                                        lineWidth: 2
                                    )
                            )
                            .onChange(of: fieldValues[field.id]) { _, _ in
                                errorFields.remove(field.id)
                                errorMessage = ""
                            }
                        }
                    }

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding()
            }

            Spacer()

            // MARK: - Continue Button
            Button(action: validateFields) {
                Text("Continue")
                    .foregroundColor(.white)
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(uiColor.ButtonBlue)
                    .cornerRadius(25)
            }
            .padding()
        }
        .onAppear(perform: fetchFields)
        .onTapGesture {
            dismissKeyboard()
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Validation
    func validateFields() {
        errorFields.removeAll()

        for field in fields where field.isRequired {
            let value = fieldValues[field.id, default: ""]
                .trimmingCharacters(in: .whitespacesAndNewlines)

            if value.isEmpty {
                errorFields.insert(field.id)
            }
        }

        if !errorFields.isEmpty {
            errorMessage = "Please fill all required fields"
            return
        }

        guard let encodedPayload = buildCustomFieldPayload() else {
            errorMessage = "Failed to prepare data"
            return
        }

        submitCustomFields(encodedPayload)
    }

    // MARK: - Build Payload
    func buildCustomFieldPayload() -> String? {
        let payload = fields.map {
            CustomFieldPayload(
                fieldType: $0.fieldType,
                fieldName: $0.fieldName,
                fieldAnswer: fieldValues[$0.id, default: ""]
            )
        }

        do {
            let jsonData = try JSONEncoder().encode(payload)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        } catch {
            print("❌ Encoding error:", error)
            return nil
        }
    }

    // MARK: - Submit API
    func submitCustomFields(_ customFieldArray: String) {
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        guard let url = URL(string: apiURL.updateCustomDetail) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyString =
            "custom_field_array=\(customFieldArray)&student_id=\(student_id)"

        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("❌ API Error:", error.localizedDescription)
                return
            }

            print("📥 Response:", String(data: data ?? Data(), encoding: .utf8) ?? "")

            DispatchQueue.main.async {
                path.append(Route.SelectGoalView)
            }
        }.resume()
    }


    // MARK: - Fetch Fields
    func fetchFields() {
        guard let url = URL(string: apiURL.getCustomField)
        else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("❌ Error:", error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(CustomFieldResponse.self, from: data)
                DispatchQueue.main.async {
                    fields = response.result
                    response.result.forEach { fieldValues[$0.id] = "" }
                }
            } catch {
                print("❌ Decode Error:", error.localizedDescription)
            }
        }.resume()
    }
}



