import SwiftUI

struct HomeTabGridCard4: View {
    
    let title: String
    let image: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            VStack(spacing: 12) {
                
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
                    .foregroundColor(.white)
                
                
                // Title
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 5)
                
                Spacer()
            }
            //.frame(height: 150)
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(18)
            //.shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
            
        }.padding()
    }
}



