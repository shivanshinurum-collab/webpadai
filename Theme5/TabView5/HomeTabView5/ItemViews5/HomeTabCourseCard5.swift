import SwiftUI

struct HomeTabCourseCard5 : View {
    let image  :String
    let name : String
    let price : String
    let oprice : String
    
    var body: some View {
        VStack{
            VStack(alignment: .leading,spacing: 30){
                Image(image)
                    .resizable()
                    .scaledToFit()
                HStack{
                    Text("LIVE CLASS")
                        .padding(5)
                        .background(uiColor.system)
                    
                    Text("FREE CONTENT")
                        .padding(5)
                        .background(uiColor.system)
                    
                    Text("TESTS")
                        .padding(5)
                        .background(uiColor.system)
                    
                }.foregroundColor(.black)
                    .font(.caption2)
                
                Text(name)
                
                
                HStack(spacing: 15){
                    Text("₹\(price)/-")
                    
                    Text("₹\(oprice)")
                        .font(.caption)
                        .foregroundColor(uiColor.DarkGrayText)
                    
                    Text("\("55").0% OFF")
                        .font(.caption)
                        .foregroundColor(uiColor.Error)
                    
                }.padding(.vertical,25)
                
                Divider()
                
                Button{
                    
                }label: {
                    Text("Get this course")
                        .frame(maxWidth: .infinity , maxHeight: 25)
                        .foregroundColor(.white)
                        .padding()
                }.background(uiColor.ButtonBlue)
                    .cornerRadius(15)
                
            }.padding()
        }
        .background(.white)
        .cornerRadius(15)
        .shadow(color: uiColor.lightGrayText , radius: 5)
        .frame(width: 350)
    }
}

