import SwiftUI

struct NotificationCard5 : View {
    
    let Head : String = "Notification Headline"
    let subHead :String = "Notification Sub HeadLine"
    let image :String = "banner"
    let time : String = "2026/12/17 , 05:11pm"
    
    var body : some View {
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "bell")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.blue)
                        .background(uiColor.verylightBlue)
                        .clipShape(.circle)
                        .padding(.trailing , 5)
                    
                    VStack(alignment: .leading){
                        Text(Head)
                            .font(.headline)
                        Text(subHead)
                            .font(.subheadline)
                    }
                    Spacer()
                }
                VStack(alignment: .leading){
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 140)
                    
                    HStack{
                        Image(systemName: "clock")
                            .font(.caption)
                        Text(time)
                            .font(.caption2)
                    }
                }.padding(.leading , 77)
            
            Spacer()
        }
        .padding()
    }
}
