struct LiveClassResponse: Codable {
    let liveClass: [LiveClass]?
    let filesUrl: String?
    let status: String
    let purchaseCondition: Bool?
    let msg: String
}
struct LiveClass: Codable, Identifiable {
    let liveClassSettingId: String
    let joinUrl: String
    let videoId: String
    let type: String
    let name: String
    let title: String
    let teachImage: String
    let endTime: String

    // SwiftUI Identifiable
    var id: String { liveClassSettingId }

    enum CodingKeys: String, CodingKey {
        case liveClassSettingId = "live_class_setting_id"
        case joinUrl = "join_url"
        case videoId = "video_id"
        case type
        case name
        case title
        case teachImage
        case endTime
    }
}
