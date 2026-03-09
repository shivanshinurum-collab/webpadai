import Foundation

// MARK: - Root Response
struct SubcategoryResponse: Codable {
    let status: String
    let msg: String
    let subcategoryList: [Subcategory]
}

// MARK: - Subcategory Model
struct Subcategory: Codable, Identifiable {
    let id: String
    let name: String
}

