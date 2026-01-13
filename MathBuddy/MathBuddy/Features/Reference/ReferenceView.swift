import SwiftUI

struct ReferenceView: View {
    
    @StateObject private var viewModel = ReferenceViewModel()
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Reference")
                .navigationBarTitleDisplayMode(.inline)
                .task { await viewModel.loadReference() }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .idle:
            Text("Загрузка справочных материалов...")
                .foregroundColor(.secondary)
                .padding()
            
        case .loading:
            LoadingView()
            
        case .loaded(let items):
            List(items) { item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                    Text(item.expression)
                        .foregroundColor(.blue)
                        .font(.subheadline)
                    Text(item.description)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
            
        case .error(let error):
            ErrorView(error: error) {
                Task { await viewModel.loadReference() }
            }
        }
    }
    
}
