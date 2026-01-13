import SwiftUI

struct OverviewView: View {
    
    @StateObject private var viewModel = OverviewViewModel()
    @State private var showPractice: Bool = false
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Overview")
                .navigationBarTitleDisplayMode(.inline)
                .task { await viewModel.loadOverview() }
                .navigationDestination(isPresented: $showPractice) {
                    PracticeView()
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .idle:
            idleContent
            
        case .loading:
            LoadingView()
            
        case .loaded(let overview):
            overviewDetail(overview)
            
        case .error:
            if let error = viewModel.error {
                ErrorView(error: error) {
                    Task { await viewModel.loadOverview() }
                }
            }
        }
    }
    
    private var idleContent: some View {
        VStack(spacing: 24) {
            Text("Добро пожаловать в MathBuddy!")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Нажмите кнопку ниже, чтобы загрузить Формулу дня")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("Показать Формулу дня") {
                Task { await viewModel.loadOverview() }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
    
    private func overviewDetail(_ overview: OverviewData) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Формула дня")
                        .font(.headline)
                    
                    Text(overview.formulaOfTheDay.title)
                        .font(.title2)
                        .bold()
                    
                    Text(overview.formulaOfTheDay.expression)
                        .font(.title3)
                        .foregroundColor(.blue)
                    
                    Text(overview.formulaOfTheDay.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                HStack {
                    Text("Решено задач:")
                        .font(.subheadline)
                    Spacer()
                    Text("\(overview.solvedTasksCount)")
                        .bold()
                        .font(.subheadline)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Button("Перейти к практике") {
                        showPractice = true
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button("Обновить Формулу дня") {
                        Task { await viewModel.loadOverview() }
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
}
