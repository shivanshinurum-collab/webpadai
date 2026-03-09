import SwiftUI

struct courseBuy4 : View {
    let head = "Advance Diploma in Clinical Research"
    @Binding var path : NavigationPath
    @State var coupon : String = ""
    
    var body : some View {
        HStack(spacing: 20){
            Button{
                
            }label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.backSize))
            }
            
            Text("Checkout")
                .font(.system(size: uiString.titleSize))
                .foregroundColor(.white)
            
            Spacer()
            
        }.padding(.horizontal)
            .padding(.bottom , 10)
            .background(uiColor.ButtonBlue)
        
        ScrollView{
            VStack(alignment: .leading , spacing: 20){
                
                VStack(alignment: .leading){
                    Text(head)
                        .font(.headline)
                    
                    HStack(spacing: 20){
                        Text("₹40000.0")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text("₹35000.0")
                            .font(.subheadline)
                            .foregroundColor(uiColor.lightGrayText)
                        
                        Text("6% OFF")
                            .font(.headline)
                            .foregroundColor(Color(
                                red: 30/255,
                                green: 156/255,
                                blue: 44/255
                            ))
                            .padding(7)
                            .background(Color(
                                red: 178/255,
                                green: 237/255,
                                blue: 215/255
                            ))
                            .cornerRadius(15)
                        
                        Spacer()
                    }
                }
                .padding()
                .background(.white)
                .cornerRadius(15)
                .shadow(color: uiColor.DarkGrayText, radius: 2)
                
                
                Text("Apply Coupon")
                    .font(.headline)
                    .bold()
                
                HStack(spacing: 20){
                    TextField("Enter coupon code",text: $coupon)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                    
                    Button{
                        
                    }label: {
                        Text("Apply")
                            .bold()
                            .padding(12)
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .background(Color(
                                red: 235/255,
                                green: 27/255,
                                blue: 2/255
                            ))
                            .cornerRadius(15)
                    }
                    
                }
                .padding()
                .background(.white)
                .cornerRadius(15)
                .shadow(color: uiColor.DarkGrayText, radius: 2)
                
                
                Text("Available Coupons")
                    .font(.headline)
                    .bold()
                
                VStack(alignment: .leading ,spacing: 5){
                    HStack{
                        Text("FIRST")
                            .font(.headline)
                            .bold()
                        
                        Spacer()
                        
                        Button{
                            
                        }label: {
                            Text("Apply")
                                .bold()
                                .padding(12)
                                .padding(.horizontal)
                                .foregroundColor(Color(
                                    red: 235/255,
                                    green: 27/255,
                                    blue: 2/255
                                ))
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color(
                                            red: 235/255,
                                            green: 27/255,
                                            blue: 2/255
                                        ) , lineWidth: 2)
                                )
                        }
                    }
                    Text("Get 10% off on this purchase.")
                        .font(.subheadline)
                        .foregroundColor(uiColor.DarkGrayText)
                }
                .padding()
                .background(.white)
                .cornerRadius(15)
                .shadow(color: uiColor.DarkGrayText, radius: 2)
                
                
                Text("Order Summary")
                    .font(.headline)
                    .bold()
                
                VStack(alignment: .leading ,spacing: 15){
                    HStack{
                        Text("Subtotal")
                            .foregroundColor(uiColor.DarkGrayText)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("₹40000.0")
                            .font(.headline)
                    }
                    HStack{
                        Text("Discount")
                            .foregroundColor(uiColor.DarkGrayText)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("-₹5000.0")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    
                    Rectangle()
                        .frame(maxWidth: .infinity , maxHeight: 1)
                        .foregroundColor(uiColor.lightGrayText)
                    
                    HStack{
                        Text("Total Payable")
                            .foregroundColor(uiColor.DarkGrayText)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("₹35000.0")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    
                }
                .padding()
                .background(.white)
                .cornerRadius(15)
                .shadow(color: uiColor.DarkGrayText, radius: 2)
                
                
                
                
                
            }.padding()
        }.background(uiColor.lightSystem)
            .scrollIndicators(.hidden)
        
        ZStack{
            Color(
                red: 59/255,
                green: 56/255,
                blue: 56/255
            )
            .ignoresSafeArea()
            HStack{
                VStack(alignment: .leading){
                    Text("Payable")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("₹35000.0")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                }
                
                
                Spacer()
                Button{
                    
                }label: {
                    HStack{
                        Image(systemName: "cart.fill")
                        
                        Text("Pay Now")
                    }.font(.title3)
                        .bold()
                        .foregroundColor(Color(
                            red: 245/255,
                            green: 27/255,
                            blue: 2/255
                        ))
                        .padding(12)
                        .padding(.horizontal,10)
                        .background(.white)
                        .cornerRadius(20)
                    
                }
            }.padding()
        }.frame(height: 30)
            .ignoresSafeArea()
        
    }
}

