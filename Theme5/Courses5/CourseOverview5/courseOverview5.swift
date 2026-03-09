import SwiftUI

struct CourseOverview5: View {
    @Binding var path : NavigationPath
    
    @State static var isLiveClass: Int = 0
    @State static var isTestSeries: Int = 0
    
    let course_id: String = "31"
    
    @State var batch: Batch?
    @State var batchResponse: getBatchDetailResponse?
    //@StateObject private var iap = IAPManager()
    
    
    
    @State private var showPaymentDialog = false

    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            ScrollView() {
                CourseAbout5()
 /*               if let unwrappedBatch = batch, let unwrappedBatchResponse = batchResponse {
                    
                    
                } else {
                    VStack {
                        ProgressView()
                        Text("Loading course details...")
                            .foregroundColor(uiColor.DarkGrayText)
                            .padding(.top)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                }
*/            }
            .scrollIndicators(.hidden)
            
            
            
            
            
        }.onAppear {
            fetchBatches()
        }
    }
    
    func fetchBatches() {
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        var components = URLComponents(
            string: apiURL.getBatchDetail
        )

        components?.queryItems = [
            URLQueryItem(name: "batch_id", value: course_id),  //  Use course.id
            URLQueryItem(name: "student_id", value: student_id)
        ]

        guard let url = components?.url else {
            print(" Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(" API Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print(" No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(getBatchDetailResponse.self, from: data)
                
                print("Batch ID = ",course_id)
                DispatchQueue.main.async {
                    // ✅ Store the response
                    self.batch = decodedResponse.batch
                    self.batchResponse = decodedResponse
                    
                    CourseOverview.isLiveClass = decodedResponse.isLiveClass
                    CourseOverview.isTestSeries = decodedResponse.isTestSeriesAvailable
                    
                }
            } catch {
                print(" Decode Error:", error)
               
            }
        }.resume()
    }
}


