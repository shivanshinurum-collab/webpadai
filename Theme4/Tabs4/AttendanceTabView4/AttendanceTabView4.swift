import SwiftUI

struct AttendanceTabView4: View {
    
    // MARK: - Calendar Control
    @State private var currentDate = Date()
    private let calendar = Calendar.current
    
    // MARK: - Attendance Data (Stored Month Wise)
    @State private var presentDays: [String: Set<Int>] = [:]
    @State private var absentDays: [String: Set<Int>] = [:]
    @State private var holidayDays: [String: Set<Int>] = [:]
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                
                // MARK: - Header
                HStack {
                    Button {
                        changeMonth(by: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    
                    Spacer()
                    
                    Text(monthYearString())
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        changeMonth(by: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding(.horizontal)
                
                
                // MARK: - Weekday Titles
                let weekDays = calendar.shortWeekdaySymbols
                HStack {
                    ForEach(weekDays, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                            .font(.caption)
                    }
                }
                
                
                // MARK: - Calendar Grid
                let days = daysInMonth()
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(days, id: \.self) { day in
                        if day == 0 {
                            Text("")
                                .frame(height: 40)
                        } else {
                            dayCell(day: day)
                        }
                    }
                }
                .padding(.horizontal)
                
                
                // MARK: - Monthly Summary
                VStack(spacing: 15) {
                    
                    Text("Monthly Summary")
                        .font(.headline)
                    
                    HStack(spacing: 15) {
                        
                        summaryBox(
                            title: "Present",
                            count: currentPresent().count,
                            color: .green
                        )
                        
                        summaryBox(
                            title: "Absent",
                            count: currentAbsent().count,
                            color: .red
                        )
                        
                        summaryBox(
                            title: "Holidays",
                            count: currentHoliday().count,
                            color: .orange
                        )
                    }
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 50)
                    // MARK: - Attendance Progress
                    ZStack {
                        
                        SemiCircle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 15)
                        
                        SemiCircle()
                            .trim(from: 0, to: attendancePercentage())
                            .stroke(Color.blue,
                                    style: StrokeStyle(lineWidth: 15,
                                                       lineCap: .round))
                        
                        VStack {
                            Text("\(Int(attendancePercentage() * 100))%")
                                .font(.title)
                                .bold()
                            
                            Text("Attendance")
                                .font(.caption)
                        }
                    }
                    .frame(height: 150)
                }
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(20)
                
                Spacer()
            }
            .padding(.top)
        }.scrollIndicators(.hidden)
        .onAppear {
            setupDefaultHoliday()
        }
    }
    
    
    // MARK: - Month Key
    private func monthKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-yyyy"
        return formatter.string(from: currentDate)
    }
    
    
    // MARK: - Change Month
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month,
                                        value: value,
                                        to: currentDate) {
            currentDate = newMonth
        }
    }
    
    
    // MARK: - Month Title
    private func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }
    
    
    // MARK: - Generate Days
    private func daysInMonth() -> [Int] {
        
        guard let range = calendar.range(of: .day,
                                         in: .month,
                                         for: currentDate),
              let firstDay = calendar.date(
                from: calendar.dateComponents([.year, .month],
                                              from: currentDate))
        else { return [] }
        
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        
        var days: [Int] = Array(repeating: 0,
                                count: firstWeekday - 1)
        days += range.map { $0 }
        
        return days
    }
    
    
    // MARK: - Day Cell
    private func dayCell(day: Int) -> some View {
        Button {
            //handleTap(day: day)
        } label: {
            Text("\(day)")
                .frame(width: 40, height: 40)
                .background(.gray.opacity(0.2))
                //.background(backgroundColor(day: day))
                .foregroundColor(.black)
                .bold()
                .cornerRadius(8)
        }
    }
    
    
    // MARK: - Handle Tap
    private func handleTap(day: Int) {
        
        let key = monthKey()
        
        if holidayDays[key]?.contains(day) == true {
            return
        }
        
        if presentDays[key]?.contains(day) == true {
            presentDays[key]?.remove(day)
            absentDays[key, default: []].insert(day)
        } else if absentDays[key]?.contains(day) == true {
            absentDays[key]?.remove(day)
        } else {
            presentDays[key, default: []].insert(day)
        }
    }
    
    
    // MARK: - Colors
    private func backgroundColor(day: Int) -> Color {
        if currentHoliday().contains(day) {
            return .orange.opacity(0.5)
        } else if currentPresent().contains(day) {
            return .green.opacity(0.5)
        } else if currentAbsent().contains(day) {
            return .red.opacity(0.5)
        } else {
            return .gray.opacity(0.2)
        }
    }
    
    
    // MARK: - Current Month Data
    private func currentPresent() -> Set<Int> {
        presentDays[monthKey()] ?? []
    }
    
    private func currentAbsent() -> Set<Int> {
        absentDays[monthKey()] ?? []
    }
    
    private func currentHoliday() -> Set<Int> {
        holidayDays[monthKey()] ?? []
    }
    
    
    // MARK: - Percentage
    private func attendancePercentage() -> CGFloat {
        let total = currentPresent().count + currentAbsent().count
        if total == 0 { return 0 }
        return CGFloat(currentPresent().count) / CGFloat(total)
    }
    
    
    // MARK: - Default Holiday Setup
    private func setupDefaultHoliday() {
        let key = monthKey()
        if holidayDays[key] == nil {
            holidayDays[key] = [6, 14, 26] // Example
        }
    }
}


// MARK: - Summary Box
private func summaryBox(title: String,
                        count: Int,
                        color: Color) -> some View {
    VStack {
        Text("\(count)")
            .font(.title2)
            .bold()
            .foregroundColor(color)
        
        Text(title)
            .font(.caption)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(Color.white)
    .cornerRadius(12)
}


// MARK: - Semi Circle Shape
struct SemiCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.maxY),
            radius: rect.width / 2,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        return path
    }
}


#Preview {
    AttendanceTabView4()
}
