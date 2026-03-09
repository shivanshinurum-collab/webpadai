
import Foundation

struct BannerResponse: Codable {
    let data: [[String]]
    let disableDeveloperSetting: String
    let filesUrl: String

    enum CodingKeys: String, CodingKey {
        case data
        case disableDeveloperSetting = "disable_developer_setting"
        case filesUrl
    }
}
