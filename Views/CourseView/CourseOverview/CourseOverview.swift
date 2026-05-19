import SwiftUI

struct CourseOverview: View {
    @Binding var path : NavigationPath
    
    @StateObject var priceManager = PriceManager.shared
    
    @State static var isLiveClass: Int = 0
    @State static var isTestSeries: Int = 0
    @State private var showPayment = false
    @State private var paymentSuccess = false
    @State private var paymentId = ""
    @State private var showSuccessAlert = false
    @State private var successPaymentId = ""
    @State var razorKey = ""
    
    let course_id: String
    //let course: batchData
    
    @State var batch: Batch?
    @State var batchResponse: getBatchDetailResponse?
    //@StateObject private var iap = IAPManager()
    
    
    @State private var textWidth: CGFloat = 0
    @State private var showPaymentDialog = false
    
    
    
    var body: some View {
        let batchPrice = Int(batch?.batchPrice ?? "0") ?? 0
        
        // MARK: - Effective Price Logic
        // multiPrice available hai → selected plan ka price (default: pehla plan via PriceManager)
        // multiPrice nil hai → batch offer price
        let effectivePrice: Double = {
            if let multiPrices = batchResponse?.multiPrice, !multiPrices.isEmpty {
                return priceManager.selectedPrice > 0
                    ? priceManager.selectedPrice
                    : Double(multiPrices.first?.course_price ?? "0") ?? 0
            } else {
                return Double(batch?.batchOfferPrice ?? "0") ?? 0
            }
        }()
        
        let convFeePercent = Double(batchResponse?.convenienceFee ?? "0") ?? 0
        let convenienceFee = effectivePrice * (convFeePercent / 100.0)
        let gstAmount     = convenienceFee * 0.18
        let totalAmount   = effectivePrice + convenienceFee + gstAmount
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
                            
                            //                            Text("₹\(batchPrice)")
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
                        Text("₹\(String(format: "%.2f", effectivePrice))")
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
                        Text("₹\(String(format: "%.2f", convenienceFee))")
                    }
                    .font(.title3)
                    .foregroundColor(uiColor.white)
                    
                    // GST
                    HStack {
                        Text("GST on Convenience (18%)")
                        Spacer()
                        Text("₹\(String(format: "%.2f", gstAmount))")
                    }
                    .font(.title3)
                    .foregroundColor(uiColor.white)
                    
                    // Buy Button
                    //                    Button {
                    //                        print("COURSE ID =\(course_id)")
                    //                        if(batch?.batchOfferPrice != "0") {
                    //                            //showPaymentDialog = true
                    //                            path.append(Route.IAPView(productId: course_id))
                    //                        }
                    //
                    //                    }
                    //MARK: -  Add by Mam
                    Button {
                        print("COURSE ID =\(course_id)")
                        if effectivePrice > 0 {
                            showPayment = true
                        }
                    } label: {
                        if effectivePrice == 0 {
                            Text("Free")
                                .padding()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Pay ₹\(String(format: "%.2f", totalAmount))")
                                .padding()
                                .frame(maxWidth: .infinity)
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
                        print("CoURse ID = ",course_id)
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
            fetchPaymentIds()
        }
        //MARK: - Add by Mam
        .sheet(isPresented: $showPayment) {
            RazorpayWebView(
                studentId: UserDefaults.standard.string(forKey: "studentId") ?? "",
                batchId: course_id,
                apiKey: razorKey,
                amount: effectivePrice,  // multiPrice → selected plan price; nil → batch offer price
                
                paymentSuccess: $paymentSuccess,
                paymentId: $paymentId,
                onDismiss: {
                    showPayment = false
                },
                onSuccess: { receivedPaymentId in
                    showPayment = false
                    successPaymentId = receivedPaymentId
                    print("AssignBatch API Calling")
                    // PriceManager se multiId lo — same source jo runtime pe update hota hai
                    let multiId = PriceManager.shared.selectedMultiId
                    assignBatchToStudent(multiId: multiId)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showSuccessAlert = true
                    }
                }
            )
        }
        //  deprecated fix
        .onChange(of: paymentSuccess) { _, success in
            if success {
                showPayment = false
                print(" Payment Done! ID: \(paymentId)")
            }
        }
        //  Success Alert
        .alert("Payment Successful! 🎉", isPresented: $showSuccessAlert) {
            Button("Continue") {
                showSuccessAlert = false
                fetchBatches()   // ✅ purchaseCondition refresh → buy button hide hoga
            }
        } message: {
            Text("Aapka course unlock ho gaya!\nPayment ID: \(successPaymentId)")
        }
    }
    
    func fetchPaymentIds(){
        let components = URLComponents(
            string: apiURL.generalSetting
        )
        
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
                let decodedResponse = try JSONDecoder().decode(AppSettingsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.razorKey = decodedResponse.data?.razorpayKeyId ?? ""
                }
            } catch {
                print(" Decode Error:", error)
                
            }
        }.resume()
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
                    //  Store the response
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
    
    // MARK: - Batch Assign API (POST)
    func assignBatchToStudent(multiId: String) {
        print("AssignBatch API Calling Function")
        let studentId = UserDefaults.standard.string(forKey: "studentId") ?? ""
        
        guard let url = URL(string: apiURL.batchAssignToStudent) else {
            print(" [assignBatch] Invalid URL")
            return
        }
        
        // POST body — application/x-www-form-urlencoded
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "student_id", value: studentId),
            URLQueryItem(name: "batch_id",   value: course_id),
            URLQueryItem(name: "multi_id",   value: multiId)   // empty string if no multi-price
        ]
        let bodyString = bodyComponents.percentEncodedQuery ?? ""
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyString.data(using: .utf8)
        
        print(" [assignBatch] POST → \(url)")
        print(" [assignBatch] Body → \(bodyString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print(" [assignBatch] Error:", error.localizedDescription)
                return
            }
            guard let data else {
                print(" [assignBatch] No data")
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data) {
                print(" [assignBatch] Response:", json)
            }
        }.resume()
    }
}
