import SwiftUI

struct CouponView : View {
    let batch_id : String
    @State private var coupon: String = ""
    @State private var couponResponse: CouponModel?
    
    var body : some View {
        // MARK: - Coupon Section
        Text("Apply Coupon")
            .font(.title2.bold())

        TextField("Enter Coupon Code", text: $coupon)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 1.5)
            )
            .onChange(of: coupon) { _,_ in
                // Auto hide old error/success
                couponResponse = nil
            }

        // MARK: - Coupon Result
        if let response = couponResponse {
            if response.status == "true" {
                Text("\(response.couponResult?.discount_percentage ?? "")% Discount applied successfully")
                    .font(.title3.bold())
                    .foregroundColor(.green)
            } else {
                Text(response.message)
                    .font(.title3.bold())
                    .foregroundColor(.red)
            }
        }

        // MARK: - Apply Button
        Button {
            checkCoupon()
        } label: {
            Text("Apply Coupon")
                .foregroundColor(.white)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .cornerRadius(10)
        }
        .padding(.horizontal)

        
    }
    // MARK: - API Call
    func checkCoupon() {

        couponResponse = nil

        var components = URLComponents(
            string: apiURL.appliedCoupon
        )

        components?.queryItems = [
            URLQueryItem(name: "coupon_code", value: coupon),
            URLQueryItem(name: "batch_id", value: batch_id)
        ]

        guard let url = components?.url else {
            print(" Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print(" API Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print(" No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(CouponModel.self, from: data)
                print("BatchId = ",batch_id)
                print("Response = ",decodedResponse)
                DispatchQueue.main.async {
                    self.couponResponse = decodedResponse
                }
            } catch {
                print(" Decode Error:", error)
            }
        }
        .resume()
    }
    
}
