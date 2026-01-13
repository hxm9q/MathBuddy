import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Прогресс")) {
                    HStack {
                        Text("Решено задач")
                            .font(.body)
                        
                        Spacer()
                        
                        Text("\(viewModel.solvedTasksCount)")
                            .font(.body)
                            .bold()
                            .foregroundStyle(.green)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        viewModel.showResetConfirmation()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Сбросить прогресс")
                        }
                    }
                } footer: {
                    Text("Это действие удалит всю статистику решенных задач")
                        .foregroundStyle(.secondary)
                }
                
                Section(header: Text("О приложении")) {
                    HStack {
                        Text("Версия")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Всего формул")
                        Spacer()
                        Text("3")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Сбросить прогресс?", isPresented: $viewModel.showResetAlert) {
                Button("Отмена", role: .cancel) { }
                Button("Сбросить", role: .destructive) {
                    withAnimation {
                        viewModel.resetProgress()
                    }
                }
            } message: {
                Text("Вся статистика решенных задач будет удалена. Это действие нельзя отменить.")
            }
        }
        .overlay(alignment: .bottom) {
            if viewModel.showResetToast {
                Text("Прогресс сброшен")
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.85))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom, 100)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
}
