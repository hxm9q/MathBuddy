import SwiftUI

struct ProgressViewTab: View {
    
    @StateObject private var viewModel = ProgressViewModel()
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Progress")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    viewModel.loadProgress()
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .idle:
            Text("Нет данных")
                .foregroundColor(.secondary)
                .padding()
            
        case .loading:
            LoadingView()
            
        case .loaded(let data):
            VStack(spacing: 24) {
                Text("Решено задач:")
                    .font(.title2)
                Text("\(data.solvedTasksCount)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.green)
                
                Text("История и графики будут здесь")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(role: .destructive) {
                    viewModel.resetProgress()
                } label: {
                    Text("Сбросить прогресс")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
            }
            .padding()
            
        case .error(let error):
            ErrorView(error: error) {
                viewModel.loadProgress()
            }
        }
    }
    
}
