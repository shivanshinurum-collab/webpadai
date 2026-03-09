import SwiftUI
struct courseContent4 : View {
    
    @Binding var path : NavigationPath
    
    let batchName : String
    let description : String
    let id : String
    let image : String
    //let batch_id : String = "32"
    
    @State var Documents : [ContentItem] = []
    @State var url : String = ""
    @State var purchaseCondition : Bool = false
    @State var showAlert = false
    
    @State var readMore : Bool = false
    
    var body : some View {
        HStack{
            Button{
                path.removeLast()
            }label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
            }
            Spacer()
            
            Text(batchName)
                .font(.system(size: uiString.titleSize))
                .lineLimit(0)
                .foregroundColor(.white)
            Spacer()
            
            Button{
                
            }label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.white)
                    .font(.title3)
            }
        }.padding(10)
            .bold()
            .background(uiColor.ButtonBlue)
        
        ScrollView{
            VStack(alignment: .leading , spacing: 20){
                HStack{
                    AsyncImage(url: URL(string: image)){img in
                        img
                            .resizable()
                            .scaledToFit()
                    }placeholder: {
                        ProgressView()
                            .scaleEffect(1.6)
                    }
                    VStack(alignment: .leading){
                        Text(batchName)
                            .font(.headline)
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(uiColor.DarkGrayText)
                            .lineLimit(readMore ? 5 : 2)
                        Button{
                            readMore.toggle()
                        }label: {
                            Text("Read more")
                        }
                    }
                }
                
                
                /*                VStack(alignment: .leading){
                 Text("Documents")
                 .font(.headline)
                 
                 HStack(spacing: 15){
                 Image(systemName: "text.document.fill")
                 .font(.headline)
                 .frame(width: 50 , height: 50)
                 .foregroundColor(.green)
                 .background(uiColor.lightSystem)
                 .cornerRadius(15)
                 
                 VStack(alignment: .leading){
                 Text("ICG GCP")
                 .font(.headline)
                 
                 Text("Document • Book")
                 }.foregroundColor(uiColor.DarkGrayText)
                 
                 Spacer()
                 
                 Button{
                 
                 }label: {
                 Text("Open")
                 .padding(10)
                 .padding(.horizontal)
                 .foregroundColor(.green)
                 .bold()
                 }.buttonStyle(.plain)
                 .background(
                 RoundedRectangle(cornerRadius: 15)
                 .stroke(.green , lineWidth: 2)
                 )
                 }
                 .padding()
                 .background(
                 RoundedRectangle(cornerRadius: 15)
                 .stroke(uiColor.lightGrayText , lineWidth: 2)
                 )
                 }
                 
                 VStack(alignment: .leading){
                 Text("Videos")
                 .font(.headline)
                 
                 HStack(spacing: 15){
                 Image(systemName: "video.fill")
                 .font(.headline)
                 .frame(width: 50 , height: 50)
                 .foregroundColor(.red)
                 .background(uiColor.lightSystem)
                 .cornerRadius(15)
                 
                 VStack(alignment: .leading){
                 Text("ICG GCP")
                 .font(.headline)
                 
                 Text("Video • YouTube")
                 }.foregroundColor(uiColor.DarkGrayText)
                 
                 Spacer()
                 
                 Button{
                 
                 }label: {
                 HStack{
                 Image(systemName: "play.fill")
                 Text("Play")
                 }
                 .font(.subheadline)
                 .padding(10)
                 .padding(.horizontal , 10)
                 .foregroundColor(.red)
                 .bold()
                 }.buttonStyle(.plain)
                 .background(
                 RoundedRectangle(cornerRadius: 15)
                 .stroke(.red , lineWidth: 2)
                 )
                 }
                 .padding()
                 .background(
                 RoundedRectangle(cornerRadius: 15)
                 .stroke(uiColor.lightGrayText , lineWidth: 2)
                 )
                 }
                 
                 
                 }.padding()
                 
                 }.scrollIndicators(.hidden)
                 .navigationBarBackButtonHidden(true)
                 */
                
                ScrollView{
                    
                    VStack(alignment: .leading ,spacing: 15){
                        Text("Study Material")
                            .font(.headline)
                        
                        ForEach($Documents ){ $item in
                            let purchaseCodition = purchaseCondition
                            let imageURL = "\(url)batch_image/\(item.image ?? "")"
                            //EXam
                            if(item.contentType == "Exam"){
                                
                                let student_id = UserDefaults.standard.string(forKey: "studentId")
                                let exam_id = item.id
                                
                                let encryptedStudent = encryptToUrlSafe(student_id!)
                                let encryptedExam = encryptToUrlSafe(exam_id)
                                
                                let examURL = "\(apiURL.docExamPanel)\(encryptedStudent)/\(encryptedExam)"
                                Button{
                                    if purchaseCodition {
                                        path.append(Route.ExamInfo(title: item.insTitle ?? "", dis: item.insDesc ?? "", url: examURL))
                                    } else {
                                        showAlert = true
                                    }
                                }label: {
                                    FileView(image: "exam", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                                }
                                
                                if(item.isResultAvailable == 1 ){
                                    HStack{
                                        Button{
                                            
                                        }label: {
                                            Text("View Result")
                                        }.frame(maxWidth: .infinity)
                                        Button{
                                            
                                        }label: {
                                            Text("Leaderboard")
                                        }.frame(maxWidth: .infinity)
                                    }
                                }
                            }
                            //Folder
                            else if(item.contentType == "Folder"){
                                
                                Button{
                                    
                                    if purchaseCodition {
                                        path.append(Route.FoldersView(BatchId: id, FolderId: item.id))
                                    } else {
                                        showAlert = true
                                    }
                                    
                                }label: {
                                    FileView(image: "folder", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                                }
                            }
                            
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
                                    if purchaseCondition {
                                        path.append(Route.ExamView(ExamUrl: item.redirectionUrl ?? ""))
                                    } else {
                                        showAlert = true
                                    }
                                    
                                }label: {
                                    FileView(image: "browser", name: item.name , imageURL: imageURL, isPurchased: self.purchaseCondition)
                                }
                                
                            }
                            //Video
                            else if(item.contentType == "Video"){
                                let videoimg = "\(url)video/\(item.image ?? "")"
                                Button{
                                    if purchaseCodition {
                                        if(item.type == "youtube"){
                                            path.append(Route.YouTubeView(videoId: item.redirectionUrl ?? "" , title: item.name))
                                        }else{
                                            let videoURL = "\(url)\(item.redirectionUrl ?? "")"
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
                            //Notes
                            else if(item.contentType == "notes"){
                                
                                let url = "\(url)notes/\(item.redirectionUrl ?? "")"
                                Button{
                                    print(url)
                                    if purchaseCodition {
                                        path.append(Route.PDFview(url: url, title: item.name))
                                    } else {
                                        showAlert = true
                                    }
                                }label: {
                                    FileView(image: "pdf", name: item.name , imageURL: imageURL, isPurchased: purchaseCodition)
                                }
                            }
                            //Document - PDF
                            else if(item.contentType == "Document"){
                                
                                let url = "\(url)book/\(item.redirectionUrl ?? "")"
                                Button{
                                    print(url)
                                    if purchaseCodition {
                                        path.append(Route.AllDocView(title: item.name, url: url))
                                        //path.append(Route.ExamView(ExamUrl: url))
                                        //path.append(Route.PDFview(url: url, title: item.name))
                                    } else {
                                        showAlert = true
                                    }
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
                            
                        }
                    }.padding(.horizontal)
                    //.screenshotProtected()
                }
                .navigationBarBackButtonHidden(true)
                .scrollIndicators(.hidden)
                .alert("Alert", isPresented: $showAlert, actions: {
                    Button("OK") { showAlert = false }
                }, message: {
                    Text("The content yo're trying to open is locked Buy the course for compleate access")
                })
                .onAppear{
                    fetchBatchContent()
                }
                
                
            }
        }
                if !purchaseCondition {
                    ZStack{
                        Color(
                            red: 59/255,
                            green: 56/255,
                            blue: 56/255
                        )
                        .ignoresSafeArea()
                        HStack{
                            VStack(alignment: .leading){
                                HStack{
                                    Text("₹15000")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(Color(
                                            red: 245/255,
                                            green: 27/255,
                                            blue: 2/255
                                        ))
                                    
                                    Text("6% OFF")
                                        .font(.headline)
                                        .foregroundColor(Color(
                                            red: 30/255,
                                            green: 156/255,
                                            blue: 44/255
                                        ))
                                        .padding(7)
                                        .background(Color(
                                            red: 178/255,
                                            green: 237/255,
                                            blue: 215/255
                                        ))
                                        .cornerRadius(15)
                                }
                                Text("₹16000 Limited Time Offer")
                                    .font(.subheadline)
                                    .foregroundColor(Color(
                                        red: 117/255,
                                        green: 116/255,
                                        blue: 117/255
                                    ))
                            }
                            
                            
                            Spacer()
                            Button{
                                path.append(Route.courseBuy4)
                            }label: {
                                HStack{
                                    Image(systemName: "cart.fill")
                                    
                                    Text("Buy Now")
                                }.font(.title3)
                                    .bold()
                                    .foregroundColor(Color(
                                        red: 245/255,
                                        green: 27/255,
                                        blue: 2/255
                                    ))
                                    .padding(12)
                                    .padding(.horizontal,10)
                                    .background(.white)
                                    .cornerRadius(20)
                                
                            }
                        }.padding()
                    }.frame(height: 30)
                        .ignoresSafeArea()
                }
                
            
        
        
    }
    
    func fetchBatchContent() {
        
        var components = URLComponents(
            string: "\(apiURL.manageContent)\(id)"
        )
        
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        
        components?.queryItems = [
            URLQueryItem(name: "batch_id", value: id),
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
                let response = try JSONDecoder().decode(BatchContentResponse.self, from: data)
               
                DispatchQueue.main.async {
                    self.purchaseCondition = response.purchaseCondition
                    self.Documents = response.allData
                    self.url = response.fullUrl
                    
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
    
}
