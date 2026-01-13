import SwiftUI

struct PracticeView: View {
    
    @StateObject private var viewModel = PracticeViewModel()
    @FocusState private var focusedField: String?
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Practice")
                .navigationBarTitleDisplayMode(.inline)
                .task { await viewModel.loadRandomFormula() }
                .onTapGesture {
                    focusedField = nil
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
            
        case .loaded:
            if let formula = viewModel.selectedFormula {
                practiceContent(formula)
            } else {
                idleContent
            }
            
        case .error:
            if let error = viewModel.error {
                ErrorView(error: error) {
                    Task { await viewModel.loadRandomFormula() }
                }
            }
        }
    }
    
    private var idleContent: some View {
        VStack(spacing: 24) {
            Image(systemName: "function")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Загрузите формулу для практики")
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Button("Загрузить формулу") {
                Task { await viewModel.loadRandomFormula() }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
    
    private func practiceContent(_ formula: MathFormula) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                formulaSection(formula)
                
                Divider()
                
                variablesSection(formula)
                
                if let result = viewModel.result {
                    resultSection(String(result))
                }
                
                actionsSection()
                
                Spacer(minLength: 20)
            }
            .padding()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = nil
        }
    }
    
    private func formulaSection(_ formula: MathFormula) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Формула")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(formula.title)
                .font(.title2)
                .bold()
            
            Text(formula.expression)
                .font(.title3)
                .foregroundColor(.blue)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, -8)
                .padding(.horizontal, 8)
            
            Text(formula.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private func variablesSection(_ formula: MathFormula) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Введите значения переменных")
                .font(.headline)
            
            ForEach(formula.variables) { variable in
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(variable.name) (\(variable.symbol))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("Введите значение", text: Binding(
                        get: { viewModel.variableValues[variable.symbol] ?? "" },
                        set: { viewModel.variableValues[variable.symbol] = $0 }
                    ))
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: variable.symbol)
                }
            }
        }
    }
    
    private func resultSection(_ result: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Результат")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                
                Text(result)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.green)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green.opacity(0.1))
            )
        }
    }
    
    private func actionsSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                focusedField = nil
                viewModel.calculateResult()
            }) {
                HStack {
                    Image(systemName: "equal.circle.fill")
                    Text("Вычислить")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            Button(action: {
                focusedField = nil
                Task { await viewModel.loadRandomFormula() }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Новая формула")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }
    
}
