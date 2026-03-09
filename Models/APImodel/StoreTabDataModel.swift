import Foundation

// MARK: - Root Response
struct StoreResponse: Codable {
    let status: String
    let msg: String
    let storeCategoryData: [StoreCategory]
    let storeCourseData: [StoreCourse]
}

// MARK: - Category Model
struct StoreCategory: Codable, Identifiable {
    let categoryId: String
    let categoryName: String
    let totalProduct: Int

    // Conform to Identifiable
    var id: String { categoryId }
}

// MARK: - Course Model
struct StoreCourse: Codable, Identifiable {
    let id: String
    let courseName: String
    let courseType: String
    let paymentType: String
    let coursePrice: String
    let courseOfferPrice: String
    let courseImage: String
    let categoryId: String
    let subcategory: String?

    enum CodingKeys: String, CodingKey {
        case id
        case courseName = "course_name"
        case courseType = "course_type"
        case paymentType = "payment_type"
        case coursePrice = "course_price"
        case courseOfferPrice = "course_offer_price"
        case courseImage = "course_image"
        case categoryId = "category_id"
        case subcategory
    }
}

