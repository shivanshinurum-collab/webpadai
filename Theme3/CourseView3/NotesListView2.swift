import SwiftUI

struct NotesListView2: View {
    
    @Binding var path: NavigationPath
    
    let folder_id: String
    let folder_Name : String
    
    @State private var documents: [NotesContent2] = []
    @State private var baseURL: String = ""
    
    @State var empty = false
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                }
                
                Spacer()
                
                Text(folder_Name)
                
                Spacer()
                
            }
            .padding(12)
            .font(.title2)
            .foregroundColor(uiColor.white)
            .background(uiColor.ButtonBlue)
            
            
            if empty {
                NotFoundView(title: "Not Available Content", about: "")
            }
            else{
                
                ScrollView {
                    VStack(spacing: 15) {
                        
                        ForEach(documents) { item in
                            
                            let imageURL = "\(baseURL)batch_image/\(item.image ?? "")"
                            let documentURL = "\(baseURL)book/\(item.redirectionURL ?? "")"
                            
                            Button {
                                print(documentURL)
                                path.append(
                                    Route.AllDocView(
                                        title: item.name,
                                        url: documentURL
                                    )
                                )
                            } label: {
                                
                                FileView(
                                    image: documentIcon(for: documentURL),
                                    name: item.name,
                                    imageURL: imageURL,
                                    isPurchased: true
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
        }.navigationBarBackButtonHidden(true)
        .onAppear {
            fetchBatchContent()
        }
    }
}

// MARK: - File Extension Helper
extension NotesListView2 {
    
    private func documentIcon(for url: String) -> String {
        
        let ext = (url as NSString).pathExtension.lowercased()
        
        switch ext {
        case "xls", "xlsx":
            return "xls"
        case "doc", "docx":
            return "doc"
        case "pdf":
            return "pdf"
        case "txt":
            return "txt"
        case "ppt", "pptx":
            return "pptx"
        default:
            return "otherDoc"
        }
    }
}

// MARK: - API
extension NotesListView2 {
    
    func fetchBatchContent() {
        let batch_id = UserDefaults.standard.string(forKey: "batch_id") ?? ""
    
        
        let components = URLComponents(
            string: "\(apiURL.getDocItem2)\(batch_id)/\(folder_id)"
        )
        
        guard let finalURL = components?.url else {
            print("❌ Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            
            if let error {
                print("❌ API Error:", error.localizedDescription)
                return
            }
            
            guard let data else {
                print("❌ No data received")
                return
            }
            print("URL = "+"\(apiURL.getDocItem2)\(batch_id)/\(folder_id)" )
            do {
                let response = try JSONDecoder().decode(NotesContentResponse2.self, from: data)
                
                DispatchQueue.main.async {
                    self.documents = response.allData ?? []
                    self.baseURL = response.fullURL
                    
                    if documents.isEmpty {
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
