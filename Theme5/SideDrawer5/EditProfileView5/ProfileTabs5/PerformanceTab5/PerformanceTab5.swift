
import SwiftUI

struct PerformanceTab5 : View {
    @State var selectTab = 0
    var body: some View {
        HStack{
            Spacer()
            Button{
                selectTab = 0
            }label: {
                tab(head: "BATCH TESTS", n: 0)
            }
            Button{
                selectTab = 1
            }label: {
                tab(head: "COURSE TESTS", n: 1)
            }
            Spacer()
        }
        ScrollView{
            underProcess(title: "Under Process", about: "")
        }
    }
    func tab (head :String , n : Int) -> some View {
        VStack{
            if selectTab == n {
                Text(head)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(10)
                    .padding(.horizontal,30)
                    .background(uiColor.ButtonBlue)
            }else{
                Text(head)
                    .font(.subheadline)
                    .foregroundColor(uiColor.DarkGrayText)
                    .padding(10)
                    .padding(.horizontal)
                    .background(.white)
                    .border(.black ,width: 1)
            }
        }
    }
}

