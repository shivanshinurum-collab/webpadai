import SwiftUI

struct StoreAboutView: View {

    @Binding var path: NavigationPath
    let id: String

    @State private var about: StoreDetail?

    var body: some View {
        VStack(spacing: 0) {
            
            // 🔹 Content
            if let detail = about {
                // 🔹 Header
                HStack {
                    Button {
                        path.removeLast()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: uiString.backSize))
                    }

                    Spacer()

                    Text(detail.courseName)
                        .lineLimit(1)
                        .foregroundColor(.white)
                        .font(.system(size: uiString.titleSize).bold())


                    Spacer()
                }
                .padding()
                .background(uiColor.ButtonBlue)
                
                ZStack(alignment: .bottom) {

                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(detail.courseName)
                                .font(.title3.bold())

                            AsyncImage(url: URL(string: detail.courseImage)) { img in
                                img
                                    .resizable()
                                    .scaledToFit()
                            } placeholder : {
                                Rectangle()
                                    .frame(maxWidth: .infinity,maxHeight: 1)
                                    .foregroundColor(uiColor.lightGrayText)
                            }

                            Text("About Content")
                                .font(.headline.bold())

                            Text(html.htmlToAttributedString(detail.courseDesc))
                                .font(.body)
                        }
                        .padding()
                    }.scrollIndicators(.hidden)
                    .padding(.bottom, 200)

                    // 🔹 Bottom Price View
                    VStack(spacing: 10) {

                        HStack {
                            Text("Digital Course Price")
                            Spacer()
                            Text("₹\(detail.coursePrice)")
                        }

                        HStack {
                            Text("You Pay")
                            Spacer()
                            Text("₹\(detail.courseOfferPrice)")
                            Text("₹\(detail.coursePrice)")
                        }

                        HStack {
                            Text("GST(18%)")
                            Spacer()
                            Text("Including GST")
                        }

                        HStack {
                            Text("Discount")
                            Spacer()
                            Text("₹-49.00")
                        }
                        .foregroundColor(uiColor.Error)

                        Button {
                            //path.append(Route.AddressFormView)
                        } label: {
                            Text("Add Shipping Address")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(uiColor.ButtonBlue)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .frame(height: 200)
                    .background(.black)
                    .foregroundColor(.white)
                }

            } else {
                // 🔹 Loading State (prevents crash)
                Spacer()
                ProgressView("Loading...")
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fetchData()
        }
    }

    // 🔹 API CALL
    func fetchData() {

        var components = URLComponents(
            string: apiURL.getContentDetail
        )

        components?.queryItems = [
            URLQueryItem(name: "digital_id", value: id)
        ]

        guard let url = components?.url else {
            print("❌ Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print("❌ API Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print("❌ No data received")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(StoreDetailResponse.self, from: data)

                DispatchQueue.main.async {
                    self.about = decoded.storeDetail.first
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
}

