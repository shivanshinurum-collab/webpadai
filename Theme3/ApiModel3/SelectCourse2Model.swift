
import Foundation

// MARK: - Root Response
struct SelectCourse2Model: Codable {
    let status: String?
    let msg: String?
    let courseData: [CourseCategory2Model]?
}

// MARK: - Course Category
struct CourseCategory2Model: Codable , Identifiable{
    var id: String { categoryId }
    
    let categoryId: String
    let categoryName: String
    let thumbnail: String
    let batchData: [BatchModel2]
}

// MARK: - Batch Model
struct BatchModel2: Codable , Identifiable{
    let id: String
    let batchName: String
    let batchImage: String
    let batchPrice: String
    let batchOfferPrice: String
    let subCatId: String
    let purchaseCondition: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case batchName = "batch_name"
        case batchImage = "batch_image"
        case batchPrice = "batch_price"
        case batchOfferPrice = "batch_offer_price"
        case subCatId = "sub_cat_id"
        case purchaseCondition
    }
}
