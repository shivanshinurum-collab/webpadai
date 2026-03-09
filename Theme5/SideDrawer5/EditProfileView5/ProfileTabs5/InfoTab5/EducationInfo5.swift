import SwiftUI

struct EducationInfo5 : View {
    var body : some View {
        VStack(alignment: .leading , spacing: 15){
            Rectangle()
                .frame(height: 1)
                .foregroundColor(uiColor.system)
            
            HStack(spacing: 20){
                Image(systemName: "graduationcap")
                VStack(alignment: .leading){
                    Text("College / University Name")
                    Text("_______________________")
                        .foregroundColor(uiColor.system)
                }
                
                Spacer()
            }
            
            HStack(spacing: 20){
                Image(systemName: "trophy")
                VStack(alignment: .leading){
                    Text("Marks in College (in %)")
                    Text("_______________________")
                        .foregroundColor(uiColor.system)
                }
                
                Spacer()
            }
            
            HStack(spacing: 20){
                Image(systemName: "square.and.arrow.up")
                VStack(alignment: .leading){
                    Text("Upload College Result")
                    Button{
                        
                    }label: {
                        Text("UPLOAD FILE")
                            .foregroundColor(.black)
                    }.buttonStyle(.bordered)
                }
                
                Spacer()
            }
            
            
            HStack(spacing: 20){
                Image(systemName: "book")
                VStack(alignment: .leading){
                    Text("School Name")
                    Text("_______________________")
                        .foregroundColor(uiColor.system)
                }
                
                Spacer()
            }
            
            HStack(spacing: 20){
                Image(systemName: "trophy")
                VStack(alignment: .leading){
                    Text("Marks in XII (in %)")
                    Text("_______________________")
                        .foregroundColor(uiColor.system)
                }
                
                Spacer()
            }
            HStack(spacing: 20){
                Image(systemName: "square.and.pencil")
                VStack(alignment: .leading){
                    Text("Upload XII Result")
                    Button{
                        
                    }label: {
                        Text("UPLOAD FILE")
                            .foregroundColor(.black)
                    }.buttonStyle(.bordered)
                }
                
                Spacer()
            }
            HStack(spacing: 20){
                Image(systemName: "trophy")
                VStack(alignment: .leading){
                    Text("Marks in X (in %)")
                    Text("_______________________")
                        .foregroundColor(uiColor.system)
                }
                
                Spacer()
            }
            HStack(spacing: 20){
                Image(systemName: "square.and.arrow.up")
                VStack(alignment: .leading){
                    Text("Upload X Result")
                    Button{
                        
                    }label: {
                        Text("UPLOAD FILE")
                            .foregroundColor(.black)
                    }.buttonStyle(.bordered)
                }
                
                Spacer()
            }
           
            
        }.padding()
            .font(.caption)
    }
}

