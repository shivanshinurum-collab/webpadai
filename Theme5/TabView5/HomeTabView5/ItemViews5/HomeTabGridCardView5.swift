import SwiftUI

struct GridItemModel5: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    let isFree: Bool
    let image: String
}

struct HomeTabGridCardView5: View {
    
    //let item: GridItemModel
    let title: String
    let color: Color
    let isFree: Bool
    let image: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            VStack(spacing: 12) {
                
                // Circle Icon
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 80, height: 80)
                        .shadow(radius: 4)
                    
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundColor(color)
                }
                .padding(.top, 20)
                
                // Title
                Text(title)
                    .font(.subheadline)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 5)
                
                Spacer()
            }
            //.frame(height: 150)
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
            
            
            // FREE Ribbon
            if isFree {
                Text("FREE")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(8)
            }
        }
    }
}
