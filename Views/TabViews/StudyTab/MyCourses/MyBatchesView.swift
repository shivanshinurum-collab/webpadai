import SwiftUI

struct MyBatchesView : View{
    
    @Binding var path : NavigationPath
    
    @State var courses : [MyBatch] = []
    @State var status : String = ""
    @State var message : String = ""
    
    var body: some View {
        ZStack{
            Color.blue.opacity(0.8)
                .ignoresSafeArea()
            HStack{
                Button{
                    path.removeLast()
                }label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: uiString.backSize))
                }
                Spacer()
                Text("My Batches")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.titleSize).bold())
                Spacer()
            }.padding(10)
        }
        .frame(maxWidth: .infinity , maxHeight: 50)
        
        VStack(){
            if(status != "false"){
                ScrollView{
                    ForEach( courses){ course in
                        Button{
                            path.append(Route.BuyCourseView(course_id: course.id, course_name: course.batchName))
                        }label: {
                            BatchesCardView(image: course.batchImage, titile: course.batchName , active: true)
                        }.buttonStyle(.plain)
                            .listRowSeparator(.hidden)
                    }.scrollIndicators(.hidden)
                }.background(Color(.systemGray6))
            }else{
                NotFoundView(title: message, about: "")
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
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

struct BatchesCardView : View {
    var image : String
    var titile : String
    var active : Bool
    
    var body : some View {
        
        
        HStack{
            AsyncImage(url: URL(string: image)){ img in
                img
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 100)
                    .padding(10)
            } placeholder : {
                //ProgressView()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 100)
                    .padding(10)
            }
                
            VStack(alignment: .leading){
                Text(titile)
                    .font(.title3.bold())
                
                if(active){
                    Text("ACTIVE")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding( .vertical ,2)
                        .padding(.horizontal , 10)
                        .background(.blue.opacity(0.8))
                        .cornerRadius(7)
                }
                
            }
            Spacer()
          
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.12),
                    radius: 10, x: 5, y: 5)
            .padding(5)
    }
}
