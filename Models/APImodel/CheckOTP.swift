import Foundation

struct CheckOTP : Decodable {
    let studentData : StudentData?
    let status : String
    let msg : String
}
