import Foundation

// MARK: - Main API Response
struct FolderContentResponse: Codable {
    let purchaseCondition: Bool
    let studentId: String
    let batchId: String
    let batchID: String
    let fullUrl: String
    let allData: [FolderContentItem]

    enum CodingKeys: String, CodingKey {
        case purchaseCondition
        case studentId
        case batchId
        case batchID = "batch_id"
        case fullUrl = "full_url"
        case allData
    }
}

// MARK: - Content Item
struct FolderContentItem: Codable, Identifiable {
    let id: String
    let name: String
    let image: String?
    let payMode: String
    let contentType: String
    let type: String
    let sortOrder: String
    let redirectionUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case payMode = "pay_mode"
        case contentType = "content_type"
        case type
        case sortOrder = "sort_order"
        case redirectionUrl = "redirection_url"
    }
}

// MARK: - Helpers (Optional but Useful)
extension FolderContentItem {
    var isFolder: Bool { contentType == "Folder" }
    var isExam: Bool { contentType == "Exam" }
    var isDocument: Bool { contentType == "Document" }
    var isAudio: Bool { contentType == "Audio" }
    var isVideo: Bool { contentType == "Video" }
    var isLink: Bool { contentType == "Link" }
    var isNotes: Bool { contentType.lowercased() == "notes" }
}

