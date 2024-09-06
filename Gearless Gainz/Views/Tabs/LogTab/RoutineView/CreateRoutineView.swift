//
//  CreateRoutineView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 06/09/24.
//

import SwiftUI
import SwiftData

struct CreateRoutineView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var errorString = ""
    @State private var routineName = ""
    @State private var routineNote = ""
    @Query private var routines: [Routine]
    var routine: Routine?
    
    var body: some View {
        NavigationStack {
            List {
                Section("Routine Name") {
                    VStack(alignment: .leading) {
                        TextField("e.g. Push Pull Leg", text: $routineName, axis: .vertical)
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
                
                Button(routine != nil ? "Save Routine" : "Create Routine") {
                    if routineName == "" {
                        errorString = "Routine name can't be empty"
                    } else if routines.contains(where: {
                        $0.name.lowercased() == routineName.lowercased() && $0.id != routine?.id
                    }) {
                        errorString = "Routine with same name already exists!"
                    } else {
                        if routine == nil {
                            let newRoutine = Routine(name: routineName, order: routines.count)
                            if routineNote != "" {
                                newRoutine.note = routineNote
                            }
                            modelContext.insert(newRoutine)
                        } else {
                            routine!.name = routineName
                            if routineNote != "" {
                                routine!.note = routineNote
                            }
                        }
                        dismiss()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Create Routine")
            .onAppear {
                if routine != nil {
                    routineName = routine!.name
                    routineNote = routine!.note ?? ""
                }
            }
        }
    }
    
    private func isSameRoutineName ()->Bool {
        
        return false
    }
}
