import SwiftUI

struct TestListView2 : View {
    @Binding var path : NavigationPath
    
    let folder_id: String
    let folder_Name : String
    
    @State private var documents: [NotesContent2] = []
    @State private var baseURL: String = ""
    
    @State var empty = false
    var body : some View {
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
                ScrollView{
                    ForEach(documents){item in
                        let student_id = UserDefaults.standard.string(forKey: "studentId")
                        let exam_id = item.id
                        
                        let encryptedStudent = encryptToUrlSafe(student_id!)
                        let encryptedExam = encryptToUrlSafe(exam_id)
                        
                        let examURL = "\(apiURL.docExamPanel)\(encryptedStudent)/\(encryptedExam)"
                        
                        Button{
                            path.append(Route.ExamInfo(title: item.insTitle ?? "", dis: item.insDesc ?? "", url: examURL))
                        }label: {
                            TestListItem2(name: item.name, date: item.createdDate , question: String(item.mcqCount ?? 0))
                        }.buttonStyle(.plain)
                        
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
            .onAppear{
                fetchBatchContent()
            }
    }
    
    func fetchBatchContent() {
        let batch_id = UserDefaults.standard.string(forKey: "batch_id") ?? ""
    
        
        let components = URLComponents(
            string:"\(apiURL.getTestItem2)\(batch_id)/\(folder_id)"
            //"https://limbusmed.com/api/Theme3/getListByType/Exam/3/9"
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

struct TestListItem2 : View {
    let name :String
    let date : String
    let question : String
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text("\(name)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text("\(question) Questions • \(date)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                
                Image(systemName: "newspaper")
                    .font(.system(size: 18))
                
                Image(systemName: "trophy")
                    .font(.system(size: 18))
            }
            .foregroundColor(.black)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.28), radius: 4, x: 0, y: 2)
        .padding(.horizontal,6)
    }
}

