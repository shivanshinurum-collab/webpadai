import SwiftUI

struct FileView : View {
    let image : String
    let name : String
    let imageURL : String
    let isPurchased: Bool
    
    var body: some View {
        HStack(spacing: 20){
            AsyncImage(url: URL(string: imageURL)){ img in
                img
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50,height: 50)
            } placeholder: {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50,height: 50)
            }
                
            
            Text(name)
                .font(.headline)
                .foregroundColor(.black)
            
            
            
            Spacer()
            
            if !isPurchased {
                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20,height: 20)
                    .foregroundStyle(.gray)
            } else {
                Image("right.arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20,height: 20)
            }
               // .foregroundColor(uiColor.DarkGrayText)
        }.padding()
    }
}

