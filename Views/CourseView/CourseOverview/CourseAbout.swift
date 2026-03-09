import SwiftUI

struct CourseAbout: View {

    let batch: Batch
    let batchResponse: getBatchDetailResponse

    var goal = UserDefaults.standard.string(forKey: "categoryName") ?? ""

    @State private var coupon: String = ""
    @State private var couponResponse: CouponModel?

    @State private var selectedPlanID: String?

    
    private var multiPrice: [MultiPrice] {
        batchResponse.multiPrice ?? []
    }

    private var material: Int {
        batchResponse.totalItemsAvailable
    }

    private var files: Int {
        (Int(batchResponse.totalPDF) ?? 0) +
        (Int(batchResponse.totalNotes) ?? 0) +
        (Int(batchResponse.totalVideos) ?? 0)
    }

   
    var body: some View {
        

        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                
                // MARK: - Title
                Text(batch.batchName)
                    .font(.title2.bold())
                    .foregroundColor(uiColor.black)
                
                // MARK: - Category
                HStack {
                    Image(systemName: "circle.fill").font(.system(size: 7))
                    Text(goal).font(.system(size: 15))
                    
                    Image(systemName: "circle.fill").font(.system(size: 7))
                    Text(batch.subCatName).font(.system(size: 15))
                }
                .foregroundColor(uiColor.DarkGrayText)
                
                // MARK: - Content Type
                HStack {
                    Image("pdf")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                    Text("PDFs")
                    
                    Image("play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                    Text("VIDEOS")
                }
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity,maxHeight: 1)
                // MARK: - About
                Text("About the Course")
                    .font(.title3.bold())
                
                Text(html.htmlToAttributedString(batch.description))
                    .font(.body)
                
                
                
                
                // MARK: - Expiry
                
                
                
                if batch.durationType == "1" {
                    HStack {
                        Image(systemName: "clock").font(.system(size: 22))
                        VStack(alignment: .leading) {
                            Text("Batch Validity")
                                .font(.title2.bold())
                            Text("You will get the course for \(batch.totalValidity) \(batch.validityIn)")
                        }
                    }
                }
                else if batch.durationType == "2" {
                    HStack {
                        Image(systemName: "clock").font(.system(size: 22))
                        VStack(alignment: .leading) {
                            Text("Batch Validity")
                                .font(.title2.bold())
                            Text("Batch will be expired in \(batch.batchExpiry)")
                        }
                    }
                    
                }
                else if batch.durationType == "3" {
                    HStack {
                        Image(systemName: "clock").font(.system(size: 22))
                        VStack(alignment: .leading) {
                            Text("Batch Validity")
                                .font(.title2.bold())
                            Text("You will get the course for lifetime")
                        }
                    }
                    
                    
                }else if batch.durationType == "4" {
                    PricePlanView(multiPrice: multiPrice)
                   
                }
                
                // MARK: - Materials
                HStack {
                    Image("play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                    
                    VStack(alignment: .leading) {
                        Text("\(material) learning material")
                            .font(.title2.bold())
                        Text("\(files) files")
                    }
                }
                
            }.onAppear {
                if selectedPlanID == nil {
                    selectedPlanID = multiPrice.first?.id
                }
            }

            .padding()
        }
    }


    
    
}
