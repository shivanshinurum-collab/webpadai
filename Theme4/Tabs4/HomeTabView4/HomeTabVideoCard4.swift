import SwiftUI

struct HomeTabVideoCard4 : View {
    
    let image : String
    let time : String
    let courseName : String
    
    var body : some View {
        VStack(alignment: .leading){
            ZStack(alignment: .center){
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
                Image(systemName: "play.circle")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                
                HStack{
                    Image(systemName: "play.circle")
                        .font(.system(size: 20))
                    Text(time)
                }.padding(5)
                    .foregroundColor(.white)
                    .background(uiColor.DarkGrayText)
                    .padding(6)
                .frame(maxWidth: .infinity , maxHeight: .infinity , alignment: .bottomTrailing)
                
            }.frame(width: 300,height: 218)
            
            Text(courseName)
            
            Button{
                
            }label: {
                Text("View Course >")
                    .foregroundColor(.red)
            }
        }
    }
}
