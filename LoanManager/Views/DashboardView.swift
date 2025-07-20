import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: true)],
        animation: .default)
    private var people: FetchedResults<Person>
    
    @State private var showingAddPerson = false
    
    var body: some View {
        NavigationView {
            VStack {
                if people.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "person.2.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No hay personas registradas")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("Toca el botón + para agregar una persona")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(people) { person in
                            NavigationLink(destination: PersonDetailView(person: person)) {
                                PersonRowView(person: person)
                            }
                        }
                        .onDelete(perform: deletePeople)
                    }
                }
            }
            .navigationTitle("Gestión de Préstamos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddPerson = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPerson) {
                AddPersonView()
            }
        }
    }
    
    private func deletePeople(offsets: IndexSet) {
        withAnimation {
            offsets.map { people[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct PersonRowView: View {
    let person: Person
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(person.wrappedName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if person.totalDebt > 0 {
                    Text("$\(person.totalDebt, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(person.activeLoans.contains { $0.isOverdue } ? .red : .green)
                }
            }
            
            HStack {
                Text("\(person.activeLoans.count) préstamo(s) activo(s)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if person.activeLoans.contains(where: { $0.isOverdue }) {
                    Label("Vencido", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DashboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}