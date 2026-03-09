/*import Foundation
import Razorpay
import UIKit

class RazorpayManager: NSObject, RazorpayPaymentCompletionProtocol {
    func onPaymentError(_ code: Int32, description str: String) {
        print("Fail")
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("Sucses")
    }
    
    
    private var razorpay: RazorpayCheckout!
    static let shared = RazorpayManager()
    
    override init() {
        super.init()
        razorpay = RazorpayCheckout.initWithKey("rzp_live_aat2QLiGudGSDO", andDelegate: self)
    }
    
    func startPayment(amount: Int, description: String) {
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        let options: [String: Any] = [
            "key": "rzp_live_xxx",
            "amount": amount*100,
            "currency": "INR",
            "name": "\(uiString.AppName)",
            "description": "Course Fee",
            "image": "logo.png",
            //"order_id": orderId,
            /*"prefill": [
             "contact": "9826871515",
             "email": "shivasdf@gmail.com"
             ],*/
            "notes": [
                "student_id": student_id
            ],
            "theme": [
                "color": "#077aed"
            ],
            "modal": [
                "confirm_close": true
            ]
        ]
        
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            
            razorpay.open(options, displayController: rootVC)
        }
    }
    
    // ✅ REQUIRED BY NEW SDK
    @objc func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]) {
        print("✅ Payment Success")
        print("Payment ID:", payment_id)
        print("Response:", response)
    }
    
    @objc func onPaymentError(_ code: Int32,
                              description str: String,
                              andData response: [AnyHashable : Any]) {
        print("❌ Payment Failed")
        print("Code:", code)
        print("Description:", str)
        print("Response:", response)
    }
}

*/
