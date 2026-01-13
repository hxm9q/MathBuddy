import Foundation

final class ReferenceViewModel: BaseViewModel<[ReferenceItem]> {
    
    func loadReference() async {
        viewState = .loading
        
        do {
            let formulas = try await MathFormulaService.shared.loadFormulas()
            Logger.log(.info, "ReferenceViewModel: загружено \(formulas.count) формул")
            
            let items = formulas.map { formula in
                ReferenceItem(
                    title: formula.title,
                    expression: formula.expression,
                    description: formula.description,
                    type: "\(formula.type)"
                )
            }
            
            viewState = .loaded(items)
        } catch {
            Logger.log(.info, "ReferenceViewModel: ошибка загрузки")
            handleError(error)
        }
    }
    
}
