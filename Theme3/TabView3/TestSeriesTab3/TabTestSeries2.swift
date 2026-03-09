import SwiftUI


struct TabTestSeries2Model : Codable {
    let courseName : String
    let exam : String
}

struct TabTestSeries2: View {
    
    @Binding var path: NavigationPath
    
    @State var test: [BatchItem2Model] = []
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @State var full_url = ""
    
    @State var empty = false
    
    var body: some View {
        VStack{
            if empty {
                NotFoundView(title: "Not Available Content", about: "")
            }
            else{
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        
                        ForEach(test ) { index in
                            
                            Button{
                                path.append(Route.TestListView2(folder_id: index.id ?? "", folder_Name: index.name ?? ""))
                            }label: {
                                TestSeriesCard2(
                                    courseName: index.name ?? "",
                                    exams: String(index.totalModule ?? 0),
                                    imageURL: "\(full_url)/\(index.image ?? "")",
                                    img: "folder"
                                )
                            }.buttonStyle(.plain)
                            
                        }
                    }
                    .padding()
                }.scrollIndicators(.hidden)
            }
        }
        .background(Color.gray.opacity(0.1))
        .onAppear{
            fetchNotes()
        }
    }
    
    
    func fetchNotes() {
        let course_id = UserDefaults.standard.string(forKey: "course_id") ?? ""
        
        guard let url = URL(string: "\(apiURL.getNotes2)\(course_id)/1" ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Error:", error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(BatchResponse2Model.self, from: data)
                print("Notes TaB= \(response)")
                DispatchQueue.main.async {
                    self.test = response.allData ?? []
                    self.full_url = response.full_url ?? ""
                    
                    if test.isEmpty {
                        self.empty = true
                    }
                    
                }
            } catch {
                self.empty = true
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
}

