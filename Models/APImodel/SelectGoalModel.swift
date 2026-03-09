// MARK: - API MODELS
struct CategoryAPIResponse: Codable {
    let status: String
    let msg: String
    let categoryData: [Category]
    let subcategoryData: [SubCategory]
}

struct Category: Codable, Identifiable {
    let categoryId: String
    let categoryName: String
    let thumbnail: String
    
    var id: String { categoryId }
}

struct SubCategory: Codable, Identifiable {
    let subCategoryId: String
    let subCategoryName: String
    
    var id: String { subCategoryId }
}
