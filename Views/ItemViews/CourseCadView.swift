import SwiftUI
struct CourseCardView : View {
    @Binding var path : NavigationPath
    @State private var textWidth: CGFloat = 0
    
    let course : batchData
   
    var body: some View {
        //let batchprice = Int(course.batchPrice)
        //let offerprice = Int(course.batchOfferPrice)
        VStack(alignment:.leading,spacing: 10){
            HStack(spacing:10){
                Text(course.batchName)
                    .font(Font.title3.bold())
                    .padding(.bottom,10)
                Spacer()
                Button{
                    
                }label: {
                    Text("New")
                        .foregroundColor(.white)
                        .padding(5)
                        .background(.yellow.opacity(0.9))
                        .cornerRadius(12)
                }
                
                Button{
                    
                }label: {
                    Image("whatsapp_E")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                }
            }
            
            AsyncImage(url: URL(string: course.batchImage)) { img in
                img
                    .image?.resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom , 10)
                    .frame(maxWidth: .infinity)
            }
            
            HStack(spacing:20){
                Image("exam")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 27)
                Text(course.subcategory)
                    .font(.system(size: 18))
            }.padding(.bottom,10)
            
            HStack(spacing:10){
                Image("calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 27)
                
                Text("Start batch frome ")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                Text("•\(course.startDate) to \(course.endDate)")
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom,10)
            Divider()
                .frame(height: 1)
                .background(.gray.opacity(0.5))
                .padding(.bottom,10)
            HStack{
                Text(course.currencyDecimalCode + course.batchOfferPrice)
                    .font(.system(size: 20).bold())
                    .foregroundColor(uiColor.ButtonBlue)
                ZStack{
                    
                    Text(course.currencyDecimalCode + course.batchPrice)
                        .font(.system(size: 20).bold())
                        .foregroundColor(uiColor.DarkGrayText)
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
                        .background(.black)
                }
            }
            
            Text("(for full course)")
            
            HStack{
                Button{
                    path.append(Route.BuyCourseView(course_id: course.id, course_name: course.batchName))
                }label: {
                    Text("Explore")
                        .bold()
                        .foregroundColor(.black)
                        .font(.system(size: 22))
                        .frame(maxWidth: .infinity , minHeight: 55)
                }
                    //.frame(maxWidth: .infinity , minHeight: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black.opacity(0.3), lineWidth: 1)
                    )
                Button{
                    path.append(Route.BuyCourseView(course_id: course.id, course_name: course.batchName))
                } label: {
                    Text("BuyNow")
                        .bold()
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                        .frame(maxWidth: .infinity , minHeight: 55)
                }
                    //.frame(maxWidth: .infinity , minHeight: 55)
                    .background(uiColor.ButtonBlue)
                    .cornerRadius(15)
            }
            
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.black.opacity(0.3) , lineWidth: 1)
        ).navigationBarBackButtonHidden(true)
        .padding(10)
        
    }
    
}
