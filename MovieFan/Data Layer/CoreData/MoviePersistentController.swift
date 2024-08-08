//
//  MoviePersistentController.swift
//  MovieFan
//
//  Created by Khine Myat on 06/08/2024.
//

import CoreData
import Foundation

class MoviePersistentController: ObservableObject {
    var persistentContainer = NSPersistentContainer(name: "MovieFan")
    init() {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Error \(error)")
            }
        }
    }
}
