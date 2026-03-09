import SwiftUI

struct GenerateOTP {
    
    //@Binding var path : NavigationPath
    
    static func sendOTP(email: String , isMobile: Bool){
        
        let token = UserDefaults.standard.string(forKey: "FCMToken")
        let device_name = UIDevice.current.name
        let osVersion = UIDevice.current.systemVersion
        let app_version = "55"
        
        var components = URLComponents(
            string: apiURL.generateOTP
        )
        
        components?.queryItems = [
            URLQueryItem(name: "mobile_email", value: email),
            URLQueryItem(name: "isFromMobile", value: isMobile ? "1" : "0"),
            URLQueryItem(name: "device_name", value: device_name),
            URLQueryItem(name: "app_version", value: app_version),
            URLQueryItem(name: "device_os_version", value: osVersion),
            URLQueryItem(name: "token" , value: token),
        ]
        
        guard let url = components?.url else { return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            print("User : " + email )
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            
            //path.append(Route.OTPView(user: "+91\(mobile)"))
            DispatchQueue.main.async {
                //path.append(Route.OTPView(user: email))
            }
                    
            
        }.resume()
    }
}
