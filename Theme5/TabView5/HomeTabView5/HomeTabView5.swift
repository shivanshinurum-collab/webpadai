import SwiftUI

struct HomeTabView5:View{
    @Binding var path : NavigationPath
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    let connect : [String] = ["youtube","instagram","facebook","telegram","twitter","linkedin"]
    
    var body: some View{
        ScrollView{
            ScrollView(.horizontal){
                HStack{
                    ForEach(1..<6){_ in
                        Image("banner")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            
            VStack(alignment: .leading){
                Text("What do you want to learn?")
                    .foregroundColor(.black)
                    .font(.headline)
                
                ScrollView(.horizontal){
                    
                    HStack{
                        ForEach(1..<6){_ in
                            Button{
                                path.append(Route.courseCat5)
                            }label: {
                                VStack{
                                    Image("course")
                                        .resizable()
                                        .background(uiColor.CreamBlueGreen)
                                        .frame(width: 80 , height: 80)
                                        .clipShape(.circle)
                                    
                                    Text("course")
                                        .font(.caption)
                                    
                                }.padding(8)
                            }.buttonStyle(.plain)
                        }
                    }
                    
                }.scrollIndicators(.hidden)
                
            }.padding()
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 8)
                .foregroundColor(uiColor.system)
            
            VStack(alignment: .leading){
                Text("What are You looking for?")
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 18) {
                        
                        Button{
                            
                        }label: {
                            HomeTabGridCardView5(title: "FREE\nTests", color: .blue, isFree: true, image: "doc.text")
                        }.buttonStyle(.plain)
                        
                        Button{
                            path.append(Route.FreeStudyMaterial5(selectedTab: 0))
                        }label: {
                            HomeTabGridCardView5(title: "FREE\nVideos", color: .blue, isFree: true, image: "play.rectangle.fill")
                        }.buttonStyle(.plain)
                        
                        Button{
                            path.append(Route.FreeStudyMaterial5(selectedTab: 1))
                        }label: {
                            HomeTabGridCardView5(title: "FREE\nMaterials", color: .blue, isFree: true, image: "book.fill")
                        }.buttonStyle(.plain)
                        
                        Button{
                            path.append(Route.CourseList5)
                        }label: {
                            HomeTabGridCardView5(title: "GDC\nPRIME", color: .red, isFree: false, image: "books.vertical.fill")
                        }.buttonStyle(.plain)
                        
                        Button{
                            path.append(Route.CourseList5)
                        }label: {
                            HomeTabGridCardView5(title: "Bookशाला", color: .red, isFree: false, image: "book.closed.fill")
                        }.buttonStyle(.plain)
                        
                        Button{
                            path.append(Route.CourseList5)
                        }label: {
                            HomeTabGridCardView5(title: "Test\nSeries", color: .red, isFree: false, image: "checklist")
                        }.buttonStyle(.plain)
                        
                        Button{
                            path.append(Route.CourseList5)
                        }label: {
                            HomeTabGridCardView5(title: "GDC पाठशाला", color: .teal, isFree: false, image: "person.3.fill")
                        }.buttonStyle(.plain)
                        
                        Button{
                            path.append(Route.CourseList5)
                        }label: {
                            HomeTabGridCardView5(title: "D.Pharm", color: .teal, isFree: false, image: "person.fill")
                        }.buttonStyle(.plain)
                        
                        Button{
                            path.append(Route.CourseList5)
                        }label: {
                            HomeTabGridCardView5(title: "B.Pharm", color: .teal, isFree: false, image: "person.fill")
                        }.buttonStyle(.plain)
                        
                    }
                    .padding()
                }
                
            }.padding()
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 8)
                .foregroundColor(uiColor.system)
            
            VStack{
                HStack{
                    Text("Free Videos")
                    Spacer()
                    Button{
                        path.append(Route.FreeVideosList5)
                    }label: {
                        Text("see All")
                        Image(systemName: "arrow.right")
                    }
                }
                
                ScrollView(.horizontal){
                    HStack(spacing: 8){
                        ForEach(1..<6){_ in
                            HomeTabVideoCard5(path: $path , image: "banner", time: "00:10:15", courseName: "UPCS Course 1Shot")
                        }
                    }
                }.scrollIndicators(.hidden)
                
                
            }.padding()
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 8)
                .foregroundColor(uiColor.system)
            
            
            VStack{
                HStack{
                    Text("Featured Courses")
                    Spacer()
                    Button{
                        path.append(Route.CourseList5)
                    }label: {
                        Text("see All")
                        Image(systemName: "arrow.right")
                    }
                }
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(1..<7){_ in
                            Button{
                                path.append(Route.CourseBuy5)
                            }label: {
                                HomeTabCourseCard5(image: "banner", name: "UPSC QUICK RIVISION", price: "1799", oprice: "3999")
                            }.buttonStyle(.plain)
                            
                                .padding(5)
                        }
                    }
                }.scrollIndicators(.hidden)
                
            }.padding()
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 8)
                .foregroundColor(uiColor.system)
            
            VStack(alignment: .leading){
                Text("Connect With Us")
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(connect , id: \.self){i in
                            Button{
                                
                            }label: {
                                VStack{
                                    Image(i)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70 , height: 80)
                                    
                                    Text(i)
                                        .font(.caption)
                                    
                                }
                            }.buttonStyle(.plain).padding(5)
                        }
                    }
                }.scrollIndicators(.hidden)
                
            }.padding()
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 10)
                .foregroundColor(uiColor.system)
            
        }
        .scrollIndicators(.hidden)
        .refreshable {
            print("Refresh")
        }
    }
}
