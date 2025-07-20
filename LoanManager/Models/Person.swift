import Foundation
import CoreData

@objc(Person)
public class Person: NSManagedObject {
    
}

extension Person {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var loans: NSSet?
}

// MARK: Generated accessors for loans
extension Person {
    @objc(addLoansObject:)
    @NSManaged public func addToLoans(_ value: Loan)

    @objc(removeLoansObject:)
    @NSManaged public func removeFromLoans(_ value: Loan)

    @objc(addLoans:)
    @NSManaged public func addToLoans(_ values: NSSet)

    @objc(removeLoans:)
    @NSManaged public func removeFromLoans(_ values: NSSet)
}

extension Person : Identifiable {
    public var wrappedName: String {
        name ?? "Sin nombre"
    }
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var loansArray: [Loan] {
        let set = loans as? Set<Loan> ?? []
        return set.sorted { $0.wrappedStartDate > $1.wrappedStartDate }
    }
    
    public var activeLoans: [Loan] {
        loansArray.filter { $0.isActive }
    }
    
    public var totalDebt: Double {
        activeLoans.reduce(0) { $0 + $1.currentDebt }
    }
}