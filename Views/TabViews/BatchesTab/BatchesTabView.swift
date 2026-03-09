import SwiftUI
import Combine

struct BatchesTabView : View {
    
    @Binding var path : NavigationPath
    let catId = UserDefaults.standard.string(forKey: "categoryId") ?? "0"
    @State var subCatId :String = ""
    
    @State var allCourses : [batchData] = []

    @State var subCat : [Subcategory] = []
    
    @State var showBottomSheet: Bool = false
    @State var search = ""
    @State var NoOfCourses  = 0
    
    
    @State var index = 0
    @State private var banners: [HomeBannerData] = []
    @State private var fileBaseURL = ""
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    @State var isLoading = true
    
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading,spacing: 15){
                HStack(spacing:10){
                    HStack(spacing: 10){
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 22))
                        TextField("Search for 'courses'...",text: $search)
                            .font(.system(size: 17))
                    }.padding(7)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(.gray)
                    )
                    
                    Button{
                        
                    } label: {
                        Text(" Study ")
                            .foregroundColor(.white)
                    }.padding(7)
                        .background(.violet)
                    .cornerRadius(12)
                }
                
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
                .frame(height: 200)
                .onReceive(timer) { _ in
                    withAnimation {
                        index = banners.isEmpty ? 0 : (index + 1) % banners.count
                    }
                }
                
                WebView(url: URL(string: apiURL.questionOfDay)!, isLoading: $isLoading)
                    .frame(height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .scrollIndicators(.hidden)
                
                ScrollView(.horizontal , showsIndicators: false) {
                    // WebView inside box
                   
                    
                    
                    HStack(spacing: 24){
                        
                        Button{
                            showBottomSheet.toggle()
                        }label:{
                            HStack(spacing: 6){
                                Image(systemName: "line.3.horizontal.decrease")
                                    .foregroundColor(uiColor.black)
                                Text("Filter")
                                    .foregroundColor(uiColor.DarkGrayText)
                                    .font(.system(size: 18))
                            }
                        }
                        
                        Button{
                            subCatId = ""
                            fetchBatches()
                        }label: {
                            if subCatId == "" {
                                    Text("ALL")
                                        .foregroundColor(uiColor.violet)
                                        .font(.system(size: 19))
                                        .bold()
                                        
                            }else{
                                Text("ALL")
                                    .foregroundColor(uiColor.DarkGrayText)
                                    .font(.system(size: 18))
                            }
                        }
                        
                        
                        ForEach(subCat){ cat in
                            Button{
                                subCatId = cat.id
                                fetchBatches()
                            }label: {
                                if subCatId == cat.id {
                                    Text(cat.name)
                                            .foregroundColor(uiColor.violet)
                                            .font(.system(size: 19))
                                            .bold()
                                            
                                }else{
                                    Text(cat.name)
                                        .foregroundColor(uiColor.DarkGrayText)
                                        .font(.system(size: 18))
                                }
                            }
                        }
                       
                    }
                }
                Text("\(allCourses.count) Courses Available")
                    .font(.subheadline)
                    .bold()
                    .padding(.horizontal)
                
                ScrollView{
                    VStack(spacing: 16) {
                        ForEach(allCourses) { course in
                            CourseCardView(path: $path,course: course)
                        }
                    }
                }
                
            }.sheet(isPresented: $showBottomSheet) {
                FilterBottomSheet()
                    .presentationDetents([.medium , .large])
                    .presentationDragIndicator(.visible)
            }.onAppear{
                fetchHomeBanners()
                fetchBatches()
                fetchCat()
            }
            .padding(15)
        }
    }
    func fetchCat() {

        let components = URLComponents(
            string: "\(apiURL.getSubCategoryList)\(catId)"
        )


        guard let url = components?.url else {
            print("❌ Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error {
                print("❌ API Error:", error.localizedDescription)
                return
            }

            guard let data else { return }

            do {
                let response = try JSONDecoder().decode(SubcategoryResponse.self, from: data)
                print("Batches Response = ",response)
                DispatchQueue.main.async {
                    self.subCat = response.subcategoryList
                }
            } catch {
                print("❌ Decode Error:", error)
            }

        }.resume()
    }
    
    
    func fetchBatches() {

        var components = URLComponents(
            string: apiURL.getBatchByCatSubCat
        )

        components?.queryItems = [
            URLQueryItem(name: "catId", value: catId),
            URLQueryItem(name: "subcatId", value: subCatId)
        ]

        guard let url = components?.url else {
            print("❌ Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error {
                print("❌ API Error:", error.localizedDescription)
                return
            }

            guard let data else { return }

            do {
                let response = try JSONDecoder().decode(BatchCourse.self, from: data)
                print("IDS = \(catId)")
                print("IDS = \(subCatId)")
                print(response)
                
                DispatchQueue.main.async {
                    self.allCourses = response.batchData
                }
            } catch {
                print("❌ Decode Error:", error)
            }

        }.resume()
    }
    
    func fetchHomeBanners() {
        guard let url = URL(string: apiURL.getHomeBanner ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Error:", error.localizedDescription)
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
                print("❌ Decode Error:", error)
            }
        }.resume()
    }

}

