//
//  KofyApp.swift
//  Kofy
//
//  Created by Diego Gutierrez on 03/10/23.
//

import SwiftUI
import SwiftData

@main
struct KofyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [History.self, Summary.self, Prescription.self, PrescriptionReminder.self, RegisteredReminders.self])
    }
}
