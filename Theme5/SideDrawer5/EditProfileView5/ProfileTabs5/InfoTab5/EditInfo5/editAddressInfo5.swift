import SwiftUI
struct editAddressInfo5: View {
    @Binding var path  :NavigationPath
    
    @State var permanentAddress = ""
    @State var permanentAddressPIN = ""
    @State var correspondenceAddress = ""
    @State var correspondenceAddressPIN = ""
    
    var body: some View{
        HStack(spacing: 25){
            Button{
                path.removeLast()
            }label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.backSize))
            }
            
            Text("Edit Address")
                .font(.system(size: uiString.titleSize))
                .foregroundColor(.white)
            
            Spacer()
            
            Button{
                
            }label: {
                Text("Save")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.titleSize))
            }
            
        }.padding()
            .background(uiColor.ButtonBlue)
        
        ScrollView{
            VStack(alignment: .leading , spacing: 18){
                
                HStack{
                    Image(systemName: "map")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Permanent Address")
                        TextField("" , text: $permanentAddress)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.2) , lineWidth: 1)
                            )
                    }
                }
                
                HStack{
                    Image(systemName: "location")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Permanent Address PIN Code")
                        TextField("" , text: $permanentAddressPIN)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.2) , lineWidth: 1)
                            )
                    }
                }
                HStack{
                    Image(systemName: "map")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Correspondence Address")
                        TextField("" , text: $correspondenceAddress)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.2) , lineWidth: 1)
                            )
                    }
                }
               
                
                HStack{
                    Image(systemName: "location")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Correspondence Address PIN Code")
                        TextField("" , text: $correspondenceAddressPIN)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.2) , lineWidth: 1)
                            )
                    }
                }
                
            }.padding()
            
        }.navigationBarBackButtonHidden(true)
    }
    
}

