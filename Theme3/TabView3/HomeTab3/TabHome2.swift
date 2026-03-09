import SwiftUI
import Combine

struct TabHome2 : View {
    
    @Binding var path : NavigationPath
    
    @State var index = 0
    @State private var banners: [HomeBannerData] = []
    @State private var fileBaseURL = ""
    
    @State var batchResponse: getBatchDetailResponse?
    @State var batch: Batch?
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    
    @State private var textWidth: CGFloat = 0
    @State private var showPaymentDialog = false
    
    @State var isLoading = true
    
    let batch_id = UserDefaults.standard.string(forKey: "batch_id") ?? "0"
    let userName = UserDefaults.standard.string(forKey: "fullName") ?? "PLAY STORE TEAM"
    
    var body: some View {
        
        ScrollView{
            VStack(alignment : .leading){
                Text(userName)
                    .font(.title2)
                    .bold()
                    .foregroundColor(uiColor.black)
                    .padding(.horizontal)
                
                TabView(selection: $index) {
                    ForEach(banners.indices, id: \.self) { i in
                        AsyncImage(
                            url: URL(string: fileBaseURL + banners[i].banner)
                        ) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .tag(i)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 200)
                .onReceive(timer) { _ in
                    withAnimation {
                        index = banners.isEmpty ? 0 : (index + 1) % banners.count
                    }
                }
                
                // WebView inside box
                WebView(url: URL(string: apiURL.questionOfDay)!, isLoading: $isLoading)
                    .frame(height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .scrollIndicators(.hidden)
                
                
                if batchResponse?.purchaseCondition != true && batch?.batchOfferPrice != "0" {
                    
                    VStack(spacing: 16) {
                        
                        // MARK: Price Card
                        VStack(alignment: .leading, spacing: 12) {
                            
                            // Base Price
                            HStack {
                                Text("Base Price")
                                    .foregroundColor(.black.opacity(0.8))
                                Spacer()
                                Text("₹\(batch?.batchPrice ?? "--")")
                                    .foregroundColor(.black)
                                    .strikethrough()
                                    .font(.system(size: 18, weight: .medium))
                            }
                            
                            // Offer Price
                            HStack {
                                Text("Offer Price")
                                    .foregroundColor(.green)
                                Spacer()
                                Text("₹\(batch?.batchOfferPrice ?? "--")")
                                    .foregroundColor(.green)
                                    .bold()
                            }
                            
                            // Discount
                            if let price = Double(batch?.batchPrice ?? ""),
                               let offer = Double(batch?.batchOfferPrice ?? "") {
                                
                                HStack {
                                    Text("Discount")
                                        .foregroundColor(.orange)
                                    Spacer()
                                    Text("₹\(String(format: "%.2f", price - offer))")
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            // Convenience Fee
                            if let offer = Double(batch?.batchOfferPrice ?? ""),
                               let convPercent = Double(batchResponse?.convenienceFee ?? "0") {
                                
                                let fee = offer * (convPercent / 100.0)
                                
                                HStack {
                                    Text("Convenience Fee")
                                    Spacer()
                                    Text("₹\(String(format: "%.2f", fee))")
                                }
                                
                                // GST
                                let gst = fee * 0.18
                                
                                HStack {
                                    Text("GST on Convenience (18%)")
                                    Spacer()
                                    Text("₹\(String(format: "%.2f", gst))")
                                }
                                
                                Divider()
                                
                                // MARK: Pay Button
                                let total = offer + fee + gst
                                
                                Button {
                                    //showPaymentDialog = true
                                    path.append(Route.IAPView(productId: batch_id))
                                } label: {
                                    Text("Pay ₹\(String(format: "%.2f", total))")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            LinearGradient(
                                                colors: [Color.blue.opacity(0.8), Color.blue],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(10)
                                }
                            }
                            
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                        
                    }
                }
            }
            
        }.scrollIndicators(.hidden)
        .confirmationDialog(
            "Choose Payment Method",
            isPresented: $showPaymentDialog,
            titleVisibility: .visible
        ) {
            Button("Pay using In-App Purchase") {
                //Task { await iap.buy() }
                path.append(Route.IAPView(productId: batch_id))
            }
            
            Button("Cancel", role: .cancel) { }
        }
        
        .onAppear{
            fetchHomeBanners()
            fetchBatches()
        }
    }
    
    
    func fetchBatches() {
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        var components = URLComponents(
            string: apiURL.getBatchDetail
        )

        components?.queryItems = [
            URLQueryItem(name: "batch_id", value: batch_id),  //  Use course.id
            URLQueryItem(name: "student_id", value: student_id)
        ]

        guard let url = components?.url else {
            print(" Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(" API Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print(" No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(getBatchDetailResponse.self, from: data)
                
                print("Batch ID = ",batch_id)
                DispatchQueue.main.async {
                    // ✅ Store the response
                    self.batch = decodedResponse.batch
                    self.batchResponse = decodedResponse
                    
                    CourseOverview.isLiveClass = decodedResponse.isLiveClass
                    CourseOverview.isTestSeries = decodedResponse.isTestSeriesAvailable
                    
                }
            } catch {
                print(" Decode Error:", error)
               
            }
        }.resume()
    }
    
    
    func fetchHomeBanners() {
        guard let url = URL(string: apiURL.getHomeBanner ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Error:", error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(HomeBannerModel.self, from: data)
                DispatchQueue.main.async {
                    self.banners = response.data
                    self.fileBaseURL = response.filesUrl
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
}
