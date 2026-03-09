import SwiftUI

struct PaymentHistory : View{
    
    @Binding var path : NavigationPath
    @State var status : String = ""
    @State var message : String = ""
    @State var payment : [PaymentHistoryItem] = []
    
    var body: some View {
        
        ZStack(alignment: .top){
            HStack{
                Button{
                    path.removeLast()
                }label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: uiString.backSize))
                        .foregroundColor(.white)
                }
                Spacer()
                Text(uiString.PaymentTitle)
                    .font(.system(size: uiString.titleSize).bold())
                    .foregroundColor(.white)
                Spacer()
            }.padding(.horizontal , 15)
            ZStack{
                RoundedRectangle(cornerRadius: 45)
                    .foregroundColor(.white)
                    .ignoresSafeArea()
                    .padding(.top , 70)
                VStack(spacing: 10){
                   
                    if(status != "false"){
                        ScrollView{
                            ForEach(payment){pay in
                                PaymentCell(payment: pay)
                                    .shadow(color: uiColor.DarkGrayText, radius: 3)
                            }
                        }
                    }else{
                        NotFoundView(title: message , about: "")
                    }
                }.padding(.top , 100)
            }
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity)
        .background(uiColor.ButtonBlue)
        .navigationBarBackButtonHidden(true)
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

struct PaymentCell: View {
    
    let payment: PaymentHistoryItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            HStack{
                Text("\(payment.batchName)")
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                Text("\(payment.currencyDecimalCode)\(payment.amount)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.green)
            }
            
            
            Text("Txn ID:\(payment.transactionId)")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .padding(.top, 4)
            
            HStack{
                Text("\(payment.createAt)")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .padding(.top, 4)
                
                Spacer()
                
                if(payment.status == "1"){
                    Text("SUCCESS")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.green)
                }else{
                    Text("FAILED")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(uiColor.Error)
                }
                
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


