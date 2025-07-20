import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func schedulePaymentReminder(for loan: Loan) {
        guard loan.isActive, let dueDate = loan.dueDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Recordatorio de Pago"
        content.body = "El préstamo de \(loan.person?.wrappedName ?? "una persona") vence hoy. Deuda actual: $\(loan.currentDebt, specifier: "%.2f")"
        content.sound = .default
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: loan.wrappedId.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for loan \(loan.wrappedId)")
            }
        }
    }
    
    func cancelNotification(for loan: Loan) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [loan.wrappedId.uuidString])
    }
    
    func scheduleOverdueReminder(for loan: Loan) {
        guard loan.isActive && loan.isOverdue else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Préstamo Vencido"
        content.body = "El préstamo de \(loan.person?.wrappedName ?? "una persona") está vencido hace \(loan.daysOverdue) días. Deuda: $\(loan.currentDebt, specifier: "%.2f")"
        content.sound = .default
        
        // Schedule for tomorrow at 9 AM
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "\(loan.wrappedId.uuidString)-overdue", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling overdue notification: \(error.localizedDescription)")
            }
        }
    }
}