import SwiftUI

struct WelcomeView: View {
    
    @State private var bannerResponse: BannerResponse?

    @State var image : String = ""
    @Binding var path : NavigationPath
    var body: some View {
        
        ZStack (alignment: .bottom){
            
            /* LinearGradient(
             colors: [
             
             Color(red: 0.9, green: 0.9, blue: 0.0),
             .white,
             Color(red: 0.9, green: 0.9, blue: 0.0)
             
             ],
             startPoint: .top,
             endPoint: .bottom
             ).padding(.bottom,50)
             .ignoresSafeArea()*/
            
            //VStack(spacing: 0) {
            
            if let imageName = bannerResponse?.data.first?.first{
                //https://nbg1.your-objectstorage.com/cdnsecure/marinewisdom.com/uploads/login_banners/ce9c1f85d79f9e9abde598e0ea18d2d3.jpg
                //bannerResponse!.filesUrl + imageName
                AsyncImage(url: URL(string: bannerResponse!.filesUrl + imageName)) { image in
                    image.resizable()
                    //.scaledToFill()
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .ignoresSafeArea(edges: .top)
                        .padding(.bottom)
                } placeholder: {
                    Image("logo")
                        .resizable()
                    //.scaledToFill()
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .ignoresSafeArea()
                }
            }
            
            
            
            VStack(alignment:.leading,spacing: 16) {
                
                Text(uiString.WelcomeLoginTitle)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(uiColor.black)
                
                Text(uiString.WelcomeLoginSubTitle)
                    .font(.system(size: 20))
                    .foregroundColor(uiColor.black)
                    .multilineTextAlignment(.leading)
                
                Button {
                    path.append(Route.loginNumView)
                    // Login with mobile
                } label: {
                    Text(uiString.WelcomeMobileButton)
                        .foregroundColor(uiColor.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(uiColor.ButtonBlue)
                        .cornerRadius(12)
                }
                
                Button {
                    path.append(Route.loginEmailView)
                    // Login with email
                } label: {
                    Text(uiString.WelcomeEmailButton)
                        .foregroundColor(uiColor.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(uiColor.ButtonBlue)
                        .cornerRadius(12)
                }
            }
            .padding(24)
            .background(uiColor.white)
            .cornerRadius(26)
            .navigationBarBackButtonHidden(true)
            .onAppear{
                fetchData()
            }
            
        }
    }
   
    func fetchData() {
        
        var components = URLComponents(
            string: apiURL.loginBanners
        )
        
        components?.queryItems = [
            
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
                let decodedResponse = try JSONDecoder().decode(BannerResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.bannerResponse = decodedResponse
                }
            } catch {
                print(" Decode Error:", error)
            }
        }.resume()
    }
    
}

