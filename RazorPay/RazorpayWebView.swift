//
//  RazorpayWebView.swift
//  webpadai
//
//  Created by priyanshi on 19/05/26.
//

import Foundation
import SwiftUI
import WebKit

struct RazorpayWebView: UIViewRepresentable {
    let studentId: String
    let batchId: String
    let apiKey: String
    //let apiKey: String = "rzp_live_aat2QLiGudGSDO"
    let amount: Double
    @Binding var paymentSuccess: Bool
    @Binding var paymentId: String
    var onDismiss: () -> Void
    //var onSuccess:(()) -> Void
    var onSuccess: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "razorpayHandler")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.preferences.javaScriptEnabled = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        
        //  Pehle Order ID fetch karo, tab Razorpay open karo
        context.coordinator.fetchOrderId(webView: webView)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {}
    
    // MARK: - Razorpay HTML (Order ID milne ke baad banta hai)
    func makeRazorpayHTML(orderId: String, amount: Int) -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
            <style>
                body { margin: 0; padding: 0; background: white; }
            </style>
        </head>
        <body>
            <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
            <script>
                window.onload = function() {
                    var options = {
                        key: '\(apiKey)',
                        amount: \(amount),
                        currency: 'INR',
                        name: 'WebPadhai',
                        description: 'Course Purchase',
                        order_id: '\(orderId)',      //  API  real order ID
                        prefill: {
                            contact: '',
                            email: ''
                        },
                        theme: {
                            color: '#077aed'
                        },
                        handler: function(response) {
                            window.webkit.messageHandlers.razorpayHandler.postMessage({
                                status: 'success',
                                paymentId: response.razorpay_payment_id,
                                orderId: response.razorpay_order_id,
                                signature: response.razorpay_signature
                            });
                        },
                        modal: {
                            ondismiss: function() {
                                window.webkit.messageHandlers.razorpayHandler.postMessage({
                                    status: 'cancelled'
                                });
                            }
                        }
                    };
                    
                    var rzp = new Razorpay(options);
                    rzp.on('payment.failed', function(response) {
                        window.webkit.messageHandlers.razorpayHandler.postMessage({
                            status: 'failed',
                            error: response.error.description
                        });
                    });
                    
                    rzp.open();
                }
            </script>
        </body>
        </html>
        """
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: RazorpayWebView
        
        init(_ parent: RazorpayWebView) {
            self.parent = parent
        }
        
        //  Step 1: Backend se Order ID lo
        func fetchOrderId(webView: WKWebView) {
            print("Fetch Order IDs API Run - ")
            let urlString = "https://webpadhai.com/api/home/getOrderIdOfRazorPay"
            guard let url = URL(string: urlString) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded",
                           forHTTPHeaderField: "Content-Type")
            
            //  Tumhare params
            let amountInPaise = Int(parent.amount * 100)
            let amountInRs    = String(format: "%.2f", parent.amount)
            let params = "amount=\(amountInPaise)&batch_id=\(parent.batchId)&student_id=\(parent.studentId)&type=batch&course_type=&amountInRs=\(amountInRs)&isFrom=mobile&domain=https%3A%2F%2Fmylearning.dcsplm.com&multiPriceId="
            request.httpBody = params.data(using: .utf8)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(" API order fetch API Error: \(error)")
                    return
                }
                
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print(" order Fetch API JSON parse failed")
                    return
                }
                
                print(" order Fetch API Response: \(json)")
                
                //  Step 2: Order ID nikalo response se
                // Apne API response ke hisaab se key name check karo
                let orderId = json["orderId"] as? String
                           ?? json["order_id"] as? String
                           ?? json["id"] as? String
                           ?? ""
                
                let amount  = json["amount"] as? Int ?? 0
                
                guard !orderId.isEmpty else {
                    print(" Order ID nahi mili — API response check karo")
                    return
                }
                
                print(" Order ID: \(orderId)")
                
                //  Step 3: Main thread pe Razorpay open karo
                DispatchQueue.main.async {
                    let html = self.parent.makeRazorpayHTML(
                        orderId: orderId,
                        amount: amount
                    )
                    //  baseURL diya — JS load hogi
                    webView.loadHTMLString(
                        html,
                        baseURL: URL(string: "https://checkout.razorpay.com")
                    )
                }
            }.resume()
        }
        
        //  Step 4: Payment result handle karo
        func userContentController(_ userContentController: WKUserContentController,
                                   didReceive message: WKScriptMessage) {
            
            guard let body = message.body as? [String: Any],
                  let status = body["status"] as? String else { return }
            
            DispatchQueue.main.async {
                switch status {
                case "success":
                    let paymentId = body["paymentId"] as? String ?? ""
                    let orderId   = body["orderId"]   as? String ?? ""
                    let signature = body["signature"] as? String ?? ""
                    
                    self.parent.paymentId = paymentId
                    self.parent.paymentSuccess = true
                    self.parent.onSuccess(paymentId)   // ✅ CourseOverview ka onSuccess trigger hoga
                    
                    print(" Payment Success!")
                    print("   Payment ID : \(paymentId)")
                    print("   Order ID   : \(orderId)")
                    print("   Signature  : \(signature)")
                    
                case "cancelled":
                    print(" Payment Cancelled")
                    self.parent.onDismiss()
                    
                case "failed":
                    let error = body["error"] as? String ?? ""
                    print(" Payment Failed: \(error)")
                    self.parent.onDismiss()
                default:
                    break
                }
            }
        }
    }
}
