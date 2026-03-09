import Foundation

struct GenerateOTPmodel :  Decodable,Hashable{
    let status : Bool
    let otp : Int
    let msg : String
}
