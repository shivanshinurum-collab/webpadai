import SwiftUI
struct editEducationInfo5: View {
    
    @Binding var path  :NavigationPath
    
    @State var collegeName = ""
    @State var collegeMarks = ""
    @State var schoolName = ""
    @State var XIImarks = ""
    @State var Xmarks = ""
    
    var body: some View{
        HStack(spacing: 25){
            Button{
                path.removeLast()
            }label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.backSize))
            }
            
            Text("Edit Educational Details")
                .font(.system(size: uiString.titleSize))
                .foregroundColor(.white)
            
            Spacer()
            
            Button{
                
            }label: {
                Text("Save")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.titleSize))
            }
            
        }.padding()
            .background(uiColor.ButtonBlue)
        
        ScrollView{
            VStack(alignment: .leading , spacing: 18){
                
                HStack{
                    Image(systemName: "graduationcap")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("College / University Name")
                        TextField("" , text: $collegeName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.2) , lineWidth: 1)
                            )
                    }
                }
                
                HStack{
                    Image(systemName: "trophy")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Marks in College (in %)")
                        TextField("" , text: $collegeMarks)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.2) , lineWidth: 1)
                            )
                    }
                }
                HStack{
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Upload College Result")
                        
                        Button{
                            
                        }label: {
                            Text("UPLOAD")
                                .foregroundColor(.black)
                                .padding(.horizontal)
                                .padding(5)
                        }.buttonStyle(.bordered)
                    }
                }
               
                
                HStack{
                    Image(systemName: "book")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("School Name")
                        TextField("" , text: $schoolName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.2) , lineWidth: 1)
                            )
                    }
                }
                
                HStack{
                    Image(systemName: "trophy")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Marks in XII (in %)")
                        TextField("" , text: $XIImarks)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.2) , lineWidth: 1)
                            )
                    }
                }
                
                HStack{
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Upload XII Result")
                        
                        Button{
                            
                        }label: {
                            Text("UPLOAD")
                                .foregroundColor(.black)
                                .padding(.horizontal)
                                .padding(5)
                        }.buttonStyle(.bordered)
                    }
                }
                
                HStack{
                    Image(systemName: "trophy")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Marks in X (in %)")
                        TextField("" , text: $Xmarks)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.2) , lineWidth: 1)
                            )
                    }
                }
                
                HStack{
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Upload X Result")
                        
                        Button{
                            
                        }label: {
                            Text("UPLOAD")
                                .foregroundColor(.black)
                                .padding(.horizontal)
                                .padding(5)
                        }.buttonStyle(.bordered)
                        
                    }
                }
            }.padding()
            
        }
        .navigationBarBackButtonHidden(true)
    }
        
}

