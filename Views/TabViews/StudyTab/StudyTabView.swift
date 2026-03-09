import SwiftUI

struct StudyTabView: View {
    @Binding var path : NavigationPath
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                
                
                Text(uiString.StudyQuickAccess)
                    .font(.title3)
                    .bold()
                    .padding(.horizontal)
                
                HStack {
                    Button{
                        //path.append(Route.ExamView(ExamUrl: "\(uiString.baseURL)/bookmark_page/QJYvEnPAMfImtzN3O-4W1A"))
                        
                        
                        path.append(Route.BookmarkView(url: apiURL.bookmarkPage ,title: "Bookmark"))
                    }label: {
                        QuickAccessCard(
                            title: uiString.StudyBookmarkButton,
                            icon: "bookmark",
                            showNew: true
                        )
                    }
                    
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(uiString.StudyLearning)
                        .font(.title3)
                        .bold()
                    
                    Text(uiString.StudyLearningSub)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 16
                ) {
                    Button{
                        //UserDefaults.standard.set("1", forKey: "studentId")
                        
                        path.append(Route.MyBatchesView)
                    } label: {
                        LearningCard(
                            title: uiString.StudyCourseButton,
                            icon: "book",
                            bgColor: Color.pink.opacity(0.2)
                        )
                    }
                    
                    Button{
                        path.append(Route.MyDownloadsView)
                    } label: {
                        LearningCard(
                            title: uiString.StudyDownloadButton,
                            icon: "arrow.down.to.line",
                            bgColor: Color.indigo.opacity(0.2)
                        )
                    }
                    
                    Button{
                        path.append(Route.DigitalEbookView)
                    } label: {
                        LearningCard(
                            title: uiString.StudyEbookButton,
                            icon: "books.vertical",
                            bgColor: Color.yellow.opacity(0.25)
                        )
                    }
                    
                    Button{
                        path.append(Route.AllDocView(title: "Support", url: "\(apiURL.mainURL)"))
                    } label: {
                        LearningCard(
                            title: uiString.StudySupportButton,
                            icon: "person.2.fill",
                            bgColor: Color.cyan.opacity(0.3)
                        )
                    }
                    
                }
                .padding(.horizontal)
                Text(uiString.StudyDiscription)
                    .font(.title3)
                    .padding()
                Spacer(minLength: 20)
            }
            .padding(.top)
        }
        .background(Color.white)
        
    }
}


struct QuickAccessCard: View {
    
    let title: String
    let icon: String
    let showNew: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            VStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(.black)
            .frame(width: 120, height: 120)
            .background(Color.white)
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.08), radius: 6)
            
            if showNew {
                Text("NEW")
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .clipShape(Capsule())
                    .offset(x: -8, y: 8)
            }
        }
    }
}



struct LearningCard: View {
    
    let title: String
    let icon: String
    let bgColor: Color
    
    var body: some View {
        HStack(spacing: 14) {
            
            Image(systemName: icon)
                .font(.system(size: 18))
                .frame(width: 40, height: 40)
                .background(Color.white)
                .cornerRadius(12)
            
            Text(title)
                .multilineTextAlignment(.leading)
                .font(.system(size: 15))
            
            //Spacer()
        }
        .foregroundColor(.black)
        .padding()
        .frame(width: 180,height: 80)
        .background(bgColor)
        .cornerRadius(16)
    }
}
