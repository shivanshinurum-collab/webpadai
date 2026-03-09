import SwiftUI
import AVKit

struct NotFoundView: View {

    let title : String
    let about : String
    
    

    var body: some View {
        VStack(spacing: 16) {
            
            LottieView(animationName: "emoji")
                .frame(width: 100, height: 100)
            
            HStack{
                Image("emptyFile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30,height: 30)
                Text(title)
                    .font(.title3.bold())
            }

            Text(about)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


