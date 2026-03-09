import SwiftUI
struct Bookmark : View {
    
    @Binding var path: NavigationPath

    let url: String
    let title: String

    @State private var isLoading = true
    
    var body: some View {

        VStack(spacing: 0) {

            // 🔹 Top Bar
            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(uiColor.black)
                        .font(.system(size: uiString.backSize))
                }

                Spacer()

                Text(title)
                    .foregroundColor(uiColor.black)
                    .font(.system(size: uiString.titleSize).bold())
                    .lineLimit(1)

                Spacer()
            }
            .padding()

            // 🔹 Document Viewer
            ZStack {
                WebView(url: URL(string: url)!, isLoading: $isLoading)

               
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
