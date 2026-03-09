import SwiftUI

struct paymentHistory4 : View {
    
    @State var status : String = ""
    @State var message : String = ""
    @State var payment : [PaymentHistoryItem] = []
    
    var body : some View {
        VStack(alignment: .leading){
            Text("Payment History")
                .font(.title3)
                .bold()
            
            ScrollView{
                ForEach(payment){ pay in
                    paymentCard4(payment : pay)
                }
            }
            
        }.padding()
            .onAppear{
                fetchData()
            }
    }
    
    func fetchData() {
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        //print("studentID",student_id)
        var components = URLComponents(
            string: apiURL.getPaymentHistory
        )
        
        components?.queryItems = [
            URLQueryItem(name: "student_id", value: student_id)
        ]
        
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
                let decodedResponse = try JSONDecoder().decode(PaymentHistoryResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.payment = decodedResponse.paymentData ?? []
                    self.status = decodedResponse.status
                    self.message = decodedResponse.msg
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
    
}
#Preview {
    paymentHistory4()
}
