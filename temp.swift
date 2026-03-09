import SwiftUI
struct temp : View {
    
    
    let head = "Advance Diploma in Clinical Research"
    let subHead : String = "Advanced Diploma in Clinical Research management (ADCRM) "
    @State var readMore : Bool = false
    

    
    var body : some View {
        HStack{
            Button{
                
            }label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
            }
            Spacer()
            
            Text(head)
                .font(.system(size: uiString.titleSize))
                .lineLimit(0)
                .foregroundColor(.white)
            Spacer()
            
            Button{
                
            }label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.white)
                    .font(.title3)
            }
        }.padding(10)
            .bold()
            .background(uiColor.ButtonBlue)
        
        ScrollView{
            VStack(alignment: .leading , spacing: 20){
                HStack{
                    Image("banner")
                        .resizable()
                        .scaledToFit()
                    VStack(alignment: .leading){
                        Text(head)
                            .font(.headline)
                        Text(subHead)
                            .font(.subheadline)
                            .foregroundColor(uiColor.DarkGrayText)
                            .lineLimit(readMore ? 5 : 2)
                        Button{
                            readMore.toggle()
                        }label: {
                            Text("Read more")
                        }
                    }
                }
                
                
                VStack(alignment: .leading){
                    Text("Documents")
                        .font(.headline)
                    
                    HStack(spacing: 15){
                        Image(systemName: "text.document.fill")
                            .font(.headline)
                            .frame(width: 50 , height: 50)
                            .foregroundColor(.green)
                            .background(uiColor.lightSystem)
                            .cornerRadius(15)
                        
                        VStack(alignment: .leading){
                            Text("ICG GCP")
                                .font(.headline)
                            
                            Text("Document • Book")
                        }.foregroundColor(uiColor.DarkGrayText)
                        
                        Spacer()
                        
                        Button{
                            
                        }label: {
                            Text("Open")
                                .padding(10)
                                .padding(.horizontal)
                                .foregroundColor(.green)
                                .bold()
                        }.buttonStyle(.plain)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.green , lineWidth: 2)
                            )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(uiColor.lightGrayText , lineWidth: 2)
                    )
                }
                
                VStack(alignment: .leading){
                    Text("Videos")
                        .font(.headline)
                    
                    HStack(spacing: 15){
                        Image(systemName: "video.fill")
                            .font(.headline)
                            .frame(width: 50 , height: 50)
                            .foregroundColor(.red)
                            .background(uiColor.lightSystem)
                            .cornerRadius(15)
                        
                        VStack(alignment: .leading){
                            Text("ICG GCP")
                                .font(.headline)
                            
                            Text("Video • YouTube")
                        }.foregroundColor(uiColor.DarkGrayText)
                        
                        Spacer()
                        
                        Button{
                            
                        }label: {
                            HStack{
                                Image(systemName: "play.fill")
                                Text("Play")
                            }
                            .font(.subheadline)
                                .padding(10)
                                .padding(.horizontal , 10)
                                .foregroundColor(.red)
                                .bold()
                        }.buttonStyle(.plain)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.red , lineWidth: 2)
                            )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(uiColor.lightGrayText , lineWidth: 2)
                    )
                }
                
                
            }.padding()
            
        }.scrollIndicators(.hidden)
        
        
        ZStack{
            Color(
                red: 59/255,
                green: 56/255,
                blue: 56/255
            )
                .ignoresSafeArea()
            HStack{
                VStack(alignment: .leading){
                    HStack{
                        Text("₹15000")
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color(
                                red: 245/255,
                                green: 27/255,
                                blue: 2/255
                            ))
                        
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
                    }
                    Text("₹16000 Limited Time Offer")
                        .font(.subheadline)
                        .foregroundColor(Color(
                            red: 117/255,
                            green: 116/255,
                            blue: 117/255
                        ))
                }
                
                Button{
                    
                }label: {
                    HStack{
                        Image(systemName: "cart.fill")
                        
                        Text("Buy Now")
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
            .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    temp()
}
