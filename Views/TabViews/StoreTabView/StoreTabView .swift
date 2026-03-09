import SwiftUI

struct StoreTabView : View {
    
    @Binding var path : NavigationPath
    
    @State var search : String = ""
    
    @State var Tabs : [StoreCategory] = []
    @State var Courses : [StoreCourse] = []
    
    @State private var selectedCategoryId: String? = nil

    
    var filteredCourses: [StoreCourse] {
        Courses.filter { course in
            let matchesCategory =
                selectedCategoryId == nil ||
                course.categoryId == selectedCategoryId

            let matchesSearch =
                search.isEmpty ||
                course.courseName.localizedCaseInsensitiveContains(search)

            return matchesCategory && matchesSearch
        }
    }

    
    var body: some View {
        VStack(alignment: .leading ,spacing: 15){
            HStack(spacing:8){
                HStack(spacing: 10){
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 25))
                    TextField("Search Keyword",text: $search)
                        .font(.system(size: 20))
                }.padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(uiColor.ButtonBlue, lineWidth: 1.6)
                )
                .padding(7)
                .cornerRadius(12)
                    
            }
            
            Rectangle()
                .foregroundColor(uiColor.lightGrayText)
                .frame(height: 1)
            
            VStack(alignment: .leading , spacing: 20){
                Text("All Categories")
                    .font(.title3.bold())
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(Tabs) { tab in
                            Button {
                                // Toggle selection
                                if selectedCategoryId == tab.categoryId {
                                    selectedCategoryId = nil
                                } else {
                                    selectedCategoryId = tab.categoryId
                                }
                            } label: {
                                Text(tab.categoryName)
                                    .foregroundColor(
                                        selectedCategoryId == tab.categoryId
                                        ? .white
                                        : uiColor.DarkGrayText
                                    )
                                    .font(.headline)
                            }
                            .padding(9)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(
                                        selectedCategoryId == tab.categoryId
                                        ? uiColor.ButtonBlue
                                        : .clear
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(uiColor.DarkGrayText, lineWidth: 1.2)
                                    )
                            )
                            .padding(5)
                        }

                    }
                }.scrollIndicators(.hidden)
                
                Rectangle()
                    .foregroundColor(uiColor.lightGrayText)
                    .frame(height: 1)
                
                VStack(alignment: .leading){
                    Text("Digital Content")
                        .font(.title3.bold())
                    ScrollView{
                        ForEach(filteredCourses){ course in
                            Button{
                                path.append(Route.StoreAbout(Id: course.id))
                            }label: {
                                StoreItemView(course: course)
                            }.buttonStyle(.plain)
                            Rectangle()
                                .foregroundColor(uiColor.lightGrayText)
                                .frame(height: 1)
                        }
                    }
                }
                
            }.padding()
        }.padding(8)
            .onAppear{
                fetchData()
            }
    }
    
    func fetchData() {
        
        let components = URLComponents(
            string: apiURL.getStoreContent
        )

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
                let decodedResponse = try JSONDecoder().decode(StoreResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.Courses = decodedResponse.storeCourseData
                    self.Tabs = decodedResponse.storeCategoryData
                   
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
}

struct StoreItemView : View  {
    let course : StoreCourse
    
    var courseType : String = ""
    
    var body: some View {
        
        HStack(spacing: 10){
            AsyncImage(url: URL(string: course.courseImage)){ img in
                img
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 100)
            } placeholder: {
                Image("courseimage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 100)
            }
            
            VStack(alignment: .leading){
                Text(course.courseName)
                    .font(.headline.bold())
                
                if(course.paymentType == "1"){
                    Text("FREE")
                        .font(.headline.bold())
                }else{
                    HStack{
                        Text("₹\(course.courseOfferPrice)")
                            .font(.headline.bold())
                        
                        Text("₹\(course.coursePrice)")
                            .font(.headline)
                            .foregroundColor(uiColor.DarkGrayText)
                    }
                }
                if(course.courseType == "1"){
                    Text("EBOOK")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(2)
                        .padding(.horizontal,4)
                        .background(uiColor.ButtonBlue)
                        .cornerRadius(5)
                }else{
                    Text("HARD COPY")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(2)
                        .padding(.horizontal,4)
                        .background(uiColor.ButtonBlue)
                        .cornerRadius(5)
                }
                    
            }
            Spacer()
        }
    }
}


