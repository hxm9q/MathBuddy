import Foundation
import Combine

final class ProgressViewModel: BaseViewModel<ProgressData> {
    
    @Published var solvedTasksCount: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        Logger.log(.info, "ProgressViewModel: init")
        setupProgressObserver()
    }
    
    private func setupProgressObserver() {
        NotificationCenter.default.publisher(for: .solvedTasksDidChange)
            .sink { [weak self] notification in
                if let count = notification.userInfo?["count"] as? Int {
                    Logger.log(.info, "ProgressViewModel: получено уведомление об изменении прогресса - \(count) задач")
                    self?.solvedTasksCount = count
                    self?.loadProgress()
                }
            }
            .store(in: &cancellables)
        
        ProgressService.shared.progressPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                Logger.log(.info, "ProgressViewModel: получено обновление через Publisher - \(count) задач")
                self?.solvedTasksCount = count
                self?.loadProgress()
            }
            .store(in: &cancellables)
    }
    
    func loadProgress() {
        solvedTasksCount = ProgressService.shared.getSolvedTasksCount()
        Logger.log(.info, "ProgressViewModel: текущий прогресс - \(solvedTasksCount) задач")
        let data = ProgressData(solvedTasksCount: solvedTasksCount)
        viewState = .loaded(data)
    }
    
    func incrementTasks() {
        Logger.log(.info, "ProgressViewModel: запрос на увеличение счетчика задач")
        ProgressService.shared.incrementSolvedTasks()
    }
    
    func resetProgress() {
        Logger.log(.warning, "ProgressViewModel: сброс прогресса")
        ProgressService.shared.resetProgress()
        Logger.log(.warning, "ProgressViewModel: прогресс успешно сброшен")
    }
    
}
