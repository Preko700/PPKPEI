import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample data for previews
        let samplePerson = Person(context: viewContext)
        samplePerson.id = UUID()
        samplePerson.name = "Juan Pérez"
        samplePerson.createdDate = Date()
        
        let sampleLoan = Loan(context: viewContext)
        sampleLoan.id = UUID()
        sampleLoan.initialAmount = 1000.0
        sampleLoan.interestRate = 5.0
        sampleLoan.startDate = Date()
        sampleLoan.dueDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        sampleLoan.isActive = true
        sampleLoan.person = samplePerson
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "LoanManager")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

// MARK: - Save function
extension PersistenceController {
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}