import SwiftUI
import AVKit

struct underProcess: View {

    let title : String
    let about : String
    
    

    var body: some View {
        VStack(spacing: 16) {
            
            LottieView(animationName: "underConstruction")
                .frame(width: 200, height: 200)
            
            HStack{
                
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
