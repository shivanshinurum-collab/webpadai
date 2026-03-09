import SwiftUI
struct LiveClassView : View {
    
    @Binding var path : NavigationPath
    
    let batch_id : String
    let student_id = UserDefaults.standard.string(forKey: "studentId")
    
    @State var liveClass : [LiveClass] = []
    
    var body: some View {
        VStack{
            
            ScrollView{
                ForEach(liveClass){ live in
                    Button{
                        if(live.type == "youtube"){
                            let videoId = extractYouTubeVideoID(from: live.joinUrl)
                            print("Video ID = \(videoId ?? "")")
                            path.append(Route.YouTubeView(videoId: videoId ?? "" , title: live.title))
                        }else{
                            path.append(Route.AllDocView(title: live.title, url: live.joinUrl))
                        }
                        
                    }label: {
                        HStack{
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80 , height: 80)
                            VStack(alignment: .leading){
                                Text("\(live.title)")
                                    .font(.subheadline)
                                Text("Live Now")
                                    .font(.subheadline)
                                    .foregroundColor(uiColor.DarkGrayText)
                            }
                            Spacer()
                            
                            Text("LIVE")
                                .padding(5)
                                .foregroundColor(.white)
                                .background(.red)
                                .cornerRadius(15)
                        }
                    }
                    
                }
            }
            
        }.onAppear{
            fetchData()
        }
    }
    
    
    func extractYouTubeVideoID(from urlString: String) -> String? {
        guard let url = URL(string: urlString) else { return nil }

        // youtu.be short link
        if url.host?.contains("youtu.be") == true {
            return url.pathComponents.last
        }

        // youtube.com/watch?v=
        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
            return queryItems.first(where: { $0.name == "v" })?.value
        }

        return nil
    }

    
    func fetchData() {
        
        var components = URLComponents(
            string: apiURL.checkActiveLiveClass
        )
        
        components?.queryItems = [
            URLQueryItem(name: "batch_id", value: "32" ),
            //URLQueryItem(name: "batch_id", value: batch_id ),
            URLQueryItem(name: "student_id", value: student_id )
        ]
        
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
                let decodedResponse = try JSONDecoder().decode(LiveClassResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.liveClass = decodedResponse.liveClass ?? []
                }
            } catch {
                print(" Decode Error:", error)
            }
        }.resume()
    }
    
}

