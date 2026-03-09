
import Foundation

// MARK: - Root Response
struct AttendanceResponse: Codable {
    let attendance: [Attendance]?
    let status: String
    let msg: String
}

// MARK: - Attendance Model
struct Attendance: Codable ,Hashable{
    let studentId: String
    let addedId: String
    let date: String
    let time: String
}
