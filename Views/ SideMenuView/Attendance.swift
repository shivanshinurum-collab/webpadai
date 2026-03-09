import SwiftUI


struct AttendanceView : View {
    @Binding var path : NavigationPath
    
   @State var attendance : [Attendance] = []
    let student_id = UserDefaults.standard.string(forKey: "studentId") ?? ""
    
    @State var selectedMonth = "01"
    @State var selectedYear = "2026"

    let months = Array(1...12).map { String(format: "%02d", $0) }
    let years = ["2026","2027", "2028", "2029","2030"]
    
    
    
    var body: some View {
        VStack(){
            ZStack(alignment:.top) {
                uiColor.ButtonBlue
                    .ignoresSafeArea(edges: .top)
                    .clipShape(
                        RoundedCorner(
                            radius: 30,
                            corners: [.bottomLeft, .bottomRight]
                        )
                    )
                    .frame(height: 160)
                    .ignoresSafeArea()
                Color.clear.frame(width: 24)
                
                HStack {
                    Button {
                        path.removeLast()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(uiColor.white)
                            .font(.system(size: uiString.backSize))
                    }
                    
                    Spacer()
                    
                    Text("Attendance")
                        .foregroundColor(uiColor.white)
                        .font(.system(size: uiString.titleSize).bold())
                    
                    Spacer()
                    
                    
                }
                .padding(.horizontal)
                
                DatePickerView
                    .padding(.top,30)
                    .shadow(color: uiColor.DarkGrayText,radius: 1)
                
            }
            .frame(height: 180)
            
            
            VStack{
                HStack{
                    Text("Date")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                    Text("Time")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                    Text("Status")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                    
                }.padding()
                .foregroundColor(uiColor.white)
                .background(uiColor.ButtonBlue)
                
                
                ScrollView{
                    ForEach(attendance ,id: \.self){ date in
                        HStack{
                            HStack{
                                Text(date.date)
                                    .frame(maxWidth: .infinity)
                                Text(date.time)
                                    .frame(maxWidth: .infinity)
                                Text("Present")
                                    .frame(maxWidth: .infinity)
                                
                            }.padding()
                                .font(.headline)
                                .foregroundColor(uiColor.DarkGrayText)
                                .background(uiColor.white)
                        }
                    }
                }
            }
            .cornerRadius(15)
            .padding()
            
            Spacer()
           
        }.navigationBarBackButtonHidden(true)
            .onAppear{
                fetchData()
            }
    }
    
    
    func fetchData() {
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        
        var components = URLComponents(
            string: apiURL.getAttendance 
        )
        
        components?.queryItems = [
            URLQueryItem(name: "student_id", value: student_id),
            URLQueryItem(name: "month", value: selectedMonth),
            URLQueryItem(name: "year", value: selectedYear)
        ]
        
        guard let url = components?.url else {
            print(" Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(" API Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print(" No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(AttendanceResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.attendance = decodedResponse.attendance ?? []
                }
            } catch {
                print(" Decode Error:", error)
            }
        }.resume()
    }
    
    
    
    var DatePickerView: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Select Month And Year To Filter Results")
                .font(.system(size: 15))
                .foregroundColor(uiColor.gray)

            HStack(spacing: 12) {

                Picker("Month", selection: $selectedMonth) {
                    ForEach(months, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.white)
                .cornerRadius(6)

                Picker("Year", selection: $selectedYear) {
                    ForEach(years, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.white)
                .cornerRadius(6)

                Button {
                    fetchData()
                } label: {
                    Text("OK")
                        .foregroundColor(uiColor.white)
                        .fontWeight(.semibold)
                        .frame(width: 60, height: 40)
                        .background(uiColor.ButtonBlue)
                        .cornerRadius(6)
                }
            }.frame(width:325)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6)
        .padding(20)
    }
    
    
}


