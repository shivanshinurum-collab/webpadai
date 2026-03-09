import SwiftUI
struct courseCard4 : View {
    
    @Binding var path : NavigationPath
    
    let course : MyBatch
    
    let image : String = "banner"
    let head : String = "Clinical Research"
    let subHead : String = "Testing"
    
    var body : some View {
        VStack(spacing:15){
            HStack{
                
                AsyncImage(url: URL(string: course.batchImage)){img in
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                }placeholder: {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(width: 100)
                }
                
                VStack(alignment: .leading){
                    Text(course.batchName)
                        .font(.headline)
                        .foregroundColor(.black)
                    Text(html.htmlToAttributedString(course.description))
                        .font(.body)
                        .lineLimit(2)
                        .foregroundColor(uiColor.DarkGrayText)
                }
                Spacer()
            }
            HStack{
                Image(systemName: "clock")
                Text("Active")
                
                Spacer()
                
                Image(systemName: "person.2.fill")
                Text("\(course.noOfStudent) students")
            }.padding(.horizontal)
                .foregroundColor(uiColor.DarkGrayText)
            
            HStack{
                Button{
                    path.append(Route.courseContent4(batchName: course.batchName, description: course.description, id: course.id , image: course.batchImage))
                }label: {
                    HStack{
                        Image(systemName: "play.fill")
                        Text("Explore")
                    }.padding(10)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .bold()
                }.buttonStyle(.plain)
                    .background(.red)
                    .cornerRadius(15)
                
                Button{
                    path.append(Route.courseContent4(batchName: course.batchName, description: course.description, id: course.id , image: course.batchImage))
                }label: {
                    HStack{
                        Image(systemName: "heart.fill")
                        Text("Purchased")
                    }.padding(10)
                        //.padding(.horizontal)
                        .foregroundColor(.green)
                        .bold()
                }.buttonStyle(.plain)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.green , lineWidth: 2)
                    )
                    
                
            }
        }
        .padding()
        .background(.white)
            .cornerRadius(15)
            //.shadow(color: uiColor.DarkGrayText, radius: 1)
            .padding(5)
    }
}

