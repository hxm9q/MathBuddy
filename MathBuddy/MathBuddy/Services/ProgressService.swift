import Foundation
import Combine

final class ProgressService {
    
    static let shared = ProgressService()
    
    private let solvedTasksKey = "solvedTasksCount"
    
    private let progressSubject = PassthroughSubject<Int, Never>()
    var progressPublisher: AnyPublisher<Int, Never> {
        progressSubject.eraseToAnyPublisher()
    }
    
    private init() {}
    
    func getSolvedTasksCount() -> Int {
        UserDefaults.standard.integer(forKey: solvedTasksKey)
    }
    
    func incrementSolvedTasks() {
        let current = getSolvedTasksCount()
        let new = current + 1
        UserDefaults.standard.set(new, forKey: solvedTasksKey)
        
        progressSubject.send(new)
        
        NotificationCenter.default.post(
            name: .solvedTasksDidChange,
            object: nil,
            userInfo: ["count": new]
        )
    }
    
    func resetProgress() {
        UserDefaults.standard.set(0, forKey: solvedTasksKey)
        progressSubject.send(0)
        NotificationCenter.default.post(
            name: .solvedTasksDidChange,
            object: nil,
            userInfo: ["count": 0]
        )
    }
    
}

extension Notification.Name {
    static let solvedTasksDidChange = Notification.Name("solvedTasksDidChange")
}
