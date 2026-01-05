//
//  OvertimeTrackerApp.swift
//  OvertimeTracker
//
//  Created for tracking postman overtime hours
//

import SwiftUI

@main
struct OvertimeTrackerApp: App {
    @StateObject private var viewModel = OvertimeViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
