import SwiftUI
import PhotosUI

struct EditProfile : View{
    @Binding var path : NavigationPath
    
    @State var EnrollmentId = "Enroll ID"
    @State var Email = "Email"
    @State var studentId :String = UserDefaults.standard.string(forKey: "studentId") ?? ""
    
    @State var username = "User"
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isUploading: Bool = false
    
    
    
    @State var url : String = ""
    @State var profileData : [ProfileData] = []

    var body: some View {
        
        ZStack(alignment: .top){
            HStack{
                Button{
                    path.removeLast()
                }label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: uiString.backSize))
                        .foregroundColor(uiColor.white)
                }
                Spacer()
                Text(uiString.ProfileTitle)
                    .font(.system(size: uiString.titleSize).bold())
                    .foregroundColor(uiColor.white)
                Spacer()
            }.padding(.horizontal , 15)
            ZStack{
                RoundedRectangle(cornerRadius: 45)
                    .foregroundColor(uiColor.white)
                    .ignoresSafeArea()
                    .padding(.top , 70)
                VStack(spacing: 10){
                    HStack{
                        Button{
                            
                        }label: {
                            ZStack(alignment: .bottom) {
                                
                                if let profile = profileData.first,
                                   let imageURL = URL(string: "\(url)students/\(profile.image)") {
                                    AsyncImage(url: imageURL) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                            
                                        case .failure(_):
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .foregroundColor(uiColor.gray)
                                            
                                        case .empty:
                                            ProgressView()
                                        @unknown default:
                                            ProgressView()
                                        }
                                    }
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.blue.opacity(0.8), lineWidth: 2)
                                    )
                                    
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 90, height: 90)
                                        .foregroundColor(uiColor.gray)
                                }
                                
                                
                                PhotosPicker(
                                    selection: $selectedItem,
                                    matching: .images,
                                    photoLibrary: .shared()
                                ) {
                                    ZStack {
                                        Circle()
                                            .fill(uiColor.ButtonBlue)
                                            .frame(width: 32, height: 32)
                                        
                                        if isUploading {
                                            ProgressView()
                                                .tint(.white)
                                                .scaleEffect(0.8)
                                        } else {
                                            Image(systemName: "camera.fill")
                                                .foregroundColor(uiColor.white)
                                                .font(.system(size: 14))
                                        }
                                    }
                                    .offset(x: 4, y: 4)
                                }
                                .buttonStyle(.plain)
                                .disabled(isUploading)
                            }
                            .padding(6)
                        }
                        
                        VStack(alignment: .leading){
                            Text("\(uiString.ProfileEnroll) \(EnrollmentId)")
                            Text("\(uiString.ProfileEmail) \(Email)")
                            Text("StudentId: \(studentId)")
                        }.padding(.leading)
                            .foregroundColor(uiColor.ButtonBlue)
                        
                    }
                    VStack(alignment: .leading){
                        Text(uiString.ProfileNameHead)
                            .foregroundColor(uiColor.DarkGrayText)
                        
                        TextField("Enter Name",text: $username)
                            .padding()
                            .frame(maxWidth: .infinity , maxHeight: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(.black.opacity(0.7) , lineWidth: 0.5)
                            )
                    }.padding()
                    
                    Button{
                        //updateProfile()
                    }label: {
                        Text(uiString.ProfileSaveButton)
                            .font(.title3)
                            .foregroundColor(uiColor.white)
                            .padding(.vertical , 12)
                            .padding(.horizontal , 65)
                            .background(.blue.opacity(0.8))
                            .cornerRadius(12)
                    }
                    
                    Spacer()
                }.padding(.top , 100)
            }
        }.onChange(of: selectedItem) { _,newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    
                    // Upload image immediately after selection
                    await uploadImage(uiImage)
                }
            }
        }
        .onAppear{
            fetchData()
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity)
        .background(.blue.opacity(0.8))
        .navigationBarBackButtonHidden(true)
    }
    
    
    
    func fetchData() {
        
        let components = URLComponents(
            string: "\(apiURL.getProfile)\(studentId)"
        )

        guard let url = components?.url else {
            print(" Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(" API Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print(" No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(ProfileResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.url = decodedResponse.imageUrl
                    self.profileData = decodedResponse.data ?? []
                    
                    if let profile = profileData.first{
                        Email = profile.email
                        EnrollmentId = profile.enrollment_id
                        username = profile.name
                    }
                }
            } catch {
                print(" Decode Error:", error)
            }
        }.resume()
    }
    
    
    
    func createMultipartBodyWithParams(
        image: UIImage,
        parameters: [String: String],
        imageFieldName: String,
        fileName: String,
        boundary: String
    ) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        // Add text parameters first
        for (key, value) in parameters {
            body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak)\(lineBreak)".data(using: .utf8)!)
            body.append("\(value)\(lineBreak)".data(using: .utf8)!)
        }
        
        // Add image data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return body
        }
        
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append(
            "Content-Disposition: form-data; name=\"\(imageFieldName)\"; filename=\"\(fileName)\"\(lineBreak)"
                .data(using: .utf8)!
        )
        body.append("Content-Type: image/jpeg\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append(imageData)
        body.append(lineBreak.data(using: .utf8)!)
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        return body
    }

    func uploadImage(_ image: UIImage) async {
        // Set uploading state
        await MainActor.run {
            isUploading = true
        }
        
        print(" Starting image upload...")
        
        // Create boundary
        let boundary = UUID().uuidString
        
        // Create parameters dictionary
        let parameters: [String: String] = [
            "student_id": studentId,
            "name": username,
            "password": "123456"
        ]
        
        print(" Parameters: \(parameters)")
        
        // Create multipart body with parameters
        let multipartData = createMultipartBodyWithParams(
            image: image,
            parameters: parameters,
            imageFieldName: "image",
            fileName: "photo.jpg",
            boundary: boundary
        )
        
        print(" Multipart data size: \(multipartData.count) bytes")
        
        // Create URL
        guard let url = URL(string: apiURL.profileUpdate ) else {
            print(" Invalid URL")
            await MainActor.run {
                isUploading = false
            }
            return
        }
        
        print("🌐 URL: \(url.absoluteString)")
        
        // Create custom URLSession configuration with longer timeout
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60  // 60 seconds for request
        config.timeoutIntervalForResource = 120  // 120 seconds for resource
        
        let session = URLSession(configuration: config)
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(multipartData.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = multipartData
        
        print(" Sending request...")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print(" Response Status Code: \(httpResponse.statusCode)")
                print(" Response Headers: \(httpResponse.allHeaderFields)")
                
                if httpResponse.statusCode == 200 {
                    // Parse response
                    if let responseString = String(data: data, encoding: .utf8) {
                        print(" Upload Success Response: \(responseString)")
                        
                        await MainActor.run {
                            print(" Image uploaded successfully")
                            fetchData()
                        }
                    }
                } else {
                    print(" Upload Failed with status: \(httpResponse.statusCode)")
                    if let errorString = String(data: data, encoding: .utf8) {
                        print(" Error Response: \(errorString)")
                    }
                }
            }
        } catch let error as NSError {
            print(" Upload Error Code: \(error.code)")
            print(" Upload Error Domain: \(error.domain)")
            print(" Upload Error Description: \(error.localizedDescription)")
            print(" Upload Error Info: \(error.userInfo)")
            
            if error.code == NSURLErrorTimedOut {
                print(" Request timed out - Server may be slow or unreachable")
            } else if error.code == NSURLErrorCannotConnectToHost {
                print(" Cannot connect to host - Check server URL and network")
            }
        }
        
        // Reset uploading state
        await MainActor.run {
            isUploading = false
        }
    }
    
}

