import SwiftUI

struct ChatsTabView5:View{
    @Binding var path : NavigationPath
    
    @State var search : String = ""
    var body: some View{
        ScrollView{
            VStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                    TextField("Search by name or number",text: $search)
                    
                }.padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 1)
                    )
            }.padding()
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 8)
                .foregroundColor(uiColor.system)
            
            VStack(alignment: .leading){
                Text("Messages")
                    .font(.headline)
                
                Button{
                    
                }label: {
                    ChatTabCard5()
                }.buttonStyle(.plain)
                
            }
            
        }.refreshable {
            print("Refresh")
        }
    }
}

