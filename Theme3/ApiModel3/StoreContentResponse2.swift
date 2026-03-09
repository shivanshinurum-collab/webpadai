
import Foundation

// MARK: - Main Response
struct NotesContentResponse2: Codable {
    let purchaseCondition: Bool
    let studentId: String
    let batchId: String
    let batch_id: String
    let fullURL: String
    let allData: [NotesContent2]?
    
    enum CodingKeys: String, CodingKey {
        case purchaseCondition
        case studentId
        case batchId
        case batch_id
        case fullURL = "full_url"
        case allData
    }
}

// MARK: - All Data Model
struct NotesContent2: Codable,Identifiable {
    let id: String
    let name: String
    let image: String?
    let payMode: String
    let contentType: String
    let type: String
    let sortOrder: String
    let redirectionURL: String?
    let createdDate: String
    let watchStatus: Int
    
    // MARK: - Exam Specific
    let insTitle: String?
    let insDesc: String?
    let examId: String?
    let mcqCount: Int?
    let isResultAvailable: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case payMode = "pay_mode"
        case contentType = "content_type"
        case type
        case sortOrder = "sort_order"
        case redirectionURL = "redirection_url"
        case createdDate = "created_date"
        case watchStatus
        
        case insTitle = "ins_title"
        case insDesc = "ins_desc"
        case examId = "exam_id"
        case mcqCount
        case isResultAvailable
        
    }
}
