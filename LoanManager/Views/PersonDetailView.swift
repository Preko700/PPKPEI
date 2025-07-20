import SwiftUI
import CoreData

struct PersonDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let person: Person
    
    @State private var showingAddLoan = false
    @State private var showingAddPayment = false
    @State private var selectedLoan: Loan?
    @State private var editingDebt = false
    @State private var editedDebtAmount = ""
    @State private var editingLoan: Loan?
    
    var body: some View {
        List {
            // Person Summary Section
            Section(header: Text("Resumen")) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Total adeudado:")
                            .font(.headline)
                        Spacer()
                        Text("$\(person.totalDebt, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(person.totalDebt > 0 ? .red : .green)
                    }
                    
                    HStack {
                        Text("Préstamos activos:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(person.activeLoans.count)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            
            // Active Loans Section
            if !person.activeLoans.isEmpty {
                Section(header: Text("Préstamos Activos")) {
                    ForEach(person.activeLoans) { loan in
                        LoanRowView(loan: loan, onEdit: { editLoan in
                            editingLoan = editLoan
                            editedDebtAmount = String(editLoan.currentDebt)
                            editingDebt = true
                        }, onAddPayment: { paymentLoan in
                            selectedLoan = paymentLoan
                            showingAddPayment = true
                        })
                    }
                }
            }
            
            // All Loans History Section
            if !person.loansArray.isEmpty {
                Section(header: Text("Historial de Préstamos")) {
                    ForEach(person.loansArray) { loan in
                        LoanHistoryRowView(loan: loan)
                    }
                }
            }
        }
        .navigationTitle(person.wrappedName)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddLoan = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddLoan) {
            AddLoanView(person: person)
        }
        .sheet(isPresented: $showingAddPayment) {
            if let loan = selectedLoan {
                AddPaymentView(loan: loan)
            }
        }
        .alert("Editar Deuda", isPresented: $editingDebt) {
            TextField("Monto", text: $editedDebtAmount)
                .keyboardType(.decimalPad)
            
            Button("Cancelar", role: .cancel) {
                editingDebt = false
                editingLoan = nil
            }
            
            Button("Guardar") {
                if let loan = editingLoan, let amount = Double(editedDebtAmount) {
                    loan.customDebtAmount = amount
                    try? viewContext.save()
                }
                editingDebt = false
                editingLoan = nil
            }
            
            Button("Cancelar Préstamo", role: .destructive) {
                if let loan = editingLoan {
                    loan.isActive = false
                    NotificationManager.shared.cancelNotification(for: loan)
                    try? viewContext.save()
                }
                editingDebt = false
                editingLoan = nil
            }
        } message: {
            Text("Puedes editar el monto de la deuda manualmente o cancelar el préstamo.")
        }
    }
}

struct LoanRowView: View {
    let loan: Loan
    let onEdit: (Loan) -> Void
    let onAddPayment: (Loan) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("$\(loan.initialAmount, specifier: "%.2f")")
                        .font(.headline)
                    Text("Interés: \(loan.interestRate, specifier: "%.1f")%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("$\(loan.currentDebt, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(loan.isOverdue ? .red : .orange)
                    
                    if loan.isOverdue {
                        Text("Vencido (\(loan.daysOverdue) días)")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else {
                        Text("Vence: \(loan.wrappedDueDate, style: .date)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            HStack {
                Button("Agregar Pago") {
                    onAddPayment(loan)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Spacer()
                
                Button("Editar Deuda") {
                    onEdit(loan)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
            
            if !loan.paymentsArray.isEmpty {
                Text("Pagos: $\(loan.totalPayments, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
}

struct LoanHistoryRowView: View {
    let loan: Loan
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("$\(loan.initialAmount, specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                if loan.isActive {
                    Text("Activo")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .clipShape(Capsule())
                } else {
                    Text("Cancelado")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.gray)
                        .clipShape(Capsule())
                }
            }
            
            Text("Inicio: \(loan.wrappedStartDate, style: .date)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationView {
        PersonDetailView(person: PersistenceController.preview.container.viewContext.registeredObjects.compactMap { $0 as? Person }.first!)
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}