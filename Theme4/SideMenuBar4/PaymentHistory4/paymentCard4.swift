import SwiftUI
struct paymentCard4 : View {
    
    let payment : PaymentHistoryItem
    
    var body : some View {
        VStack(alignment: .leading , spacing: 8){
            HStack{
                Text(payment.batchName)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                 
                Spacer()
                Text("\(payment.currencyDecimalCode)\(payment.amount)")
                    .font(.headline)
                    .foregroundColor(uiColor.green)
            }
            
            Text("Txn ID:\(payment.transactionId)")
                .font(.subheadline)
                .foregroundColor(uiColor.DarkGrayText)
            
            HStack{
                Text(payment.createAt)
                    .font(.subheadline)
                    .foregroundColor(uiColor.DarkGrayText)
                Spacer()
                Text(payment.status == "1" ? "SUCCESS" : "FAILED")
                    .font(.headline)
                    .foregroundColor(payment.status == "1" ? uiColor.green : uiColor.Error)
            }
        }.padding()
            .background(.white)
            .cornerRadius(15)
            .shadow(color: uiColor.DarkGrayText, radius: 1)
            .padding(5)
    }
}

