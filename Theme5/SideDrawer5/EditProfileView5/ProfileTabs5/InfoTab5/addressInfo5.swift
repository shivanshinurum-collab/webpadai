import SwiftUI

struct addressInfo5 : View {
    var body : some View {
        VStack(alignment: .leading , spacing: 15){
            Rectangle()
                .frame(height: 1)
                .foregroundColor(uiColor.system)
            
            HStack(spacing: 20){
                Image(systemName: "map")
                VStack(alignment: .leading){
                    Text("Permanent Address")
                    Text("_______________________")
                        .foregroundColor(uiColor.system)
                }
                
                Spacer()
            }
            
            HStack(spacing: 20){
                Image(systemName: "pin")
                VStack(alignment: .leading){
                    Text("Permanent Address PIN Code")
                    Text("_______________________")
                        .foregroundColor(uiColor.system)
                }
                
                Spacer()
            }
            
            HStack(spacing: 20){
                Image(systemName: "map")
                VStack(alignment: .leading){
                    Text("Correspondence Address")
                    Text("_______________________")
                        .foregroundColor(uiColor.system)
                }
                
                Spacer()
            }
            
            
            HStack(spacing: 20){
                Image(systemName: "pin")
                VStack(alignment: .leading){
                    Text("Correspondence Address PIN Code")
                    Text("_______________________")
                        .foregroundColor(uiColor.system)
                }
                
                Spacer()
            }
            
            
            
        }.padding()
            .font(.caption)
    }
}

