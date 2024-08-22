//
//  SettingsTab.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 19/08/24.
//

import SwiftUI

struct SettingsTab: View {
    @AppStorage("isWeightInKG") private var isWeightInKG = true
    @AppStorage("incrementWeight") private var incrementWeight = 2.5

    @State private var incrementWeightState: Double?
    @FocusState private var isFocused: Bool
    var body: some View {
        NavigationStack{
            List{
                Section("Weight settings"){
                    // Weight units
                    HStack(spacing: 32) {
                        Text("Weight Units")
                        Picker("", selection: $isWeightInKG, content: {
                            Text("KG").tag(true)
                            Text("LB").tag(false)
                        })
                        .pickerStyle(.segmented)
                        
                    }
                    // Increment weight
                    HStack{
                        Text("Increment weight")
                        Spacer()
                        TextField("",
                                  value: $incrementWeightState,
                                  format: .number,
                                  prompt: Text(String(format: "%.2f", incrementWeight * (isWeightInKG ? 1: 2.2)))
                            .foregroundStyle(!isFocused ? Color.primary : Color.secondary)
                        )
                        .focused($isFocused)
                        .keyboardType(.decimalPad)
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: incrementWeightState, {
                            if incrementWeightState != nil {
                                let m = isWeightInKG ? 1: 2.2
                                incrementWeight = incrementWeightState! / m
                            }
                        })
                        .onChange(of: isWeightInKG, {
                            if incrementWeightState != nil {
                                let m = isWeightInKG ? 1: 2.2
                                incrementWeightState = incrementWeight * m
                            }
                        })
                        .toolbar {
                            if isFocused {
                                ToolbarItem(placement: .keyboard) {
                                    Button("Done", systemImage: "keyboard.chevron.compact.down"){
                                        isFocused = false
                                        incrementWeightState = nil
                                    }
                                }
                            }
                        }
                        Text(isWeightInKG ? "KG" : "LB")
                            .font(.caption)
                    }
                }
                
                // Delete Entire data present in the app
            }
            .navigationTitle("App Settings")
        }
    }
}

#Preview {
    SettingsTab()
}
