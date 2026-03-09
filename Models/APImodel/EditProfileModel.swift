import SwiftUI

struct ProfileResponse: Codable {
    let status: String
    let imageUrl: String
    let data: [ProfileData]?
}

struct ProfileData: Codable, Identifiable {
    let id: String
    let name: String
    let enrollment_id: String
    let email: String
    let image: String
}

