import SwiftUI

struct AddPersonView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var initialAmount = ""
    @State private var interestRate = ""
    @State private var dueDate = Date().addingTimeInterval(30 * 24 * 60 * 60) // Default 30 days
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información de la Persona")) {
                    TextField("Nombre", text: $name)
                        .textContentType(.name)
                }
                
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
                        Button("Crear Persona y Préstamo") {
                            createPersonWithLoan()
                        }
                        .disabled(name.isEmpty || initialAmount.isEmpty || interestRate.isEmpty)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Nueva Persona")
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
    
    private func createPersonWithLoan() {
        guard let initialAmountValue = Double(initialAmount),
              let interestRateValue = Double(interestRate) else {
            return
        }
        
        withAnimation {
            let newPerson = Person(context: viewContext)
            newPerson.id = UUID()
            newPerson.name = name
            newPerson.createdDate = Date()
            
            let newLoan = Loan(context: viewContext)
            newLoan.id = UUID()
            newLoan.initialAmount = initialAmountValue
            newLoan.interestRate = interestRateValue
            newLoan.startDate = Date()
            newLoan.dueDate = dueDate
            newLoan.isActive = true
            newLoan.customDebtAmount = 0.0
            newLoan.person = newPerson
            
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
    AddPersonView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}