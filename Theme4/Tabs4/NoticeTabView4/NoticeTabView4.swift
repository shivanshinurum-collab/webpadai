import SwiftUI

struct NoticeTabView4 : View {
    @State var notifications : [AppNotification] = []

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
               
                ScrollView {
                    ForEach(notifications) { notice in
                        NotificationCard(notifi: notice)
                            .shadow(color: uiColor.DarkGrayText, radius: 3)
                            .padding()
                    }
                }
                .scrollIndicators(.hidden)
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

