import SwiftUI
struct FilterBottomSheet: View {
    
    @State var live : Bool = false
    @State var note : Bool = false
    @State var test : Bool = false
    @State var record : Bool = false
    
    var body: some View {
        VStack(alignment : .leading , spacing:20) {
            
            Text(uiString.FilterTitle)
                .font(.system(size: 25))
                .bold()
            Divider()
                .frame(height: 1)
                .background(uiColor.lightGrayText)
            
            VStack(alignment: .leading){
                Button{
                    check(button: "live")
                }label:{
                    HStack(spacing: 15){
                        Image(systemName: live ? "checkmark.square.fill" : "square")
                        Text(uiString.FilterLive)
                    }.font(.system(size: 25))
                }
                
                Divider().frame(height: 1)
                    .background(uiColor.lightGrayText)
                Button{
                    check(button: "note")
                }label:{
                    HStack(spacing: 15){
                        Image(systemName: note ? "checkmark.square.fill" : "square")
                        Text(uiString.FilterNoteBook)
                    }.font(.system(size: 25))
                }
                Divider().frame(height: 1)
                    .background(uiColor.lightGrayText)
                Button{
                    check(button: "test")
                }label:{
                    HStack(spacing: 15){
                        Image(systemName: test ? "checkmark.square.fill" : "square")
                        Text(uiString.FilterTest)
                    }.font(.system(size: 25))
                }
                Divider().frame(height: 1)
                    .background(uiColor.lightGrayText)
                Button{
                    check(button: "record")
                }label:{
                    HStack(spacing: 15){
                        Image(systemName: record ? "checkmark.square.fill" : "square")
                        Text(uiString.FilterRecord)
                    }.font(.system(size: 25))
                }
                Divider().frame(height: 1)
                    .background(uiColor.lightGrayText)
            }.foregroundColor(uiColor.black)
            
            
            HStack(spacing: 25){
                Button{
                    print("Clicked Explore")
                }label: {
                    Text("Back")
                        .bold()
                        .foregroundColor(.black)
                        .font(.system(size: 22))
                }
                    .frame(maxWidth: .infinity , minHeight: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .stroke(Color.black.opacity(0.3), lineWidth: 2)
                    )
                Button{
                    print("Clicked Buy")
                } label: {
                    Text("Filter")
                        .bold()
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                }
                    .frame(maxWidth: .infinity , minHeight: 55)
                    .background(uiColor.violetButton)
                    .cornerRadius(35)
            }
           
        }.padding()
    }
    
    func check(button : String){
        // Step 1: Reset all
            live = false
            note = false
            test = false
            record = false

            // Step 2: Activate selected
            switch button {
            case "live":
                live = true
            case "note":
                note = true
            case "test":
                test = true
            case "record":
                record = true
            default:
                break
            }
    }
}

#Preview {
    FilterBottomSheet()
}
