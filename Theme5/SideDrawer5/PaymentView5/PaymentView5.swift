import SwiftUI

struct PaymentView5 : View {
    @Binding var path : NavigationPath
    
    @State var selectTab = 0
    
    var body: some View{
        HStack{
            Button{
                path.removeLast()
            }label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.backSize))
            }.buttonStyle(.plain)
            
            Text("Payments")
                .font(.system(size: uiString.titleSize))
                .foregroundColor(.white)
            
            Spacer()
            
        }.padding(.horizontal)
            .padding(.bottom , 5)
            .background(uiColor.ButtonBlue)
        HStack{
            Spacer()
            
            Button{
                selectTab = 0
            }label: {
                TabButton(head: "UNPAID", n: 0)
                    .frame(maxWidth: 100)
            }
            
            Button{
                selectTab = 1
            }label: {
                TabButton(head: "UPCOMING", n: 1)
                    .frame(maxWidth: 100)
            }
            
            Button{
                selectTab = 2
            }label: {
                TabButton(head: "PAID", n: 2)
                    .frame(maxWidth: 100)
            }
            
            Spacer()
        }.background(.white)
            .foregroundColor(uiColor.DarkGrayText)
            .padding(.top , 10)
        
        Rectangle()
            .frame(height: 3)
            .foregroundColor(uiColor.system)
        
        
        
        
        
        ScrollView{
            switch selectTab {
            case 0:
                unPaidTab5()
            case 1:
                upcomingTab5()
            case 2:
                paidTab5()
            default:
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    func TabButton(head : String , n : Int) -> some View {
        VStack{
            if selectTab == n {
                Text(head)
                    .foregroundColor(.black)
                    .font(.subheadline)
                Rectangle()
                    .frame(width: 100 , height: 1)
                    .foregroundColor(uiColor.ButtonBlue)
            }else{
                Text(head)
                    .foregroundColor(.black)
                    .font(.subheadline)
                Rectangle()
                    .frame(width: 100 , height: 1)
                    .foregroundColor(.white)
            }
        }
    }
}
