import SwiftUI

struct ChatTabCard5 : View {
    
    var body: some View {
        HStack{
            Image("course")
                .resizable()
                .scaledToFit()
                .frame(width: 45 , height: 45)
                .padding(.trailing,10)
            
            VStack(alignment: .leading){
                HStack{
                    Text("GDC")
                        .font(.headline)
                    Spacer()
                    Text("Yesterday")
                        .font(.caption)
                }
                
                Text("Last Message will Display")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            
        }.padding()
        
    }
}
