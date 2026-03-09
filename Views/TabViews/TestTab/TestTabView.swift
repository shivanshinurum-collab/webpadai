import SwiftUI

struct TestTabView: View {
    @Binding var path: NavigationPath
    @State var search: String = ""
    
    @State var course: [batchData] = []
    @State var isLoading: Bool = false
    
    // Computed property for filtered courses
    var filteredCourses: [batchData] {
        if search.isEmpty {
            return course
        } else {
            return course.filter { batch in
                // Search in batch name, description, or any other relevant fields
                // Adjust the property names based on your batchData model
                batch.batchName.localizedCaseInsensitiveContains(search) == true ||
                batch.description.localizedCaseInsensitiveContains(search) == true //||
                //batch.courseName.localizedCaseInsensitiveContains(search) == true
                // Add more fields as needed based on your batchData structure
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                // Search Bar
                HStack(spacing: 10) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 25))
                            .foregroundColor(.gray)
                        
                        TextField(uiString.TestField, text: $search)
                            .font(.system(size: 20))
                            .autocorrectionDisabled()
                        
                        // Clear button
                        if !search.isEmpty {
                            Button {
                                search = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(.gray)
                    )
                    
                    Button {
                        // Optional: Add filter action
                        hideKeyboard()
                    } label: {
                        Text(uiString.TestFieldButton)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(.violet)
                    .cornerRadius(12)
                }
                
                // Results Count
                Text("\(filteredCourses.count) \(uiString.TestSubHeadline)")
                    .bold()
                
                // Loading Indicator
                if isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .padding()
                        Spacer()
                    }
                } else if filteredCourses.isEmpty {
                    // Empty State
                    VStack(spacing: 10) {
                        Image(systemName: search.isEmpty ? "tray" : "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                            .padding()
                        
                        Text(search.isEmpty ? "No courses available" : "No results found")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        if !search.isEmpty {
                            Text("Try different keywords")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 50)
                } else {
                    // Course List
                    ForEach(filteredCourses) { i in
                        CourseCardView(path: $path, course: i)
                    }
                }
            }
            .padding(15)
        }
        .onAppear {
            if course.isEmpty {
                fetchBatches()
            }
        }
        .refreshable {
            fetchBatches()
        }
    }
    
    // MARK: - Fetch Batches
    func fetchBatches() {
        isLoading = true
        
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        var components = URLComponents(string: apiURL.getTestSeriesBatch)
        
        components?.queryItems = [
            URLQueryItem(name: "student_id", value: student_id)
        ]
        
        guard let url = components?.url else {
            print("❌ Invalid URL")
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error {
                print("❌ API Error:", error.localizedDescription)
                return
            }
            
            guard let data else {
                print("❌ No data received")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BatchCourse.self, from: data)
                DispatchQueue.main.async {
                    self.course = response.batchData
                }
            } catch {
                print("❌ Decode Error:", error)
            }
            
        }.resume()
    }
    
    // MARK: - Hide Keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Extension for Keyboard Dismissal
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

/*import SwiftUI

struct TestTabView : View {
    @Binding var path : NavigationPath
    @State var search:String = ""
    
    
    @State var course : [batchData] = []
    
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading,spacing: 15){
                HStack(spacing:10){
                    HStack(spacing: 10){
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 25))
                        TextField(uiString.TestField,text: $search)
                            .font(.system(size: 20))
                    }.padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(.gray)
                    )
                    
                    Button{
                        
                    } label: {
                        Text(uiString.TestFieldButton)
                            .foregroundColor(.white)
                    }.padding(7)
                        .background(.violet)
                    .cornerRadius(12)
                        
                }
                Text("\(course.count) \(uiString.TestSubHeadline)")
                    .bold()
                
                
                    ForEach(course){ i in
                        CourseCardView(path: $path,course : i)
                    }
                
                
                
            }.padding(15)
        }.onAppear{
            fetchBatches()
        }
    }
    
    func fetchBatches() {
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        var components = URLComponents(
            string: apiURL.getTestSeriesBatch
        )

        components?.queryItems = [
            URLQueryItem(name: "student_id", value: student_id)
        ]

        guard let url = components?.url else {
            print("❌ Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error {
                print("❌ API Error:", error.localizedDescription)
                return
            }

            guard let data else { return }

            do {
                let response = try JSONDecoder().decode(BatchCourse.self, from: data)
                DispatchQueue.main.async {
                    self.course = response.batchData
                }
            } catch {
                print("❌ Decode Error:", error)
            }

        }.resume()
    }
}
*/
