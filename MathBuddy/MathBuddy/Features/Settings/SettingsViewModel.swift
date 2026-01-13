import Foundation
import Combine

final class SettingsViewModel: BaseViewModel<Void> {
    
    @Published var showResetAlert: Bool = false
    @Published var showResetToast: Bool = false
    @Published var solvedTasksCount: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        Logger.log(.info, "SettingsViewModel: init")
        loadProgress()
        setupProgressObserver()
    }
    
    private func setupProgressObserver() {
        NotificationCenter.default.publisher(for: .solvedTasksDidChange)
            .sink { [weak self] notification in
                if let count = notification.userInfo?["count"] as? Int {
                    Logger.log(.info, "SettingsViewModel: получено уведомление об изменении прогресса - \(count) задач")
                    self?.solvedTasksCount = count
                }
            }
            .store(in: &cancellables)
    }
    
    func loadProgress() {
        solvedTasksCount = ProgressService.shared.getSolvedTasksCount()
        Logger.log(.info, "SettingsViewModel: текущий прогресс - \(solvedTasksCount) задач")
    }
    
    func showResetConfirmation() {
        Logger.log(.info, "SettingsViewModel: показан alert подтверждения сброса")
        showResetAlert = true
    }
    
    func resetProgress() {
        ProgressService.shared.resetProgress()
        Logger.log(.info, "SettingsViewModel: прогресс успешно сброшен")
        showResetToast = true
        Logger.log(.info, "SettingsViewModel: показан toast уведомления")
    }
    
}
