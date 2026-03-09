import SwiftUI

struct BuyCourseView : View {
    
    @Binding var path : NavigationPath
    
    //let course : batchData
    let course_id : String
    let course_name : String
    
    
    @State var selectedTab : CourseAboutTabModel = .overview
    
    @State var tab : Int = 0
    
    @State var coupon : String = ""
    
    var body: some View {
        HStack{
            Button{
                path.removeLast()
            }label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: uiString.backSize))
            }
            Spacer()
            Text(course_name)
                .font(.system(size: uiString.titleSize).bold())
            
            Spacer()
        }
        .foregroundColor(uiColor.ButtonBlue)
        .padding(.horizontal)
        Divider()
        HStack{
            ScrollView(.horizontal , showsIndicators: false){
                HStack{
                ForEach(CourseAboutTabModel.allCases , id: \.self) { tab in
                    
                        if(tab.rawValue == "Live Class"){
                            if(CourseOverview.isLiveClass == 1){
                                Button{
                                    selectedTab = tab
                                }label: {
                                    Text(tab.rawValue)
                                        .padding(.vertical , 7)
                                        .padding(.horizontal)
                                        .foregroundColor(
                                            selectedTab == tab ? .white : .black
                                        )
                                        .background(
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(
                                                    selectedTab == tab
                                                    ? uiColor.ButtonBlue
                                                    : Color.clear
                                                )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 18)
                                                .stroke(
                                                    selectedTab == tab
                                                    ? Color.clear
                                                    : uiColor.DarkGrayText ,
                                                    lineWidth: 1
                                                )
                                        )
                                }//.frame(maxWidth: .infinity)
                                .padding(.horizontal)
                            }
                        }else{
                            Button{
                                selectedTab = tab
                            }label: {
                                Text(tab.rawValue)
                                    .padding(.vertical , 7)
                                    .padding(.horizontal)
                                    .foregroundColor(
                                        selectedTab == tab ? .white : .black
                                    )
                                    .background(
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(
                                                selectedTab == tab
                                                ? uiColor.ButtonBlue
                                                : Color.clear
                                            )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(
                                                selectedTab == tab
                                                ? Color.clear
                                                : uiColor.DarkGrayText ,
                                                lineWidth: 1
                                            )
                                    )
                            }//.frame(maxWidth: .infinity)
                            .padding(.horizontal)
                        }
                    }
                }
            }
           
        }.padding()
        .navigationBarBackButtonHidden(true)
        .task{
            print("IDS = \(course_id)")
        }
        
        switch selectedTab {
        case .overview:
            CourseOverview(path: $path ,course_id: course_id)
        case .content:
            CourseContent(path: $path ,batch_id: course_id)
        case .liveClass:
            LiveClassView(path: $path ,batch_id: course_id)
        }
        
        Spacer()
    }
    
}
