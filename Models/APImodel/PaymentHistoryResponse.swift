import Foundation

// MARK: - Root Response
struct PaymentHistoryResponse: Codable {
    let status: String
    let msg: String
    let paymentData: [PaymentHistoryItem]?

    enum CodingKeys: String, CodingKey {
        case status
        case msg
        case paymentData
    }
}

// MARK: - Payment Item
struct PaymentHistoryItem: Codable, Identifiable {

    // MARK: - SwiftUI
    let id: String

    // MARK: - Payment Info
    let batchId: String
    let transactionId: String
    let amount: String
    let createAt: String
    let status: String

    // MARK: - Batch Info
    let batchName: String
    let batchType: String
    let batchPrice: String
    let batchOfferPrice: String

    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String

    let description: String

    // MARK: - Currency
    let currencyCode: String
    let currencyDecimalCode: String

    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case batchId
        case transactionId
        case amount
        case createAt
        case status

        case batchName
        case batchType
        case batchPrice
        case batchOfferPrice

        case startDate
        case endDate
        case startTime
        case endTime

        case description
        case currencyCode
        case currencyDecimalCode
    }

}

