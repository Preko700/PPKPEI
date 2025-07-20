import SwiftUI

struct AddPaymentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let loan: Loan
    
    @State private var amount = ""
    @State private var paymentDate = Date()
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información del Préstamo")) {
                    HStack {
                        Text("Deuda actual:")
                        Spacer()
                        Text("$\(loan.currentDebt, specifier: "%.2f")")
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Préstamo inicial:")
                        Spacer()
                        Text("$\(loan.initialAmount, specifier: "%.2f")")
                    }
                    
                    HStack {
                        Text("Total pagado:")
                        Spacer()
                        Text("$\(loan.totalPayments, specifier: "%.2f")")
                            .foregroundColor(.green)
                    }
                }
                
                Section(header: Text("Detalles del Pago")) {
                    HStack {
                        Text("$")
                        TextField("Monto del pago", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                    
                    DatePicker("Fecha del pago", selection: $paymentDate, displayedComponents: [.date, .hourAndMinute])
                    
                    TextField("Notas (opcional)", text: $notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button("Registrar Pago") {
                            addPayment()
                        }
                        .disabled(amount.isEmpty)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Nuevo Pago")
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
    
    private func addPayment() {
        guard let paymentAmount = Double(amount) else {
            return
        }
        
        withAnimation {
            let newPayment = Payment(context: viewContext)
            newPayment.id = UUID()
            newPayment.amount = paymentAmount
            newPayment.date = paymentDate
            newPayment.notes = notes.isEmpty ? nil : notes
            newPayment.loan = loan
            
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
    AddPaymentView(loan: PersistenceController.preview.container.viewContext.registeredObjects.compactMap { $0 as? Loan }.first!)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}