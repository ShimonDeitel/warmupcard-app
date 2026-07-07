import Foundation

struct WarmupLog: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var routineName: String
    var completedSteps: Int
    var totalSteps: Int
    var notes: String

    init(id: UUID = UUID(), date: Date = Date(), routineName: String = "", completedSteps: Int = 0, totalSteps: Int = 0, notes: String = "") {
        self.id = id
        self.date = date
        self.routineName = routineName
        self.completedSteps = completedSteps
        self.totalSteps = totalSteps
        self.notes = notes
    }
}

struct AppSettings: Codable, Equatable {
    var remindersEnabled: Bool = true
    var metricUnits: Bool = false
    var includeInStreak: Bool = true
}
