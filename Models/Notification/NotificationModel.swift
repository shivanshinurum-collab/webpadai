import Foundation

// MARK: - Root Response
struct NotificationResponse: Codable {
    let notification: [AppNotification]
    let status: String
    let msg: String
}

// MARK: - Notification Model
struct AppNotification: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let image: String
    let createdDate: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case image
        case createdDate = "created_date"
    }
}
