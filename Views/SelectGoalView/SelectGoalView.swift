import SwiftUI


struct SelectGoalView: View {
    
    @Binding var path: NavigationPath
    
    @State private var categories: [Category] = []        // Popular Exams
    @State private var subCategories: [SubCategory] = []  // All Exams
    @State private var isLoading = false
    
    let colors: [Color] = [
                Color.blue.opacity(0.4),
                Color.green.opacity(0.4),
                Color.orange.opacity(0.4),
                Color.purple.opacity(0.4),
                Color.pink.opacity(0.4),
                Color.teal.opacity(0.4),
                Color.indigo.opacity(0.4),
                Color.mint.opacity(0.4),
                Color.cyan.opacity(0.4),
                Color.yellow.opacity(0.4)
            ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Title
                Text(uiString.SelectGoalTitle)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                
                // Popular Exams
                Text(uiString.SelectGoalPopular)
                    .font(.headline)
                    .padding(.horizontal)
                
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
                
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 14
                ) {
                    ForEach(categories) { category in
                        Button {
                            saveGoal(
                                goal: category.categoryName,
                                icon: category.thumbnail,
                                id: category.categoryId
                            )
                            path.append(Route.HomeView)
                        } label: {
                            PopularExamCard(category: category, color: colors.randomElement()!)
                        }
                    }
                }
                .padding(.horizontal)
                
                // All Exams
                Text(uiString.SelectGoalAllExams)
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    ForEach(subCategories) { sub in
                        Button {
                            /*saveGoal(
                                goal: sub.subCategoryName,
                                icon: "",
                                id: sub.subCategoryId
                            )*/
                        } label: {
                            SubCategoryRow(subCategory: sub, color: colors.randomElement()!)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.white)
        .onAppear {
            fetchCategoryData()
        }
    }
    
    // MARK: - SAVE
    func saveGoal(goal: String, icon: String , id : String) {
        UserDefaults.standard.set(goal, forKey: "categoryName")
        UserDefaults.standard.set(icon, forKey: "thumbnail")
        UserDefaults.standard.set(id, forKey: "categoryId")
    }
}

// MARK: - POPULAR CATEGORY CARD
struct PopularExamCard: View {
    
    let category: Category
    let color : Color
    
    var body: some View {
        HStack(spacing: 10) {
            
            AsyncImage(url: URL(string: category.thumbnail)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 28, height: 28)
            
            Text(category.categoryName)
                .font(.subheadline)
                .bold()
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(color)
        .cornerRadius(14)
    }
}

// MARK: - SUB CATEGORY ROW
struct SubCategoryRow: View {
    
    let subCategory: SubCategory
    let color : Color
    
    var body: some View {
        HStack(spacing: 14) {
            
            Circle()
                .fill(color)
                .frame(width: 44, height: 44)
                .overlay(
                    Text(String(subCategory.subCategoryName.prefix(1)))
                        .foregroundColor(.white)
                        .bold()
                )
            
            Text(subCategory.subCategoryName)
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.3))
        )
    }
}

// MARK: - API CALL
extension SelectGoalView {
    
    func fetchCategoryData() {
        isLoading = true
        
        guard let url = URL(string: apiURL.getCategoryData )
        else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            "ci_session=g1fa9aq5p3fh5i2jpu5ghrbsdjfjf8dg",
            forHTTPHeaderField: "Cookie"
        )
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            DispatchQueue.main.async {
                isLoading = false
            }
            
            if let error = error {
                print("API Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(CategoryAPIResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.categories = response.categoryData
                    self.subCategories = response.subcategoryData
                }
            } catch {
                print("Decoding Error:", error.localizedDescription)
            }
            
        }.resume()
    }
}





