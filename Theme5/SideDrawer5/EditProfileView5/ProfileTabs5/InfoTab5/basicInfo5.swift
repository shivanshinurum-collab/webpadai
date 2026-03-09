import SwiftUI

struct basicInfo5 : View {
    var body : some View {
        VStack(alignment: .leading , spacing: 15){
            Rectangle()
                .frame(height: 1)
                .foregroundColor(uiColor.system)
            HStack(spacing: 20){
                Image(systemName: "person")
                VStack(alignment: .leading){
                    Text("Name")
                    Text("Test")
                }
                
                Spacer()
            }
            
            HStack(spacing: 20){
                Image(systemName: "number")
                VStack(alignment: .leading){
                    Text("Mobile Number")
                    Text("911234567890")
                }
                
                Spacer()
            }
            
            HStack(spacing: 20){
                Image(systemName: "envelope")
                VStack(alignment: .leading){
                    Text("Email")
                    Text("abcd12@gmail,com")
                }
                
                Spacer()
            }
            
            HStack(spacing: 20){
                Image(systemName: "i.circle")
                VStack(alignment: .leading){
                    Text("About")
                    Text("_______________")
                        .foregroundColor(uiColor.system)
                }
                
                Spacer()
            }
            
            HStack(spacing: 20){
                Image(systemName: "number")
                VStack(alignment: .leading){
                    Text("Roll Number")
                    Text("_______________")
                        .foregroundColor(uiColor.system)
                }
                
                Spacer()
            }
            
            HStack(spacing: 20){
                Image(systemName: "calendar")
                VStack(alignment: .leading){
                    Text("Date of Joining")
                    Text("_______________")
                        .foregroundColor(uiColor.system)
                }
                
                Spacer()
            }
            
           
            
        }.padding()
            .font(.caption)
    }
}


