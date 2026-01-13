import Foundation
import Combine

final class OverviewViewModel: BaseViewModel<OverviewData> {
    
    @Published var solvedTasksCount: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        Logger.log(.info, "OverviewViewModel init")
        setupProgressObserver()
    }
    
    private func setupProgressObserver() {
        NotificationCenter.default.publisher(for: .solvedTasksDidChange)
            .sink { [weak self] notification in
                if let count = notification.userInfo?["count"] as? Int {
                    Logger.log(.info, "OverviewViewModel: получено уведомление об изменении прогресса - \(count) задач")
                    self?.solvedTasksCount = count
                    Task { await self?.loadOverview() }
                }
            }
            .store(in: &cancellables)
    }
    
    func loadOverview() async {
        Logger.log(.info, "OverviewViewModel: начинается загрузка обзора")
        viewState = .loading
        
        do {
            let formulas = try await MathFormulaService.shared.loadFormulas()
            Logger.log(.info, "OverviewViewModel: загружено \(formulas.count) формул")
            guard !formulas.isEmpty else {
                Logger.log(.error, "OverviewViewModel: список формул пуст")
                throw AppError(message: "Нет доступных формул")
            }
            
            let randomFormula = formulas.randomElement()!
            Logger.log(.info, "OverviewViewModel: выбрана формула дня - '\(randomFormula.title)'")
            
            let solvedCount = ProgressService.shared.getSolvedTasksCount()
            solvedTasksCount = solvedCount
            Logger.log(.info, "OverviewViewModel: текущий прогресс - \(solvedCount) задач")
            
            let overview = OverviewData(
                formulaOfTheDay: randomFormula,
                solvedTasksCount: solvedCount
            )
            
            viewState = .loaded(overview)
            Logger.log(.info, "OverviewViewModel: обзор успешно загружен")
            
        } catch {
            Logger.log(.error, "OverviewViewModel: ошибка загрузки обзора - \(error.localizedDescription)")
            handleError(error)
        }
    }
    
}
