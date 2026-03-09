import SwiftUI
struct myCourse4 : View {
    
    @Binding var path : NavigationPath
    
    @State var courses : [MyBatch] = []
    @State var status : String = ""
    @State var message : String = ""
    
    var body: some View {
        VStack{
            if courses.isEmpty {
                ProgressView()
                    .scaleEffect(2.0)
                Rectangle()
                    .frame(maxWidth: .infinity,maxHeight: 1)
                    .foregroundColor(.clear)
            }else{
                VStack{
                    Text("My Courses")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.top )
                    
                    ScrollView{
                        ForEach( courses){ course in
                            Button{
                                
                            }label: {
                                courseCard4(path: $path, course: course)
                            }.buttonStyle(.plain)
                                .listRowSeparator(.hidden)
                        }
                        
                    }.scrollIndicators(.hidden)
                    
                }.background(uiColor.lightSystem)
                    
            }
        }.onAppear{
            fetchBatches()
        }
    }
    
    func fetchBatches() {
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        var components = URLComponents(
            string: apiURL.myCourse
        )

        components?.queryItems = [
            URLQueryItem(name: "student_id", value: student_id)
        ]

        guard let url = components?.url else {
            print("❌ Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("❌ API Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print("❌ No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(MyBatchesModel.self, from: data)
                
                DispatchQueue.main.async {
                    self.courses = decodedResponse.yourBatch ?? []
                    self.status = decodedResponse.status
                    self.message = decodedResponse.msg
                }
            } catch {
                print("❌ Decode Error:", error)
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("Missing key:", key.stringValue)
                        print("Context:", context.debugDescription)
                        print("Coding Path:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
                    case .typeMismatch(let type, let context):
                        print("Type mismatch for type:", type)
                        print("Context:", context.debugDescription)
                        print("Coding Path:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
                    case .valueNotFound(let type, let context):
                        print("Value not found for type:", type)
                        print("Context:", context.debugDescription)
                    case .dataCorrupted(let context):
                        print("Data corrupted:", context.debugDescription)
                    @unknown default:
                        print("Unknown decoding error")
                    }
                }
            }
        }.resume()
    }
    
    
}

