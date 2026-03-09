struct HomeBannerModel : Decodable {
    let status : String
    let filesUrl : String
    let data : [HomeBannerData]
}
struct HomeBannerData : Decodable{
    let banner : String
    let click_action : String
    let type : String
}
