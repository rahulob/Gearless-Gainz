//
//  RoutinesView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 03/09/24.
//

import SwiftUI
import SwiftData

struct RoutinesView: View {
    @State private var showRoutinesSheet = false
    var body: some View {
        GroupBox("Routines"){
            VStack{
                Button(
                    action: {
                        showRoutinesSheet.toggle()
                    }, label: {
                        Label("Start From Routine", systemImage: "clock.arrow.2.circlepath")
                            .frame(maxWidth: .infinity)
                            .padding(8)
                    }
                )
                .buttonStyle(BorderedButtonStyle())
            }
            .fontWeight(.bold)
        }
        .padding()
        .cornerRadius(3)
        .shadow(radius: 10)
        .sheet(isPresented: $showRoutinesSheet, content: {
            RoutinesSheet()
        })
    }
}

private struct RoutinesSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var routines: [Routine]
    @State private var showCreateRoutineSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(routines) {routine in
                    RoutineListItem(routine: routine)
                }
            }
            .overlay {
                if routines.isEmpty {
                    EmptyRoutinesMessage()
                }
            }
            .safeAreaInset(edge: .bottom, content: {
                // Create new Routine
                Button {
                    showCreateRoutineSheet.toggle()
                } label: {
                    Label("Add Routine", systemImage: "plus")
                        .fontWeight(.bold)
                        .padding(8)
                }
                .buttonStyle(.borderedProminent)
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Button("Dismiss", systemImage: "xmark.circle.fill"){
                        dismiss()
                    }
                }
            }
            .navigationTitle("Routines")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showCreateRoutineSheet, content: {
                CreateRoutineSheet()
            })
        }
    }
}

private struct EmptyRoutinesMessage: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "text.badge.xmark")
            Text("No Routines found!")
                .multilineTextAlignment(.center)
            Spacer()
        }
        .font(.headline)
    }
}

private struct CreateRoutineSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var errorString = ""
    @State private var routineName = ""
    @State private var routineNote = ""
    @Query private var routines: [Routine]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Name") {
                    VStack(alignment: .leading) {
                        TextField("Enter Name", text: $routineName, axis: .vertical)
                            .font(.title3)
                            .fontWeight(.bold)
                        if errorString != "" {
                            Text(errorString)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }
                Section("Description") {
                    TextField("Describe routine", text: $routineNote, axis: .vertical)
                }
                
                Button("Create Routine") {
                    if routineName == "" {
                        errorString = "Routine name can't be empty"
                    } else if routines.contains(where: {$0.name.lowercased() == routineName.lowercased()}){
                        errorString = "Routine with same name already exists!"
                    } else {
                        let routine = Routine(name: routineName, order: routines.count, note: routineNote)
                        modelContext.insert(routine)
                        dismiss()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Create Routine")
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Button("Dismiss", systemImage: "xmark.circle.fill"){
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func isSameRoutineName ()->Bool {
        
        return false
    }
}

private struct RoutineListItem: View {
    var routine: Routine
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "folder.fill")
            VStack(alignment: .leading) {
                Text(routine.name)
                    .fontWeight(.bold)
                if routine.note != nil {
                    Text(routine.note!)
                        .lineLimit(3)
                        .font(.caption)
                }
            }
        }
    }
}

#Preview {
    RoutinesView()
}
