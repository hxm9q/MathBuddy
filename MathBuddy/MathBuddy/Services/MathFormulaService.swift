import Foundation

final class MathFormulaService {
    
    static let shared = MathFormulaService()
    
    func loadFormulas() async throws -> [MathFormula] {
        try await Task.sleep(nanoseconds: 300_000_000)
        
        return [
            rectangleAreaFormula(),
            rectanglePerimeterFormula(),
            arithmeticMeanFormula()
        ]
    }
    
    private func rectangleAreaFormula() -> MathFormula {
        MathFormula(
            id: UUID(),
            title: "Площадь прямоугольника",
            expression: "S = a × b",
            description: "Площадь прямоугольника равна произведению его сторон.",
            type: .geometry,
            variables: [
                MathVariable(symbol: "a", name: "Сторона A", unit: nil),
                MathVariable(symbol: "b", name: "Сторона B", unit: nil)
            ]
        )
    }
    
    private func rectanglePerimeterFormula() -> MathFormula {
        MathFormula(
            id: UUID(),
            title: "Периметр прямоугольника",
            expression: "P = 2 × (a + b)",
            description: "Сумма длин всех сторон прямоугольника.",
            type: .geometry,
            variables: [
                MathVariable(symbol: "a", name: "Сторона A", unit: nil),
                MathVariable(symbol: "b", name: "Сторона B", unit: nil)
            ]
        )
    }
    
    private func arithmeticMeanFormula() -> MathFormula {
        MathFormula(
            id: UUID(),
            title: "Среднее арифметическое",
            expression: "x̄ = (a + b) / 2",
            description: "Среднее значение двух чисел.",
            type: .arithmetic,
            variables: [
                MathVariable(symbol: "a", name: "Число A", unit: nil),
                MathVariable(symbol: "b", name: "Число B", unit: nil)
            ]
        )
    }

}
