import SwiftUI

struct CourseOverview: View {
    @Binding var path : NavigationPath
    
    @State static var isLiveClass: Int = 0
    @State static var isTestSeries: Int = 0
    
    let course_id: String
    //let course: batchData
    
    @State var batch: Batch?
    @State var batchResponse: getBatchDetailResponse?
    //@StateObject private var iap = IAPManager()
    
    
    @State private var textWidth: CGFloat = 0
    @State private var showPaymentDialog = false

    
    var body: some View {
        let batchPrice = Int(batch?.batchPrice ?? "0") ?? 0
        //let offerPrice = Int(batch?.batchOfferPrice ?? "0") ?? 0
        ZStack(alignment: .bottom) {
            // uiColor.white
            //  .ignoresSafeArea()
            ScrollView() {
                if let unwrappedBatch = batch, let unwrappedBatchResponse = batchResponse {
                    CourseAbout(batch: unwrappedBatch, batchResponse: unwrappedBatchResponse)//,course: course)
/*                    if(batchResponse?.purchaseCondition != true){
                        CouponView(batch_id: String(course_id))
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
 */               } else {
                    //  Show loading state
                    VStack {
                        ProgressView()
                        Text("Loading course details...")
                            .foregroundColor(uiColor.DarkGrayText)
                            .padding(.top)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                }
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, batchResponse?.purchaseCondition ?? false ? 0 : 280)
            
            if(batchResponse?.purchaseCondition != true && batch?.batchOfferPrice != "0" ) {
                //VStack {
                VStack(spacing: 15) {
                    // Base Price
                    // Simplified Base Price section
                    HStack {
                        Text("Base Price")
                        Spacer()
                        
                        /*Text("₹\(batchPrice)")
                         .font(.system(size: 20).bold())*/
                        ZStack{
                            
                            Text("₹\(batchPrice)")
                                .font(.system(size: 20).bold())
                                .foregroundColor(uiColor.white)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .onAppear {
                                                textWidth = geo.size.width
                                            }
                                    }
                                )
                            Divider()
                                .frame(width: textWidth ,height: 2)
                                .background(.white)
                        }
                        
                        
                        
                    }.padding(.top)
                        .font(.headline.bold())
                        .foregroundColor(uiColor.white)
                    
                    // Offer Price
                    HStack {
                        Text("Offer Price")
                        Spacer()
                        Text("₹\(batch?.batchOfferPrice ?? "--")")
                    }
                    .font(.title3)
                    .bold()
                    .foregroundColor(uiColor.CreamBlueGreen)
       
                    // IN FUTURE BUILD
/*                    // Discount
                    HStack {
                        Text("Discount")
                        Spacer()
                        if let batchPrice = batch?.batchPrice,
                           let offerPrice = batch?.batchOfferPrice,
                           let price = Int(batchPrice),
                           let offer = Int(offerPrice) {
                            Text("₹\(price - offer)")
                        } else {
                            Text("--")
                        }
                    }
                    .font(.title3)
                    .foregroundColor(.orange.opacity(0.8))
  */
                    // Convenience Fee
                    HStack {
                        Text("Convenience Fee")
                        Spacer()
                        if //let batchPrice = batch?.batchPrice,
                            let offerPrice = batch?.batchOfferPrice,
                            // let price = Int(batchPrice),
                            let offer = Double(offerPrice),
                            let convFeePercent = Double(batchResponse?.convenienceFee ?? "0") {
                            let fee = offer * (convFeePercent / 100.0)
                            Text("₹\(String(format: "%.2f", fee))")
                        } else {
                            Text("₹0.00")
                        }
                    }
                    .font(.title3)
                    .foregroundColor(uiColor.white)
                    
                    // GST
                    HStack {
                        Text("GST on Convenience (18%)")
                        Spacer()
                        if //let batchPrice = batch?.batchPrice,
                            let offerPrice = batch?.batchOfferPrice,
                            // let price = Int(batchPrice),
                            let offer = Double(offerPrice),
                            let convFeePercent = Double(batchResponse?.convenienceFee ?? "0") {
                            let fee = offer * (convFeePercent / 100.0)
                            let gst = fee * 0.18
                            Text("₹\(String(format: "%.2f", gst))")
                        } else {
                            Text("₹0.00")
                        }
                    }
                    .font(.title3)
                    .foregroundColor(uiColor.white)
                    
                    // Buy Button
                    Button {
                        print("COURSE ID =\(course_id)")
                        if(batch?.batchOfferPrice != "0") {
                            //showPaymentDialog = true
                            path.append(Route.IAPView(productId: course_id))
                        }
                        
                    } label: {
                        if(batch?.batchOfferPrice == "0") {
                            Text("Free")
                                .padding()
                                .frame(maxWidth: .infinity)
                        }else{
                            if //let batchPrice = batch?.batchPrice,
                                let offerPrice = batch?.batchOfferPrice,
                                // let price = Int(batchPrice),
                                let offer = Double(offerPrice),
                                let convFeePercent = Double(batchResponse?.convenienceFee ?? "0") {
                                let fee = offer * (convFeePercent / 100.0)
                                let gst = fee * 0.18
                                let total = Double(offer) + fee + gst
                                Text("₹\(String(format: "%.2f", total))")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .foregroundColor(uiColor.white)
                    .bold()
                    .font(.title2)
                    .cornerRadius(15)
                    .background(uiColor.ButtonBlue)
                    .cornerRadius(15)
                    .padding(.bottom)
                }
                .padding(.horizontal)
                .ignoresSafeArea()
                .background(.black)
                /* }.frame(height: 280)
                 .background(uiColor.black)*/
                .confirmationDialog(
                    "Choose Payment Method",
                    isPresented: $showPaymentDialog,
                    titleVisibility: .visible
                ) {
                    Button("Pay using In-App Purchase") {
                        //Task { await iap.buy() }
                        path.append(Route.IAPView(productId: course_id))
                    }
                    
                 /*   Button("Pay using Razorpay") {
                        /*//let batchPrice = batch?.batchPrice,
                         if let offerPrice = batch?.batchOfferPrice,
                         // let price = Int(batchPrice),
                         let offer = Double(offerPrice),
                         let convFeePercent = Double(batchResponse?.convenienceFee ?? "0") {
                         let fee = offer * (convFeePercent / 100.0)
                         let gst = fee * 0.18
                         let total = Double(offer) + fee + gst*/
                        RazorpayManager.shared.startPayment(
                            amount: Int(1),
                            description: "Test Payment"
                        )
                        
                        
                    }
 */
                    Button("Cancel", role: .cancel) { }
                }

            }
            
            
        }.onAppear {
            fetchBatches()
        }
    }
    
    func fetchBatches() {
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        var components = URLComponents(
            string: apiURL.getBatchDetail
        )

        components?.queryItems = [
            URLQueryItem(name: "batch_id", value: course_id),  //  Use course.id
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
                
                print("Batch ID = ",course_id)
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
}

