import Foundation

final class MathCalculationService {
    
    static let shared = MathCalculationService()
    
    func calculate(
        formula: MathFormula,
        values: [String: Double]
    ) throws -> Double {
        
        switch formula.expression {
        case "S = a × b":
            return try rectangleArea(values)
            
        case "P = 2 × (a + b)":
            return try rectanglePerimeter(values)
            
        case "x̄ = (a + b) / 2":
            return try arithmeticMean(values)
            
        default:
            throw AppError(message: "Формула не поддерживается")
        }
    }
    
    private func rectangleArea(_ values: [String: Double]) throws -> Double {
        guard
            let a = values["a"],
            let b = values["b"]
        else {
            throw AppError(message: "Введите значения сторон")
        }
        
        return a * b
    }
    
    private func rectanglePerimeter(_ values: [String: Double]) throws -> Double {
        guard
            let a = values["a"],
            let b = values["b"]
        else {
            throw AppError(message: "Введите значения сторон")
        }
        
        return 2 * (a + b)
    }
    
    private func arithmeticMean(_ values: [String: Double]) throws -> Double {
        guard
            let a = values["a"],
            let b = values["b"]
        else {
            throw AppError(message: "Введите оба числа")
        }
        
        return (a + b) / 2
    }
    
}

