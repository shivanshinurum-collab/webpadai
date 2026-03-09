
import Foundation

struct BatchResponse2Model: Codable {
    
    var purchaseCondition: Bool?
    var studentId: Int?
    var batchId: String?
    var batch_id: String?
    var full_url: String?
    var allData: [BatchItem2Model]?
    var getVideoId: String?
    var getFolderId: String?
    var getNextVideo: [String]?
}

struct BatchItem2Model: Codable, Identifiable {
    var id: String?
    var name: String?
    var image: String?
    var pay_mode: String?
    var content_type: String?
    var type: String?
    var sort_order: String?
    var redirection_url: String?  
    var totalModule: Int?
    var completedModule: Int?
}

