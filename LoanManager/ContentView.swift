import SwiftUI

struct ContentView: View {
    var body: some View {
        DashboardView()
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}