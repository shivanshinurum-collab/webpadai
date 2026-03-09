import SwiftUI
struct paidTab5 : View {
    @State var search = ""
    
    var body : some View {
        VStack{
            VStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                    TextField("Search by Course",text: $search)
                    
                }.padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 1)
                    )
            }.padding(6)
            
            Spacer()
            
            underProcess2(title: "No transactions", about: "")
            
            Spacer()
        }
    }
}
