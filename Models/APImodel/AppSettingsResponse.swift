//
//  AppSettingsResponse.swift
//  webpadai
//
//  Created by Shubham Jain on 19/05/26.
//



import Foundation

// MARK: - Root Response
struct AppSettingsResponse: Codable {
    let status: String
    let data: AppSettingsData?
}

// MARK: - Data Model
struct AppSettingsData: Codable {
    let languageName: String?
    let currencyCode: String?
    let currencyDecimalCode: String?
    let paymentType: String?
    let razorpayKeyId: String?
    let razorpaySecretKey: String?
    let paypalClientId: String?
    let paypalSecretKey: String?
    let stripeSecretKey: String?
    let stripePublishableKey: String?
    let payeeUpiId: String?
    let payeeMerchantCode: String?
    let isReferralEnable: String?
    let offerText: String?
    let selectTheme: String?
    let isDownloadPdf: String?
    let isDownloadPdfInternally: String?

    enum CodingKeys: String, CodingKey {
        case languageName
        case currencyCode
        case currencyDecimalCode
        case paymentType
        case razorpayKeyId
        case razorpaySecretKey
        case paypalClientId
        case paypalSecretKey
        case stripeSecretKey
        case stripePublishableKey
        case payeeUpiId
        case payeeMerchantCode
        case isReferralEnable
        case offerText         = "offer_text"
        case selectTheme
        case isDownloadPdf
        case isDownloadPdfInternally
    }
}
