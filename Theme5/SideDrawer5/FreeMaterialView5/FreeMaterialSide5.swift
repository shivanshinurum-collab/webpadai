import SwiftUI

struct FreeMaterialSide5: View {
    
    @Binding var path: NavigationPath
    
    @State var selectedTab : Int = 0
    @State var searchText = ""
    
    // MARK: - Models
    struct StudyItem: Identifiable {
        let id = UUID()
        let title: String
        let author: String
        let category: String
    }
    
    // MARK: - Study Material Data
    @State private var studyMaterials: [StudyItem] = [
        .init(title: "GPAT- PYQ QUESTIONS WITH COMPLETE EXPLANATION",
              author: "GDC",
              category: "Uncategorized"),
        
        .init(title: "GDC DIGESTERS",
              author: "GDC",
              category: "Uncategorized"),
        
        .init(title: "GDC FELICITATION PROGRAMME",
              author: "GDC",
              category: "Uncategorized"),
        
        .init(title: "GDC TOPPERS TALK",
              author: "GDC",
              category: "Uncategorized")
    ]
    
    // MARK: - Video Data
    @State private var videos: [StudyItem] = [
        .init(title: "Pharmacology Crash Course",
              author: "Dr. Sharma",
              category: "GPAT 2026"),
        
        .init(title: "Medicinal Chemistry PYQ Discussion",
              author: "Dr. Patel",
              category: "Important"),
        
        .init(title: "Pharmaceutics Revision Lecture",
              author: "Dr. Mehta",
              category: "Revision")
    ]
    
    @State private var tests: [StudyItem] = [
        .init(title: "Pharmacology Crash Course",
              author: "Dr. Sharma",
              category: "GPAT 2026"),
        
        .init(title: "Medicinal Chemistry PYQ Discussion",
              author: "Dr. Patel",
              category: "Important"),
        
        .init(title: "Pharmaceutics Revision Lecture",
              author: "Dr. Mehta",
              category: "Revision")
    ]
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Header
            headerView
            
            // MARK: - Tabs
            tabView
            
            // MARK: - Search
            searchBar
            
            // MARK: - Total + Sort
            totalSortRow
            
            // MARK: - List
            ScrollView {
                VStack(spacing: 0) {
                    
                    if selectedTab == 0 {
                        ForEach(filteredVideos) { item in
                            materialRow(item: item, isVideo: false)
                        }
                    }else if selectedTab == 1 {
                        ForEach(filteredMaterials) { item in
                            materialRow(item: item, isVideo: false)
                        }
                    }else if selectedTab == 2 {
                        ForEach(filteredMaterials) { item in
                            materialRow(item: item, isVideo: false)
                        }
                    }
                }
            }.refreshable {
                print("Refresh")
            }
        }
        .background(Color(.systemGray6))
        .navigationBarHidden(true)
    }
    
    // MARK: - Filter Logic
    var filteredMaterials: [StudyItem] {
        if searchText.isEmpty {
            return studyMaterials
        }
        return studyMaterials.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var filteredVideos: [StudyItem] {
        if searchText.isEmpty {
            return videos
        }
        return videos.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Header
    var headerView: some View {
        HStack {
            Button {
                path.removeLast()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
            }
            
            Text("Free Material")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.leading, 8)
            
            Spacer()
            
            
        }
        .padding()
        .background(Color.blue)
    }
    
    // MARK: - Tabs
    var tabView: some View {
        HStack {
            
            Button {
                withAnimation {
                    selectedTab = 0
                }
            } label: {
                VStack {
                    Text("DOCUMENTS")
                        .foregroundColor(selectedTab == 0 ? .blue : .gray)
                    
                    Rectangle()
                        .fill(selectedTab == 0 ? Color.blue : Color.clear)
                        .frame(height: 2)
                }
            }
            .frame(maxWidth: .infinity)
            
            
            Button {
                withAnimation {
                    selectedTab = 1
                }
            } label: {
                VStack {
                    Text("VIDEOS")
                        .foregroundColor(selectedTab == 1 ? .blue : .gray)
                    
                    Rectangle()
                        .fill(selectedTab == 1 ? Color.blue : Color.clear)
                        .frame(height: 2)
                }
            }
            .frame(maxWidth: .infinity)
            
            Button {
                withAnimation {
                    selectedTab = 2
                }
            } label: {
                VStack {
                    Text("TESTS")
                        .foregroundColor(selectedTab == 2 ? .blue : .gray)
                    
                    Rectangle()
                        .fill(selectedTab == 2 ? Color.blue : Color.clear)
                        .frame(height: 2)
                }
            }
            .frame(maxWidth: .infinity)
            
            
        }
        .padding(.vertical, 10)
        .background(Color.white)
    }
    
    // MARK: - Search
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $searchText)
        }
        .padding(10)
        .background(Color(.systemGray5))
        .cornerRadius(8)
        .padding()
    }
    
    // MARK: - Total
    var totalSortRow: some View {
        HStack {
            Text("TOTAL (\(selectedTab == 0 ? filteredVideos.count : filteredMaterials.count))")
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text("⇅ SORT")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    // MARK: - Row
    func materialRow(item: StudyItem, isVideo: Bool) -> some View {
        VStack {
            HStack(spacing: 12) {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.systemGray5))
                        .frame(width: 80, height: 70)
                    
                    Image(systemName: isVideo ? "play.rectangle.fill" : "folder.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                        .foregroundColor(isVideo ? .red : .orange)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("by \(item.author)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "tag.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(item.category)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            .padding()
            
            Divider()
        }
    }
}


/*import SwiftUI
import SwiftUI

struct FreeStudyMaterial4: View {
    @Binding var path : NavigationPath
    
    @State private var selectedTab = 1
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Header
            headerView
            
            // MARK: - Segmented Tabs
            tabView
            
            // MARK: - Search Bar
            searchBar
            
            // MARK: - Total + Sort
            totalSortRow
            
            // MARK: - List
            ScrollView {
                VStack(spacing: 0) {
                    
                    materialRow(title: "GPAT- PYQ QUESTIONS WITH COMPLETE EXPLANATION")
                    materialRow(title: "GDC DIGESTERS")
                    materialRow(title: "GDC FELICITATION PROGRAMME")
                    materialRow(title: "GDC TOPPERS TALK")
                }
            }
            
        }
        .background(Color(.systemGray6))
        .navigationBarHidden(true)
    }
    var headerView: some View {
        HStack {
            Image(systemName: "arrow.left")
                .foregroundColor(.white)
            
            Text("Study Material")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.leading, 8)
            
            Spacer()
            
            Image(systemName: "line.3.horizontal.decrease")
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.blue)
    }

    var tabView: some View {
        HStack {
            
            Button{
                selectedTab = 0
            }label:{
                VStack{
                    Text("VIDEO")
                        .foregroundColor(.gray)
                    Rectangle()
                        .frame(width: 110,height: 1)
                }
            }
            .foregroundColor(selectedTab == 0 ? .blue : .gray)
            .font(.subheadline)
            .frame(maxWidth: .infinity)
            
            Button{
                selectedTab = 1
            }label: {
                VStack{
                    Text("STUDY MATERIAL")
                        .foregroundColor(.gray)
                    Rectangle()
                        .frame(width: 110,height: 1)
                }
            }
            .foregroundColor(selectedTab == 1 ? .blue : .gray)
            .font(.subheadline)
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 10)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3)),
            alignment: .bottom
        )
    }

    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $searchText)
        }
        .padding(10)
        .background(Color(.systemGray5))
        .cornerRadius(8)
        .padding()
    }

    
    var totalSortRow: some View {
        HStack {
            Text("TOTAL (4)")
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text("⇅ SORT")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    
    func materialRow(title: String) -> some View {
        VStack {
            HStack(spacing: 12) {
                
                // Folder Icon Box
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.systemGray5))
                        .frame(width: 80, height: 70)
                    
                    Image(systemName: "folder.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .foregroundColor(.orange)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("by GDC")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "tag.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("Uncategorized")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            .padding()
            
            Divider()
        }
    }

    
    
}
*/
