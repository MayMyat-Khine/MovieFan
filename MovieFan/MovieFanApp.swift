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
    

    var body: some Scene {
        WindowGroup {
            NavigationView {
                MoviesView().environmentObject(MovieViewModel())
            }
        }
    }
}
