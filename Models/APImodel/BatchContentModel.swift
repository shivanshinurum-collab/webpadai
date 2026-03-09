import Foundation

// MARK: - Batch Content Response
struct BatchContentResponse: Decodable {
    let purchaseCondition: Bool
    let studentId: String
    let batchId: String
    let batch_id: String
    let fullUrl: String
    let allData: [ContentItem]
    
    enum CodingKeys: String, CodingKey {
        case purchaseCondition
        case studentId
        case batchId
        case batch_id
        case fullUrl = "full_url"
        case allData
    }
}

// MARK: - Content Item
struct ContentItem: Decodable, Identifiable {
    let id: String
    let name: String
    let image: String?
    let payMode: String
    let contentType: String
    let type: String
    let sortOrder: String
    let redirectionUrl: String?
    
    // Exam-specific fields (only present when contentType is "Exam")
    let insTitle: String?
    let insDesc: String?
    let examId: String?
    let isResultAvailable: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case payMode = "pay_mode"
        case contentType = "content_type"
        case type
        case sortOrder = "sort_order"
        case redirectionUrl = "redirection_url"
        case insTitle = "ins_title"
        case insDesc = "ins_desc"
        case examId = "exam_id"
        case isResultAvailable
    }
    
    // MARK: - Helper Properties
    var isFolder: Bool {
        contentType == "Folder"
    }
    
    var isExam: Bool {
        contentType == "Exam"
    }
    
    var isPracticeExam: Bool {
        isExam && type == "Practice"
    }
    
    var isMockExam: Bool {
        isExam && type == "Mock"
    }
    
    var fullImageUrl: String? {
        guard let image = image else { return nil }
        // Assuming you'll pass the fullUrl from the response
        return image
    }
}

// MARK: - Content Type Enum (Optional but helpful)
enum ContentType: String {
    case folder = "Folder"
    case exam = "Exam"
    case video = "Video"
    case pdf = "PDF"
    case unknown
    
    init(rawValue: String) {
        switch rawValue {
        case "Folder": self = .folder
        case "Exam": self = .exam
        case "Video": self = .video
        case "PDF": self = .pdf
        default: self = .unknown
        }
    }
}

// MARK: - Exam Type Enum (Optional but helpful)
enum ExamType: String {
    case practice = "Practice"
    case mock = "Mock"
    case unknown
    
    init(rawValue: String) {
        switch rawValue {
        case "Practice": self = .practice
        case "Mock": self = .mock
        default: self = .unknown
        }
    }
}
