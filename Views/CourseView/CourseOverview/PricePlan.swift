import SwiftUI

struct PricePlanView: View {

    @State private var selectedIndex: Int = 0
    
    @State static var selectedPlan: MultiPrice? = nil
    
    let multiPrice: [MultiPrice]
    
    private var Heading: String {
        let plan = multiPrice[selectedIndex]

        let value = plan.duration_value ?? ""
        let type  = plan.duration_type ?? ""

        return "\(value) \(type)"
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "clock")
                    .font(.system(size: 22))

                VStack(alignment: .leading) {
                    Text("\(Heading) validity")
                        .font(.title2.bold())
                    Text("You will get the course for \(Heading)")
                }
                Spacer()
            }.foregroundColor(.black)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity,minHeight: 0)
            
            // Price Plans
            ForEach(multiPrice.indices, id: \.self) { index in
                let plan = multiPrice[index]

                Button {
                    PricePlanView.selectedPlan = plan
                    selectedIndex = index
                    print("Selected Index:", index)
                } label: {
                    HStack(spacing: 12) {

                        Image(systemName: selectedIndex == index
                              ? "largecircle.fill.circle"
                              : "circle")
                            .foregroundColor(
                                selectedIndex == index
                                ? uiColor.ButtonBlue
                                : .gray
                            )

                        Text("\(plan.duration_value ?? "") \(plan.duration_type ?? "") validity")
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: 160, alignment: .leading)
                            .foregroundColor(.black)

                        Rectangle()
                            .frame(width: 0.5, height: 25)
                            .foregroundColor(.gray.opacity(0.4))

                        Text("₹\(plan.course_price ?? "")")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.black)

                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                selectedIndex == index
                                ? uiColor.ButtonBlue
                                : Color.gray.opacity(0.3),
                                lineWidth: 1.4
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }.onAppear{
            selectedIndex = 0
        }
        .padding()
    }
}




