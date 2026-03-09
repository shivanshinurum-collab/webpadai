import SwiftUI

struct FreeVideosList5:View {
    @Binding var path : NavigationPath
    
    var body: some View {
        HStack(spacing: 20){
            Button{
                path.removeLast()
            }label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }.buttonStyle(.plain)
            
            Text("Free Videos")
                .font(.title3)
                .bold()
                .foregroundColor(.white)
            
            Spacer()
        }.padding(.horizontal)
            .padding(.bottom)
            .background(uiColor.ButtonBlue)
        
        ScrollView{
            VStack(alignment: .leading){
                Text("Free videos")
                    .font(.headline)
                    .foregroundColor(.black)
                
                ForEach(1..<10){_ in
                    cardView(Head: "UPSC COURSE 1 SHOT", subHead: "UPSC EXAM preperation", image: "banner")
                    Divider()
                }
                
            }.padding()
        }.navigationBarBackButtonHidden(true)
    }
    
    func cardView(Head : String , subHead : String , image : String) -> some View {
        HStack{
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 150)
            VStack(alignment: .leading){
                Text(Head)
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text(subHead)
                    .font(.caption)
                    .foregroundColor(uiColor.DarkGrayText)
                Spacer()
                Button{
                    path.append(Route.CourseBuy5)
                }label: {
                    HStack{
                        Text("View Course")
                            .font(.headline)
                        Image(systemName: "chevron.forward")
                            .font(.headline)
                    }
                }
            }
        }.padding(.vertical)
    }
}

