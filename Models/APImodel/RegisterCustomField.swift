struct CustomFieldResponse: Decodable {
    let status: String
    let msg: String
    let result: [CustomField]
}

struct CustomField: Decodable, Identifiable {
    let id: String
    let fieldName: String
    let fieldType: String
    let required: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case fieldName = "field_name"
        case fieldType = "field_type"
        case required
        case createdAt = "created_at"
    }

    var isRequired: Bool {
        required == "1"
    }
}

struct CustomFieldPayload: Codable {
    let fieldType: String
    let fieldName: String
    let fieldAnswer: String
}
