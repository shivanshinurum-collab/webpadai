import SwiftUI

struct CourseCardCourse5 : View {
    let image:String
    let name :String
    let price :String
    let oprice:String
    
    var body: some View {
        HStack{
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 150 )
            
            
            
            VStack(alignment: .leading){
                HStack{
                    Text("LIVE CLASS")
                        .padding(4)
                        .background(uiColor.system)
                    
                    Text("FREE CONTENT")
                        .padding(4)
                        .background(uiColor.system)
                    
                    Text("TESTS")
                        .padding(4)
                        .background(uiColor.system)
                    
                }.foregroundColor(.black)
                    .font(.system(size: 10))
                
                Text(name)
                    .font(.system(size: 12))
                    .multilineTextAlignment(.leading)
                    .padding(.vertical , 5)
                
                HStack(spacing: 10){
                    Text("₹\(price)/-")
                        .font(.headline)
                    
                    Text("₹\(oprice)")
                        .font(.caption)
                        .foregroundColor(uiColor.DarkGrayText)
                    
                    Text("\("55").0% OFF")
                        .font(.caption)
                        .foregroundColor(uiColor.Error)
                    
                }
                
            }
        }.padding()
    }
}


