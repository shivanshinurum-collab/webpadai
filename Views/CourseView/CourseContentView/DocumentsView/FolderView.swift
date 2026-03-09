import SwiftUI

struct FoldersView: View {
    
    @Binding var path : NavigationPath
    
    let batch_id: String
    let folder_id: String
    @State var Documents: [FolderContentItem] = []
    @State var url : String = ""
    @State var purchaseCondition : Bool = false
    @State var showAlert : Bool = false
    
    var body: some View {
            HStack{
                Button{
                    path.removeLast()
                }label:{
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.system(size: uiString.backSize))
                }
                Spacer()
                Text("Folder")
                    .foregroundColor(.black)
                    .lineLimit(0)
                    .font(.system(size: uiString.titleSize).bold())
                Spacer()
            }.padding(.horizontal)
    
        
        
        ScrollView{
            
            VStack(spacing: 15){
                
                ForEach($Documents ){ $item in
                    let purchaseCodition = purchaseCondition
                    //\(uiString.baseURL)
                    //let imageURL = "https://nbg1.your-objectstorage.com/cdnsecure/app2.lmh-ai.in/uploads/batch_image/\(item.image ?? "")"
                    let imageURL = "\(apiURL.docBatchImage)\(item.image ?? "")"
                    //EXam
                    if(item.contentType == "Exam"){
                        
                        let student_id = UserDefaults.standard.string(forKey: "studentId")
                        let exam_id = item.id
                        
                        let encryptedStudent = encryptToUrlSafe(student_id!)
                        let encryptedExam = encryptToUrlSafe(exam_id)
                        
                        let examURL = "\(apiURL.docExamPanel)\(encryptedStudent)/\(encryptedExam)"
                        Button{
                            if purchaseCodition {
                                path.append(Route.ExamView(ExamUrl: examURL))
                            } else {
                                showAlert = true
                            }
                        }label: {
                            FileView(image: "exam", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                        }
                    }
                    //Folder
                    else if(item.contentType == "Folder"){
                        Button{
                            if purchaseCodition {
                                path.append(Route.FoldersView(BatchId: batch_id, FolderId: item.id))
                            } else {
                                showAlert = true
                            }
                        }label: {
                            FileView(image: "folder", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                        }
                    }
                    /*//Document - PDF
                    else if(item.contentType == "Document"){
                        let url = "\(url)book/\(item.redirectionUrl ?? "")"
                        Button{
                            path.append(Route.PDFview(url: url, title: item.name))
                            
                        }label: {
                            FileView(image: "pdf", name: item.name , imageURL: imageURL)
                        }
                    }*/
                    //Audio
                    else if(item.contentType == "Audio") {
                        Button{
                            if purchaseCodition {
                                if(item.type == "audio"){
                                    let url = "\(url)video/\(item.redirectionUrl ?? "")"
                                    path.append(Route.AudioPlayerView(url: url, title: item.name))
                                }else{
                                    
                                }
                            } else {
                                showAlert = true
                            }
                            
                        }label: {
                            FileView(image: "audio", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                        }
                    }
                    //Link
                    else if(item.contentType == "Link") {
                       
                        Button{
                            if purchaseCodition {
                                path.append(Route.ExamView(ExamUrl: item.redirectionUrl ?? ""))
                            } else {
                                showAlert = true
                            }
                        }label: {
                            FileView(image: "browser", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                        }
                        
                    }
                    //Video
                    else if(item.contentType == "Video"){
                        //let videoimg = "https://nbg1.your-objectstorage.com/cdnsecure/app2.lmh-ai.in/uploads/video/\(item.image ?? "")"
                        let videoimg = "\(apiURL.docVideoImg)\(item.image ?? "")"
                        Button{
                            if purchaseCodition {
                                if(item.type == "youtube"){
                                    path.append(Route.YouTubeView(videoId: item.redirectionUrl ?? "" , title: item.name))
                                }else{
                                    //let videoURL = "https://nbg1.your-objectstorage.com/cdnsecure/app2.lmh-ai.in/uploads/\(item.redirectionUrl ?? "")"
                                    let videoURL = "\(apiURL.docVideo)\(item.redirectionUrl ?? "")"
                                    //custom url
                                    path.append(Route.VideoView(url: videoURL, title: item.name))
                                }
                            } else {
                                showAlert = true
                            }
                        }label: {
                            FileView(image: "video", name: item.name , imageURL: videoimg, isPurchased: purchaseCodition)
                        }
                        
                    }
                    //Document - PDF
                    else if(item.contentType == "Document"){
                        
                        let url = "\(url)book/\(item.redirectionUrl ?? "")"
                        Button{
                            print(url)
                            if purchaseCodition {
                                path.append(Route.AllDocView(title: item.name, url: url))
                            } else {
                                showAlert = true
                            }
                            //path.append(Route.ExamView(ExamUrl: url))
                            //path.append(Route.PDFview(url: url, title: item.name))
                            
                        }label: {
                            if url.contains(".xls") {
                                FileView(image: "xls", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                            }
                            else if url.contains(".doc") {
                                FileView(image: "doc", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                            }
                            else if url.contains(".pdf") {
                                FileView(image: "pdf", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                            }
                            else if url.contains(".txt") {
                                FileView(image: "txt", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                            }
                            else if url.contains(".pptx") {
                                FileView(image: "pptx", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                            }
                            else{
                                FileView(image: "otherDoc", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                            }
                        }
                    }
                    
                    //Notes
                    else if(item.contentType == "notes"){
                        let url = "\(url)notes/\(item.redirectionUrl ?? "")"
                        Button{
                            if purchaseCodition {
                                path.append(Route.PDFview(url: url, title: item.name))
                            } else {
                                showAlert = true
                            }
                        }label: {
                            FileView(image: "pdf", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                        }
                    }
                
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("Alert", isPresented: $showAlert, actions: {
            Button("OK") { showAlert = false }
        }, message: {
            Text("The content yo're trying to open is locked Buy the course for compleate access")
        })
        .onAppear{
            fetchBatchContent()
        }
    }
    
    func fetchBatchContent() {
        var components = URLComponents(
            string: "\(apiURL.manageContent)\(batch_id)/\(folder_id)"
        )
        
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        components?.queryItems = [
            URLQueryItem(name: "batch_id", value: batch_id),
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
                let response = try JSONDecoder().decode(FolderContentResponse.self, from: data)
               
                DispatchQueue.main.async {
                    
                    self.purchaseCondition =  response.purchaseCondition
                    
                    self.Documents = response.allData
                    self.url = response.fullUrl
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
}
