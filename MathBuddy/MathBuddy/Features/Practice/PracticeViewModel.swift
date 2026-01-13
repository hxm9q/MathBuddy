import Foundation
import Combine

final class PracticeViewModel: BaseViewModel<MathFormula> {
    
    @Published var selectedFormula: MathFormula? = nil
    @Published var variableValues: [String: String] = [:]
    @Published var result: Double? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        Logger.log(.info, "PracticeViewModel init")
        setupProgressObserver()
    }
    
    private func setupProgressObserver() {
        ProgressService.shared.progressPublisher
            .sink { [weak self] count in
                Logger.log(.info, "PracticeViewModel: получено обновление прогресса - \(count) задач")
            }
            .store(in: &cancellables)
    }
    
    func loadRandomFormula() async {
        Logger.log(.info, "PracticeViewModel: начинается загрузка случайной формулы")
        viewState = .loading
        
        do {
            let formulas = try await MathFormulaService.shared.loadFormulas()
            Logger.log(.info, "PracticeViewModel: загружено \(formulas.count) формул")
            guard let random = formulas.randomElement() else {
                Logger.log(.error, "PracticeViewModel: нет доступных формул")
                throw AppError(message: "Нет доступных формул")
            }
            selectedFormula = random
            Logger.log(.info, "PracticeViewModel: выбрана формула '\(random.title)'")
            
            variableValues = [:]
            random.variables.forEach { variableValues[$0.symbol] = "" }
            result = nil
            
            viewState = .loaded(random)
            
        } catch {
            Logger.log(.error, "PracticeViewModel: ошибка загрузки формулы - \(error.localizedDescription)")
            handleError(error)
        }
    }
    
    func calculateResult() {
        guard let formula = selectedFormula else { return }
        
        var values: [Double] = []
        for variable in formula.variables {
            guard let text = variableValues[variable.symbol],
                  let number = Double(text.replacingOccurrences(of: ",", with: ".")) else {
                handleError(AppError(message: "Введите корректные значения для всех переменных"))
                return
            }
            values.append(number)
            Logger.log(.info, "PracticeViewModel: переменная \(variable.symbol) = \(number)")
        }
        
        var computed: Double = 0
        
        switch formula.expression {
        case "S = a × b":
            computed = values[0] * values[1]
        case "P = 2 × (a + b)":
            computed = 2 * (values[0] + values[1])
        case "x̄ = (a + b) / 2":
            computed = (values[0] + values[1]) / 2
        default:
            handleError(AppError(message: "Формула пока не поддерживается"))
            return
        }
        
        result = computed
        Logger.log(.info, "PracticeViewModel: результат вычисления = \(computed)")
        ProgressService.shared.incrementSolvedTasks()
        Logger.log(.info, "PracticeViewModel: счетчик задач увеличен")
    }
    
}
