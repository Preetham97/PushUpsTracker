//
//  PushUpsTrackerApp.swift
//  PushUpsTracker
//
//  Created by Preetham Akhil Bhuma on 3/22/26.
//

import SwiftUI
import SwiftData

@main
struct PushUpsTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: PushUpDay.self)
    }
}
