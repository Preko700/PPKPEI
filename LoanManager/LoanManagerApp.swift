import SwiftUI

@main
struct LoanManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    NotificationManager.shared.requestPermission()
                }
        }
    }
}