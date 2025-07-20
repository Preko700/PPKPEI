import SwiftUI

struct AddLoanView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let person: Person
    
    @State private var initialAmount = ""
    @State private var interestRate = ""
    @State private var dueDate = Date().addingTimeInterval(30 * 24 * 60 * 60) // Default 30 days
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalles del Préstamo")) {
                    HStack {
                        Text("$")
                        TextField("Monto inicial", text: $initialAmount)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        TextField("Porcentaje de interés", text: $interestRate)
                            .keyboardType(.decimalPad)
                        Text("%")
                    }
                    
                    DatePicker("Fecha de vencimiento", selection: $dueDate, displayedComponents: .date)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button("Crear Préstamo") {
                            createLoan()
                        }
                        .disabled(initialAmount.isEmpty || interestRate.isEmpty)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Nuevo Préstamo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func createLoan() {
        guard let initialAmountValue = Double(initialAmount),
              let interestRateValue = Double(interestRate) else {
            return
        }
        
        withAnimation {
            let newLoan = Loan(context: viewContext)
            newLoan.id = UUID()
            newLoan.initialAmount = initialAmountValue
            newLoan.interestRate = interestRateValue
            newLoan.startDate = Date()
            newLoan.dueDate = dueDate
            newLoan.isActive = true
            newLoan.customDebtAmount = 0.0
            newLoan.person = person
            
            // Schedule notification for due date
            NotificationManager.shared.schedulePaymentReminder(for: newLoan)
            
            do {
                try viewContext.save()
                dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    AddLoanView(person: PersistenceController.preview.container.viewContext.registeredObjects.compactMap { $0 as? Person }.first!)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}