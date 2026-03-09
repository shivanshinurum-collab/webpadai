import SwiftUI

struct CourseBuy5 : View {
    
    @Binding var path : NavigationPath
    
    //let course : batchData
    let course_id : String = "1"
    let course_name : String = "UPCS Course"
    let purchase = false
    
    @State var selectedTab : CourseAboutTabModel = .overview
    
    @State var tab : Int = 0
    
    @State var coupon : String = ""
    @State private var textWidth: CGFloat = 0
    
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
            
            Button{
                
            }label: {
                Image("share")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
            }
            
        }
        .foregroundColor(.black)
        .padding(.horizontal)
        
        Divider()
        
        VStack{
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
                                .padding(.horizontal,8)
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
                            .padding(.horizontal,8)
                        }
                    }
                }
            }
            
            switch selectedTab {
            case .overview:
                CourseOverview5(path: $path)
            case .content:
                CourseContentView5(path:$path)
            case .liveClass:
                LiveClassView(path: $path ,batch_id: course_id)
            }
             
        }
        .padding(.horizontal,8)
        .navigationBarBackButtonHidden(true)
        .task{
            print("IDS = \(course_id)")
        }
        
        
        if(purchase != true) {
            HStack() {
                VStack(alignment: .leading){
                    Text("₹ 899")
                        .font(.headline)
                        .foregroundColor(.white)
                    HStack{
                        ZStack{
                            Text("₹ 1,199")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .onAppear {
                                                textWidth = geo.size.width
                                            }
                                    }
                                )
                            Divider()
                                .frame(width: textWidth ,height: 1)
                                .background(.white)
                        }
                        Text("25% OFF")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                }.padding(.leading)
                
                Spacer()
                Button{
                    
                }label: {
                    Text("Buy now")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                }.frame(width: 150)
                    .buttonStyle(.plain)
                    .background(uiColor.ButtonBlue)
                    .cornerRadius(11)
                    .padding(.top)
                    .padding(.trailing)
                
            }.frame(maxWidth: .infinity , alignment: .bottom)
                .background(uiColor.darkBlue)
        }
        
        
    }
    
}


