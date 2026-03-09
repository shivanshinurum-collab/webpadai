import SwiftUI
struct NotificationAlert5 : View {
    
    var onClose: () -> Void
    
    var body: some View{
        VStack(alignment: .center , spacing: 15){
            Image(systemName: "bell.fill")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(uiColor.ButtonBlue)
                .clipShape(.circle)
            Text("Notification Settings")
                .font(.headline)
            Text("You can change sound and vibration settings of the notifications")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            Button{
                openNotificationSettings()
            }label: {
                Text("GO TO SETTINGS")
            }
        }.frame(maxWidth: 250 , maxHeight: 200)
            .padding()
            .background(.white)
            .cornerRadius(15)
    }
    
    func openNotificationSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

}
