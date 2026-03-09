import SwiftUI

struct CourseList5 : View{
    @Binding var path : NavigationPath
    
    @State var search : String = ""
    @State var showCat : Bool = false
    
    
    var body: some View{
        HStack {
            Button{
                path.removeLast()
            }label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
            }.buttonStyle(.plain)
            
            Text("Courses List View")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.leading, 8)
            
            Spacer()
        }
        .padding()
        .background(Color.blue)
        
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
                
                HStack{
                    Text("Courses (15)")
                    Spacer()
                    
                    Button{
                        
                    }label: {
                        Image("funnel")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22)
                    }.buttonStyle(.plain)
                }
                
                ScrollView{
                    ForEach(1..<10){_ in
                        CourseCardCourse5(image: "banner", name: "Courses", price: "1799", oprice: "3999")
                        
                        Rectangle()
                            .frame(maxWidth: .infinity , maxHeight: 1.5)
                            .foregroundColor(uiColor.system)
                    }
                }.scrollIndicators(.hidden)
                
            }.padding()
            
            
            
        }.navigationBarBackButtonHidden(true)
        .scrollIndicators(.hidden)
        .refreshable {
            print("Refresh Page")
        }
    }
}


