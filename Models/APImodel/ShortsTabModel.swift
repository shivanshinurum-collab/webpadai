import Foundation

struct ShortsResponse: Codable {
    let status: String
    let msg: String
    let testimonialList: [Shorts]
}


// MARK: - Models
struct Shorts: Identifiable, Codable {
    let id: String
    let videoPath: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case videoPath = "video_path"
    }
}
/*
struct Shorts: Codable, Identifiable {
    let id: String
    let videoPath: String

    enum CodingKeys: String, CodingKey {
        case id
        case videoPath = "video_path"
    }
}*/
