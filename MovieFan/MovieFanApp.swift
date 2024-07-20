//
//  MovieFanApp.swift
//  MovieFan
//
//  Created by Khine Myat on 18/07/2024.
//

import SwiftData
import SwiftUI

@main
struct MovieFanApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
//            ContentView()
            MoviesView().environmentObject(MovieViewModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
