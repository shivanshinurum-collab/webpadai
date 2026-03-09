import Foundation

struct getBatchDetailResponse: Decodable {
    let status: String
    let batchAccess: String?
    let multiPrice: [MultiPrice]?
    let isGST: String
    let batch: Batch
    let coupon: [Coupon]
    let totalExam: String
    let totalVideos: String
    let totalNotes: String
    let totalItemsAvailable: Int
    let totalPDF: String
    let isLiveClass: Int
    let isTestSeriesAvailable: Int
    let isBatchBannerAvailable: Int
    let purchaseCondition: Bool
    let paymentType: String
    let currencyCode: String
    let isConvenienceFee: String
    let convenienceFee: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case batchAccess
        case multiPrice = "multi_price"
        case isGST
        case batch
        case coupon
        case totalExam
        case totalVideos
        case totalNotes
        case totalItemsAvailable
        case totalPDF
        case isLiveClass
        case isTestSeriesAvailable
        case isBatchBannerAvailable
        case purchaseCondition
        case paymentType
        case currencyCode
        case isConvenienceFee
        case convenienceFee
    }
}

struct Batch: Decodable {
    let id: String
    let batchExpiry: String
    let access: String
    let batchName: String
    let description: String
    let batchImage: String
    let validityIn: String
    let categoryName: String
    let subCatId: String
    let subCatName: String
    let batchType: String
    let batchPrice: String
    let batchOfferPrice: String
    let durationType: String
    let totalValidity: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case batchExpiry = "batch_expiry"
        case access
        case batchName = "batch_name"
        case description
        case batchImage = "batch_image"
        case validityIn = "validity_in"
        case categoryName
        case subCatId = "sub_cat_id"
        case subCatName
        case batchType = "batch_type"
        case batchPrice = "batch_price"
        case batchOfferPrice = "batch_offer_price"
        case durationType = "duration_type"
        case totalValidity = "total_validity"
    }
}

struct MultiPrice: Decodable , Identifiable{
    let id: String
    let course_id: String?
    let duration_type: String?
    let duration_value: String?
    let course_price: String?
    let created_at: String?
}

struct Coupon: Decodable {
    // Add properties here when you know the structure
}
