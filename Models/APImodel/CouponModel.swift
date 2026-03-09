import Foundation

struct CouponModel: Codable {
    let status: String
    let message: String
    let couponResult: CouponResult?
}


struct CouponResult: Codable {
    let coupon_code: String
    let discount_type: String
    let discount_percentage: String
}


