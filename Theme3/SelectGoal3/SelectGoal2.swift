import SwiftUI
struct SelectGoal2 : View {
    
    @Binding var path : NavigationPath
    
    @State var course : [CourseCategory2Model] = []
    @State var selected = UserDefaults.standard.string(forKey: "goal") ?? ""
    
    @State private var showChangeAlert = false
    
    @State var batch_id = UserDefaults.standard.string(forKey: "batch_id") ?? ""
    
    
    var body : some View {
        HStack {
            
            Spacer()
            
            Text("Select Course")
                .foregroundColor(.white)
                .font(.system(size: uiString.titleSize).bold())
                .padding(.bottom)
            
            Spacer()
            
        }
        .padding(.horizontal)
        .background(uiColor.ButtonBlue)
        
        VStack(alignment: .leading){
           
            ScrollView{
                ForEach(course ){ item in
                    VStack(alignment: .leading){
                        
                        Text(item.categoryName)
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                            .bold()
                        
                        ForEach(item.batchData){ i in
                            Button{
                                selected = i.batchName
                                batch_id = i.id
                            }label: {
                                
                                HStack{
                                    if(selected == i.batchName ){
                                        Image(systemName: "record.circle")
                                            .font(.system(size: 20))
                                            .foregroundColor(uiColor.ButtonBlue)
                                        Text(i.batchName)
                                            .foregroundColor(uiColor.black)
                                            .font(.system(size: 18))
                                    }else{
                                        Image(systemName: "circle")
                                            .font(.system(size: 20))
                                            .foregroundColor(uiColor.gray)
                                        Text(i.batchName)
                                            .foregroundColor(uiColor.black)
                                            .font(.system(size: 18))
                                    }
                                    Spacer()
                                }
                                
                                .padding(.vertical,5)
                                
                                
                            }
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(uiColor.lightGrayText)
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(uiColor.lightGrayText)
                        
                    }
                }
            }
            
            Button{
                let name = UserDefaults.standard.string(forKey: "goal") ?? ""
                let id = UserDefaults.standard.string(forKey: "batch_id") ?? ""
                
                if selected == name && batch_id == id && selected != ""{
                    path.append(Route.HomeTabView2)
                } else if name == "" && id == "" && selected != ""{
                    UserDefaults.standard.set(batch_id, forKey: "batch_id")
                    UserDefaults.standard.set(selected, forKey: "goal")
                    path.append(Route.HomeTabView2)
                } else if selected == ""{
                    
                }
                else{
                    showChangeAlert = true
                }

            }label: {
                Text("Done")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity , minHeight: 50)
            }.background(uiColor.ButtonBlue)
                .cornerRadius(15)
            
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            fetchGoal()
        }
        .alert("Are you sure you want to change your course?",
               isPresented: $showChangeAlert) {
            
            Button("No, keep current course", role: .cancel) {
                path.removeLast()
            }
            
            Button("Yes, Change", role: .destructive) {
                UserDefaults.standard.set(batch_id, forKey: "batch_id")
                UserDefaults.standard.set(selected, forKey: "goal")
                path.append(Route.HomeTabView2)
            }
            
        } message: {
            Text("You will lose your saved videos and progress on paused lessons.")
        }
        
    }
    
    func fetchGoal() {
        guard let url = URL(string: apiURL.selectGoal2 ) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(SelectCourse2Model.self, from: data)
                print("Select Goal API = \(response)")
                DispatchQueue.main.async {
                    self.course = response.courseData ?? []
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
    
}
