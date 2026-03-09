
import SwiftUI

struct CourseTabView5:View{
    @Binding var path: NavigationPath
    
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
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 8)
                .foregroundColor(uiColor.system)
            
            VStack(alignment: .leading){
                Text("Courses IN")
                    .font(.caption)
                
                Button{
                    showCat.toggle()
                }label: {
                    Text("All Categories")
                    Image(systemName: "chevron.down")
                        .foregroundColor(.black)
                        .font(.title2)
                    
                }
                ScrollView(.horizontal){
                    HStack{
                        ForEach(1..<7){_ in
                            Button{
                                
                            }label: {
                                Text("Category")
                                    .padding(.horizontal)
                                    .padding(.vertical , 7)
                            }.background(.white)
                                .cornerRadius(15)
                                .shadow(color: uiColor.gray, radius: 3)
                                .padding(5)
                                .buttonStyle(.plain)
                        }
                    }
                }.scrollIndicators(.hidden)
                 
            }.padding()
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 8)
                .foregroundColor(uiColor.system)
            
            
            VStack(alignment: .leading){
                Text("Courses (150)")
                
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
                Text("View All Courses")
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

