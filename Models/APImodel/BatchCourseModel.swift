
struct BatchCourse : Codable {
    let status : String
    let msg : String
    let batchData : [batchData]
}

struct batchData: Codable, Identifiable ,Hashable{
    let id: String
    let subCatId: String
    let batchName: String
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let batchType: String
    let durationType: String
    let totalValidity: String
    let validityIn: String
    let batchExpiry: String
    let batchPrice: String
    let noOfStudent: String
    let status: String
    let description: String
    let batchImage: String
    let batchOfferPrice: String
    let subcategory: String
    let paymentType: String
    let currencyCode: String
    let currencyDecimalCode: String
    let purchaseCondition: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case subCatId = "sub_cat_id"
        case batchName
        case startDate
        case endDate
        case startTime
        case endTime
        case batchType
        case durationType = "duration_type"
        case totalValidity = "total_validity"
        case validityIn = "validity_in"
        case batchExpiry = "batch_expiry"
        case batchPrice
        case noOfStudent
        case status
        case description
        case batchImage
        case batchOfferPrice
        case subcategory
        case paymentType
        case currencyCode
        case currencyDecimalCode
        case purchaseCondition = "purchase_condition"
    }
}

