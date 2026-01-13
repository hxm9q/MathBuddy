import Foundation

enum MathFormulaType {
    case arithmetic
    case geometry
    case algebra
}

struct MathVariable: Identifiable {
    let id = UUID()
    let symbol: String
    let name: String
    let unit: String?
}

struct MathFormula: Identifiable {
    let id: UUID
    let title: String
    let expression: String
    let description: String
    let type: MathFormulaType
    let variables: [MathVariable]
}

struct CalculationResult: Identifiable {
    let id = UUID()
    let formulaId: UUID
    let value: Double
    let date: Date
}

struct OverviewData {
    let formulaOfTheDay: MathFormula
    let solvedTasksCount: Int
}

struct ProgressData {
    var solvedTasksCount: Int
}

struct ReferenceItem: Identifiable {
    let id = UUID()
    let title: String
    let expression: String
    let description: String
    let type: String
}
