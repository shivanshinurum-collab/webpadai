import Foundation

// MARK: - Root Response
struct StoreDetailResponse: Codable {
    let status: String
    let msg: String
    let paymentType: String
    let isConvenienceFee: String
    let convenienceFee: String
    let purchaseCondition: Bool
    let storeDetail: [StoreDetail]
}

// MARK: - Store Detail Model
struct StoreDetail: Codable, Identifiable {
    let id: String
    let courseName: String
    let courseContent: String
    let courseType: String
    let courseDesc: String
    let coursePrice: String
    let courseOfferPrice: String
    let courseImage: String
    let categoryId: String
    let subcategory: String
    let courseURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case courseName = "course_name"
        case courseContent = "course_content"
        case courseType = "course_type"
        case courseDesc = "course_desc"
        case coursePrice = "course_price"
        case courseOfferPrice = "course_offer_price"
        case courseImage = "course_image"
        case categoryId = "category_id"
        case subcategory
        case courseURL = "course_url"
    }
}

