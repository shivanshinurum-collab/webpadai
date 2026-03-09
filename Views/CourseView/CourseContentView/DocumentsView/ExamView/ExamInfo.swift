import SwiftUI

struct ExamInfo : View {
    @Binding var path : NavigationPath
    
    let title : String
    let discription : String
    let url : String
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    path.removeLast()
                }label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: uiString.backSize))
                        .foregroundColor(.white)
                }
                Spacer()
                Text("Instructions")
                    .font(.system(size: uiString.titleSize).bold())
                    .foregroundColor(.white)
                Spacer()
            }.padding()
                .background(uiColor.ButtonBlue)
            
            VStack(spacing: 15){
                Text(title)
                    .font(Font.title2.bold())
                    .multilineTextAlignment(.leading)
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 1)
                Text(html.htmlToAttributedString(discription))
                    .font(.title)
            }.padding()
            
            Button{
                path.append(Route.ExamView(ExamUrl: url))
            }label: {
                Text("Agree and continue")
                    .font(.title2.bold())
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(uiColor.ButtonBlue)
            .cornerRadius(25)
            
            
            Spacer()
        }.navigationBarBackButtonHidden(true)
    }
}

