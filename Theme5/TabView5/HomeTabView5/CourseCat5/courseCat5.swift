import SwiftUI

struct courseCat5 : View {
    
    @Binding var path : NavigationPath
    
    var body: some View {
        // MARK: - Top Header
        HStack {
            Button{
                path.removeLast()
            }label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
            }.buttonStyle(.plain)
            
            Text("GPAT")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.leading, 8)
            
            Spacer()
        }
        .padding()
        .background(Color.blue)
        
        ScrollView{
            VStack(spacing: 0) {
                
                
                
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: - Title
                        Text("What are you looking for?")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.top)
                        
                        
                        // MARK: - Category Grid
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 16
                        ) {
                            Button{
                                path.append(Route.CourseList5)
                            }label: {
                                categoryCard(title: "Live Courses",
                                             color: Color.orange , image: "LiveCourse")
                            }.buttonStyle(.plain)
                            
                            Button{
                                path.append(Route.CourseList5)
                            }label: {
                                categoryCard(title: "Recorded Courses",
                                             color: Color.blue.opacity(0.7) , image: "RecordedCourses")
                            }.buttonStyle(.plain)
                            
                            Button{
                                path.append(Route.CourseList5)
                            }label: {
                                categoryCard(title: "Online Test",
                                             color: Color.green.opacity(0.7), image: "OnlineTest")
                            }.buttonStyle(.plain)
                            
                            Button{
                                path.append(Route.CourseList5)
                            }label: {
                                categoryCard(title: "Books",
                                             color: Color.purple.opacity(0.8), image: "Books")
                            }.buttonStyle(.plain)
                            
                        }
                        
                        
                        Divider()
                            .padding(.vertical, 10)
                    }
                    
                    VStack(alignment: .leading){
                        Text("Courses (40)")
                            .font(.subheadline)
                        
                        ForEach(1..<10){_ in
                            Button{
                                path.append(Route.CourseBuy5)
                            }label: {
                                CourseCardCourse5(image: "banner", name: "Courses", price: "1799", oprice: "3999")
                            }.buttonStyle(.plain)
                            
                            Rectangle()
                                .frame(maxWidth: .infinity , maxHeight: 1.5)
                                .foregroundColor(uiColor.system)
                        }
                        
                        Button{
                            
                        }label: {
                            Text("View All Courses")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity , maxHeight: 15)
                            
                        }.buttonStyle(.plain)
                            .padding()
                            .background(uiColor.ButtonBlue)
                            .cornerRadius(15)
                            .padding()
                        
                    }
                    
                }.padding(.horizontal)
                    .scrollIndicators(.hidden)
                
            }
        }.scrollIndicators(.hidden)
            .refreshable {
                print("Refresh")
            }
        .navigationBarBackButtonHidden(true)
            
    }
    
    func categoryCard(title: String, color: Color , image : String) -> some View {
        ZStack(alignment: .bottomLeading) {
            
            RoundedRectangle(cornerRadius: 16)
                .fill(color)
                .frame(height: 140)
                .shadow(radius: 4)
            
            VStack(alignment: .leading, spacing: 8) {
              
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .bold()
                
                
                
                HStack{
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                }
            }.padding()
            
        }
    }
    
}
