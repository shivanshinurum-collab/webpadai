import Foundation

struct MyBatchesModel : Codable {
    let status : String
    let msg  : String
    let yourBatch : [MyBatch]?
}
struct MyBatch: Codable, Identifiable {

    let id: String
    let createdDate: String?
    let durationType: String?
    let validityIn: String?
    let batchExpiry: String?
    let totalValidity: String?
    let batchName: String
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let batchType: String
    let batchPrice: String
    let noOfStudent: String
    let description: String
    let batchImage: String
    let batchOfferPrice: String
    let studentStartDate: String?
    let batchStartDate: String?
    let status: Int
    let isExpired: Bool
    let paymentType: String
    let currencyCode: String
    let currencyDecimalCode: String

    enum CodingKeys: String, CodingKey {
        case id
        case createdDate = "created_date"
        case durationType = "duration_type"
        case validityIn = "validity_in"
        case batchExpiry = "batch_expiry"
        case totalValidity = "total_validity"
        case batchName
        case startDate
        case endDate
        case startTime
        case endTime
        case batchType
        case batchPrice
        case noOfStudent
        case description
        case batchImage
        case batchOfferPrice
        case studentStartDate = "studentstartDate"
        case batchStartDate
        case status
        case isExpired
        case paymentType
        case currencyCode
        case currencyDecimalCode
    }
}

/*struct MyBatch : Codable {
    let id : String
    let created_date : String
    let duration_type : String
    let validity_in : String
    let batch_expiry : String
    let total_validity : String
    let batchName : String
    let startDate : String
    let endDate : String
    let startTime : String
    let endTime : String
    let batchType : String
    let batchPrice  :String
    let noOfStudent : String
    let description : String
    let batchImage  :String
    let batchOfferPrice :String
    let studentstartDate :String
    let batchStartDate :String
    let status : Int
    let isExpired : Bool
    let paymentType : String
    let currencyCode : String
    let currencyDecimalCode :String
}*/
