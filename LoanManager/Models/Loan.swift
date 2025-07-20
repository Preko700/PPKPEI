import Foundation
import CoreData

@objc(Loan)
public class Loan: NSManagedObject {
    
}

extension Loan {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Loan> {
        return NSFetchRequest<Loan>(entityName: "Loan")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var initialAmount: Double
    @NSManaged public var interestRate: Double
    @NSManaged public var startDate: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var isActive: Bool
    @NSManaged public var customDebtAmount: Double
    @NSManaged public var person: Person?
    @NSManaged public var payments: NSSet?
}

// MARK: Generated accessors for payments
extension Loan {
    @objc(addPaymentsObject:)
    @NSManaged public func addToPayments(_ value: Payment)

    @objc(removePaymentsObject:)
    @NSManaged public func removeFromPayments(_ value: Payment)

    @objc(addPayments:)
    @NSManaged public func addToPayments(_ values: NSSet)

    @objc(removePayments:)
    @NSManaged public func removeFromPayments(_ values: NSSet)
}

extension Loan : Identifiable {
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedStartDate: Date {
        startDate ?? Date()
    }
    
    public var wrappedDueDate: Date {
        dueDate ?? Date()
    }
    
    public var paymentsArray: [Payment] {
        let set = payments as? Set<Payment> ?? []
        return set.sorted { $0.wrappedDate > $1.wrappedDate }
    }
    
    public var totalPayments: Double {
        paymentsArray.reduce(0) { $0 + $1.amount }
    }
    
    public var calculatedDebt: Double {
        let timeInterval = Date().timeIntervalSince(wrappedStartDate)
        let days = timeInterval / (24 * 60 * 60)
        let interest = initialAmount * (interestRate / 100) * (days / 365)
        return initialAmount + interest - totalPayments
    }
    
    public var currentDebt: Double {
        return customDebtAmount > 0 ? customDebtAmount : calculatedDebt
    }
    
    public var isOverdue: Bool {
        return Date() > wrappedDueDate && isActive
    }
    
    public var daysOverdue: Int {
        if !isOverdue { return 0 }
        let timeInterval = Date().timeIntervalSince(wrappedDueDate)
        return Int(timeInterval / (24 * 60 * 60))
    }
}