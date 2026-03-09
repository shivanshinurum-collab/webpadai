import SwiftUI
import Combine

struct HomeTab4 : View {
    
    @Binding var path : NavigationPath
    
    @State private var index = 0
    @State private var banners: [HomeBannerData] = []
    @State private var fileBaseURL = ""
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
    ]
    
    let name = "Play Store"
    
    let connect : [String] = ["youtube","instagram","facebook","telegram","twitter","linkedin"]
    
    var body : some View {
        ScrollView{
            VStack(alignment: .leading , spacing: 23){
                TabView(selection: $index) {
                    ForEach(banners.indices, id: \.self) { i in
                        AsyncImage(
                            url: URL(string: fileBaseURL + banners[i].banner)
                        ) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .tag(i)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 170)
                .onReceive(timer) { _ in
                    withAnimation {
                        index = banners.isEmpty ? 0 : (index + 1) % banners.count
                    }
                }
                
               
                VStack(alignment: .leading){
                    Text("Hi, \(name) 👋")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Text("lets learn something")
                        .font(.subheadline)
                        .foregroundColor(uiColor.DarkGrayText)
                }
                
                
                
                VStack(alignment: .leading){
                    Text("Courses")
                        .font(.headline)
                    ScrollView(.horizontal){
                        HStack(spacing: 15){
                            ForEach(1..<6){_ in
                                Button{
                                    //path.append(Route.courseContent4(buy: true))
                                }label: {
                                    VStack{
                                        Image("course")
                                            .resizable()
                                            .background(.white)
                                            .frame(width: 60 , height: 60)
                                            .clipShape(.circle)
                                        
                                        Text("course")
                                            .font(.caption)
                                            .bold()
                                        
                                    }.padding(8)
                                }.buttonStyle(.plain)
                            }
                        }
                    }.scrollIndicators(.hidden)
                }
                
                VStack(alignment: .leading){
                    Text("What Are you looking")
                        .font(.headline)
                        LazyVGrid(columns: columns) {
                            
                            Button{
                                
                            }label: {
                                HomeTabGridCard4(title: "FREE\nTests", image: "logo")
                            }.buttonStyle(.plain)
                            
                            Button{
                                
                            }label: {
                                HomeTabGridCard4(title: "FREE\nVideos", image: "logo")
                            }.buttonStyle(.plain)
                            
                            Button{
                                
                            }label: {
                                HomeTabGridCard4(title: "FREE\nMaterials",image: "logo")
                            }.buttonStyle(.plain)
                        }
                    }
                            
                
                
                VStack(alignment: .leading){
                    
                    Text("Free Videos")
                        .font(.headline)
                    
                    
                    ScrollView(.horizontal){
                        HStack(spacing: 15){
                            ForEach(1..<6){_ in
                                HomeTabVideoCard4(image: "banner", time: "00:10:15", courseName: "UPCS Course 1Shot")
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(15)
                            }
                        }
                    }.scrollIndicators(.hidden)
                    
                }
                
                VStack(alignment: .leading){
                    Text("Recent Activities")
                        .font(.headline)
                    
                    ForEach(1..<4){ _ in
                        HStack{
                            Text("●")
                                .font(.caption)
                                .foregroundColor(.red)
                            VStack(alignment: .leading){
                                Text("A new document : Book -Remedial Math ahs been added in course: 1st Year")
                                Text("2026-02-04 13:24:32")
                                    .font(.caption)
                                    .foregroundColor(uiColor.DarkGrayText)
                            }
                        }.padding()
                            .background(.white)
                            .cornerRadius(15)
                            .padding(.vertical , 7)
                    }
                }
                
                
                VStack(alignment: .leading){
                    Text("What Our Students Say")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(1..<5){_ in
                                VStack(alignment: .leading){
                                    Text(" Amazing coaching experience! The teachers are very supportive and the study material is excellent. Highly recommedded! ")
                                        .font(.caption)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(uiColor.DarkGrayText)
                                    Spacer()
                                    Text("Rahul Sharma")
                                        .font(.subheadline)
                                        .bold()
                                    Text("12th Science")
                                        .font(.caption)
                                        .foregroundColor(uiColor.DarkGrayText)
                                    Text("JEE Main 2025 - Batch A")
                                        .font(.caption)
                                        .foregroundColor(uiColor.DarkGrayText)
                                }.frame(width: 250,height: 160)
                                    .padding()
                                    .background(uiColor.cardLightBlue.opacity(0.4))
                                    .cornerRadius(15)
                                    .padding(8)
                            }
                        }
                    }.scrollIndicators(.hidden)
                }
                
                VStack(alignment: .leading){
                    Text("Connect With Us")
                        .font(.headline)
                    ScrollView(.horizontal){
                        HStack(spacing: 10){
                            ForEach(connect , id: \.self){i in
                                Button{
                                    
                                }label: {
                                    VStack{
                                        Image(i)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 60)
                                        
                                        Text(i)
                                            .font(.caption)
                                        
                                    }
                                }.buttonStyle(.plain).padding(5)
                            }
                        }
                    }.scrollIndicators(.hidden)
                    
                }
                
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName: "rectangle.fill")
                            .frame(maxWidth: 15)
                        Text("marineWisdom.com")
                    }.foregroundColor(.black)
                        .font(.subheadline)
                    HStack{
                        Image(systemName: "phone.fill")
                            .frame(maxWidth: 15)
                        Text("+91 1234567890")
                    }.foregroundColor(.black)
                        .font(.subheadline)
                }
                
                
            }.padding()
            
            
        }.background(uiColor.lightSystem)
        .onAppear{
            fetchHomeBanners()
        }
    }
    
    func fetchHomeBanners() {
        guard let url = URL(string: apiURL.getHomeBanner ) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(" Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(HomeBannerModel.self, from: data)
                DispatchQueue.main.async {
                    self.banners = response.data
                    self.fileBaseURL = response.filesUrl
                }
            } catch {
                print(" Decode Error:", error)
            }
        }.resume()
    }
    
}


