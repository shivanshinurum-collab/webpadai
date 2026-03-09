import SwiftUI
struct editBasicInfo5 : View {
    @Binding var path  : NavigationPath
    
    @State var name = "Test"
    @State var MobileNumber = "1234567890"
    @State var email = "abcdabcd@Gmail.com"
    @State var about = ""
    @State var rollNumber = ""
    @State private var selectedDate: Date = Date()
    @State private var showDatePicker = false
    
    var body: some View{
        HStack(spacing: 25){
            Button{
                path.removeLast()
            }label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.backSize))
            }
            
            Text("Edit Basic Information")
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
                HStack(){
                    Image(systemName: "person")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Name")
                        TextField("" , text: $name)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.black.opacity(0.12))
                            )
                    }
                }
                
                HStack{
                    Image(systemName: "number")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Mobile Number")
                        TextField("" , text: $MobileNumber)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.black.opacity(0.12))
                            )
                    }
                }
                
                
                HStack{
                    Image(systemName: "envelope")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Email")
                        TextField("" , text: $email)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.black.opacity(0.12))
                            )
                    }
                }
                
                
                HStack{
                    Image(systemName: "i.circle")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("About")
                        TextField("" , text: $about)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.2) , lineWidth: 1)
                            )
                    }
                }
                
                HStack{
                    Image(systemName: "number")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Roll Number")
                        TextField("" , text: $rollNumber)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.2) , lineWidth: 1)
                            )
                    }
                }
                
                HStack{
                    Image(systemName: "calendar")
                        .font(.title3)
                    VStack(alignment: .leading){
                        Text("Date of Joining")
                        
                        Button{
                            showDatePicker = true
                        }label: {
                            HStack{
                                Text(formatDate(selectedDate))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: "calendar")
                                    .font(.title3)
                                    .foregroundColor(uiColor.ButtonBlue)
                            }
                        }.buttonStyle(.plain)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.2) , lineWidth: 1)
                            )
                    }
                }
                
                
            }.padding()
            // Date Picker Sheet
                .sheet(isPresented: $showDatePicker) {
                    VStack {
                        
                        DatePicker(
                            "Select Date",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .padding()
                        
                        Button("Done") {
                            showDatePicker = false
                        }
                        .padding()
                    }
                    .presentationDetents([.medium])
                }
                .navigationBarBackButtonHidden(true)
        }
    }
    // Format Date
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
}

