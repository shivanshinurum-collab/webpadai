import SwiftUI

struct MenuRow4: View {
    
    let icon: String
    let title: String
    let index: Int
    
    @Binding var selectedTab: Int
    @Binding var showMenu: Bool
    
    var body: some View {
        
        let isSelected = selectedTab == index
        
        Button {
            selectedTab = index
            withAnimation {
                showMenu = false
            }
        } label: {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .frame(width: 22)
                
                Text(title)
                    .font(.subheadline)
            }
            .foregroundColor(isSelected ? .red : .gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                isSelected ? Color.red.opacity(0.15) : Color.clear
            )
            .cornerRadius(10)
        }
    }
}
