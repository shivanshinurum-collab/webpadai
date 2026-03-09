import SwiftUI

struct BooksTabView5:View{
    @Binding var path : NavigationPath
    @State var search : String = ""
    @State var showCat : Bool = false
    
    
    var body: some View{
        ScrollView{
            VStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                    TextField("Search for courses",text: $search)
                    
                }.padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 1)
                    )
            }.padding()
            
            
            VStack(alignment: .leading){
                Text("Books (41)")
                
                ScrollView{
                    ForEach(1..<10){_ in
                        Button{
                            path.append(Route.CourseBuy5)
                        }label: {
                            CourseCardCourse5(image: "banner", name: "Courses", price: "1799", oprice: "3999")
                        }.buttonStyle(.plain)
                        
                        Rectangle()
                            .frame(maxWidth: .infinity , maxHeight: 1.5)
                            .foregroundColor(uiColor.system)
                    }
                }.scrollIndicators(.hidden)
                
            }.padding()
            
            Button{
                path.append(Route.CourseList5)
            }label: {
                Text("View All Books")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity , maxHeight: 15)
                
            }.buttonStyle(.plain)
                .padding()
                .background(uiColor.ButtonBlue)
                .cornerRadius(15)
                .padding()
            
        }
        .scrollIndicators(.hidden)
        .refreshable {
            print("Refresh Page")
        }
    }
}
