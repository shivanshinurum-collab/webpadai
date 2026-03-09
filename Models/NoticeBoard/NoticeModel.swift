import Foundation

// MARK: - API Response
struct NoticeResponse: Codable {
    let noticeList: [Notice]?
    let status: String
    let msg: String
}

// MARK: - Notice Model
struct Notice: Codable, Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: String

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case date
    }
}

