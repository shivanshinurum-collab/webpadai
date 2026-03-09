import SwiftUI

struct filterView5: View {
    @Binding var path : NavigationPath
    
    
    @State private var searchText: String = ""
    @State private var selectedItems: Set<String> = []
    
    let categories: [String] = [
        "Uncategorized",
        "GPAT",
        "NIPER",
        "DRUG INSPECTOR",
        "PHARMACIST",
        "D.PHARM",
        "WEEKLY TEST"
    ]
    
    // Filtered Data
    var filteredCategories: [String] {
        if searchText.isEmpty {
            return categories
        } else {
            return categories.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Header
            headerView
            
            // MARK: - Search Bar
            searchBar
            
            // MARK: - List
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredCategories, id: \.self) { category in
                        categoryRow(category)
                    }
                }
                .padding(.top, 8)
            }
            
            // MARK: - Apply Button
            applyButton
        }
        .background(Color(.systemGray6))
        .navigationBarBackButtonHidden(true)
    }
    
    var headerView: some View {
        HStack {
            
            Button {
                path.removeLast()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
            }
            
            Text("Select")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.leading, 8)
            
            Spacer()
            
            Button {
                if selectedItems.count == categories.count {
                    selectedItems.removeAll()
                } else {
                    selectedItems = Set(categories)
                }
            } label: {
                Text("Select All")
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.blue)
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $searchText)
                .textInputAutocapitalization(.never)
        }
        .padding(10)
        .background(Color(.systemGray5))
        .cornerRadius(8)
        .padding()
    }
    
    func categoryRow(_ category: String) -> some View {
        VStack{
            Button {
                toggleSelection(category)
            } label: {
                HStack {
                    Text(category)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 22, height: 22)
                        
                        if selectedItems.contains(category) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
            }
            Divider()
        }
    }
    
    var applyButton: some View {
        Button {
            print("Selected Items:", selectedItems)
        } label: {
            Text("Apply")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .padding()
        }
    }
    
    func toggleSelection(_ category: String) {
        if selectedItems.contains(category) {
            selectedItems.remove(category)
        } else {
            selectedItems.insert(category)
        }
    }
    
    
}

