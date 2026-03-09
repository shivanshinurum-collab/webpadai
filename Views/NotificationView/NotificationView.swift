import SwiftUI

struct NotificationView: View {
    @Binding var path : NavigationPath
    
    @State var notifications : [AppNotification] = []

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                ZStack {
                    Color.blue.opacity(0.8)
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

                        Text("Notification")
                            .foregroundColor(.white)
                            .font(.system(size: uiString.titleSize).bold())

                        Spacer()

                        Color.clear.frame(width: 24)
                    }
                    .padding(.horizontal)
                    .padding(.top, 50)
                }
                .frame(height: 110)
                .clipShape(
                    RoundedCorner(
                        radius: 20,
                        corners: [.bottomLeft, .bottomRight]
                    )
                )
                
               
                List {
                    ForEach(notifications) { notice in
                        NotificationCard(notifi: notice)
                            .shadow(color: uiColor.DarkGrayText, radius: 3)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .padding(.horizontal)
            }
        }.onAppear{
            fetchData()
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(edges: .top)
    }
    
    func fetchData() {
        
        var components = URLComponents(
            string: apiURL.getNotification
        )
        
        
        guard let url = components?.url else {
            print("❌ Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("❌ API Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print("❌ No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(NotificationResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.notifications = decodedResponse.notification
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
}





