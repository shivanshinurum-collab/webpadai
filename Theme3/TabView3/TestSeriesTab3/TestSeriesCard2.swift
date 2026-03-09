import SwiftUI

struct TestSeriesCard2: View {
    
    let courseName: String
    let exams: String
    let imageURL : String
    let img:String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                Spacer()
                AsyncImage(url: URL(string: imageURL)){ img in
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                        .padding()
                        .background(uiColor.cardLightBlue)
                        .clipShape(Circle())
                        .padding(.top, 12)
                    
                }placeholder: {
                    Image("\(img)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                        .padding()
                        .background(uiColor.cardLightBlue)
                        .clipShape(Circle())
                        .padding(.top, 12)
                }
                Spacer()
            }
            .background(uiColor.lightGrayText.opacity(0.2))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(courseName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(uiColor.black)
                    //.lineLimit(2)
                
                Text("\(exams) Exams")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
            
            Spacer()
        }.frame(height: 150)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}
