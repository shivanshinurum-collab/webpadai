import SwiftUI


struct ActivateBatch : View{
    @Binding var path : NavigationPath
    @State var BatchCode : String = ""
    @State var Response : String = ""
    @State var Status : String = ""
    
    @State var showLoading : Bool = false
    
    var body: some View{
        underProcess(title: "Under Construction", about: "")
    }
    //Under Construction
    //Future Build
/*    var body: some View {
        
        ZStack(alignment: .top){
            HStack{
                Button{
                    path.removeLast()
                }label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: uiString.backSize))
                        .foregroundColor(uiColor.white)
                }
                Spacer()
                Text(uiString.BatchTitle)
                    .font(.system(size: uiString.titleSize).bold())
                    .foregroundColor(uiColor.white)
                Spacer()
            }.padding(.horizontal , 15)
            ZStack{
                RoundedRectangle(cornerRadius: 45)
                    .foregroundColor(uiColor.white)
                    .ignoresSafeArea()
                    .padding(.top , 70)
                VStack(spacing: 10){
                    
                    VStack(spacing:25){
                        Text(uiString.BatchHead)
                            .multilineTextAlignment(.center)
                            .bold()
                            .foregroundColor(uiColor.DarkGrayText)
                        
                        TextField(uiString.BatchField , text: $BatchCode)
                            .frame(maxHeight:50)
                            .padding(10)
                            .padding(.horizontal,15)
                            .background(
                                RoundedRectangle(cornerRadius: 11)
                                    .stroke(.black.opacity(0.6),lineWidth: 1)
                            )
                            .padding(.bottom , 30)
                            .onChange(of: BatchCode){
                                Response = ""
                            }
                        
                        if showLoading {
                            ProgressView()
                        }
                        
                        
                        Button{
                            if(BatchCode != ""){
                                showLoading = true
                                fetchData()
                            }else{
                                Response = "Please Enter Batch Code"
                                Status = "false"
                            }
                        }label: {
                            Text(uiString.BatchApplyButton)
                                .font(.title3.bold())
                                .foregroundColor(uiColor.white)
                                .padding()
                                .padding(.horizontal , 40)
                                .background(
                                    LinearGradient(colors: [.yellow , .orange], startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(25)
                        }
                        
                        if(Status == "false"){
                            Text("\(Response)")
                                .multilineTextAlignment(.center)
                                .bold()
                                .foregroundColor(uiColor.Error)
                        }
                        if(Status == "true"){
                            Text("\(Response)")
                                .multilineTextAlignment(.center)
                                .bold()
                                .foregroundColor(uiColor.green)
                        }
                        
                        Spacer()
                    }.padding(25)
                        .background(.clear)
                    
                }.padding(.top , 100)
            }
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity)
        .background(uiColor.ButtonBlue)
        .navigationBarBackButtonHidden(true)
        
        
    }
    
    func fetchData() {
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        
        var components = URLComponents(
            string: apiURL.activateBatch
        )
        
        components?.queryItems = [
            URLQueryItem(name: "uid", value: student_id),
            URLQueryItem(name: "activation_code", value: BatchCode)
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
                let decodedResponse = try JSONDecoder().decode(ActivationCodeResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.Response = decodedResponse.msg
                    self.Status = decodedResponse.status
                    self.showLoading = false
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
 */
}




