//
//  NASAAppApp.swift
//  NASAApp
//
//  Created by Erick Daniel Padilla on 18/06/24.
//

import SwiftUI
import SwiftData

@main
struct NASAAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PictureOfTheDay.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.colorScheme, .dark)
        }
        .modelContainer(sharedModelContainer)
    }
}

var appIsRunningInPreview: Bool {
    ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}
