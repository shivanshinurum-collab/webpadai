import SwiftUI

struct NoticeBoardView: View {
    @Binding var path : NavigationPath
    
    @State var notices: [Notice] = []
    @State var staus: String = ""
    @State var message: String = ""

    var body: some View {
        ZStack {
            VStack(spacing: 10) {


                ZStack {
                    uiColor.ButtonBlue
                        .ignoresSafeArea(edges: .top)

                    HStack {
                        Button {
                            path.removeLast()
                        } label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(uiColor.white)
                                .font(.system(size: uiString.backSize))
                        }

                        Spacer()

                        Text(uiString.NoticeTitle)
                            .foregroundColor(uiColor.white)
                            .font(.system(size: uiString.titleSize).bold())

                        Spacer()

                        Color.clear.frame(width: 24)
                    }
                    .padding()
                    .padding(.top, 60)
                }
                .frame(height: 130)
                .clipShape(
                    RoundedCorner(
                        radius: 20,
                        corners: [.bottomLeft, .bottomRight]
                    )
                )

                if(staus != "false"){
                    ScrollView {
                        ForEach(notices) { notice in
                            NoticeCell(notice: notice)
                                .shadow(color: uiColor.DarkGrayText, radius: 3)
                        }
                    }
                    .padding(.horizontal)
                }else{
                    NotFoundView(title: message, about: "")
                }
            }
        }.navigationBarBackButtonHidden(true)
        .ignoresSafeArea(edges: .top)
        .onAppear{
            fetchData()
        }
    }
    
    func fetchData() {
        
        let components = URLComponents(
            string: apiURL.getNotice
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
                let decodedResponse = try JSONDecoder().decode(NoticeResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.staus = decodedResponse.status
                    self.message = decodedResponse.msg
                    self.notices = decodedResponse.noticeList ?? []
                   
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
}

struct NoticeCell: View {
    
    let notice: Notice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(notice.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            Text(notice.description)
                .font(.system(size: 13))
                .foregroundColor(uiColor.gray)
                .padding(.top, 4)
            
            HStack {
                Spacer()
                Text(notice.date)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.12),
                radius: 10, x: 5, y: 5)
        .padding(13)
    }
}

