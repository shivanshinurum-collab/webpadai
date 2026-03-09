import SwiftUI

struct DigitalEbookView : View {
    
    @Binding var path : NavigationPath
    
    var body : some View {
        ZStack {
            uiColor.ButtonBlue
                .ignoresSafeArea(edges: .top)

            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: uiString.backSize))
                }

                Spacer()

                Text("Digital Ebook")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.titleSize).bold())
                    .bold()

                Spacer()

                Color.clear.frame(width: 24)
            }
            .padding(.horizontal)
            .padding(.top, 50)
        }.ignoresSafeArea()
        .frame(height: 80)
        .navigationBarBackButtonHidden(true)
        NotFoundView(title: "Not Found Data", about: "")
    }
}

