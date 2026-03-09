import SwiftUI

struct NotificationCard: View {
    
    let notifi: AppNotification
    
    var body: some View {
        HStack(spacing: 6) {
            AsyncImage(url: URL(string: notifi.image)){ img in
                img
                    .resizable()
                    .frame(width: 70,height: 70)
                
            }placeholder: {
                Image("MountainImage")
                    .resizable()
                    //.scaledToFit()
                    .frame(width: 70,height: 70)
            }
            
            VStack(alignment:.leading , spacing: 10){
                Text(notifi.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(notifi.description)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.black.opacity(0.7))
                
                HStack{
                    Spacer()
                    
                    Text(notifi.createdDate)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                
            }.padding(.vertical)
           Spacer()
        }.frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.12),
                radius: 10, x: 5, y: 5)
        //.padding(5)
    }
}

