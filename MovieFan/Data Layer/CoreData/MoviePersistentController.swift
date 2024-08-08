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
    private var movieCDFetchRequest: NSFetchRequest<MovieCD> = MovieCD.fetchRequest()
    
    init() {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Error \(error)")
            }
        }
    }
    
    func updateAndAddServerDataToCoreData(moviesFromServer: [MovieModel]?) {
        // 0. prepare incoming server side movie ids and dictionary
        var moviesIDDict: [Int: MovieModel] = [:]
        var moviesIDList: [Int] = []
        if let movies = moviesFromServer {
            for movie in movies {
                moviesIDDict[movie.id] = movie
                moviesIDList.append(movie.id)
            }
            //                        moviesIDList = movies.map { $0.id }
            
            // 1. get all movies that match incoming server side  movie ids
            // find any existing movies in our Local CoreData
            
            movieCDFetchRequest.predicate = NSPredicate(format: "id IN %@", moviesIDList)
            
            // 2. make a fetch request using predicate
            let managedObjectContext = persistentContainer.viewContext
            
            let movieCDList = try? managedObjectContext.fetch(movieCDFetchRequest)
            print("MovieCD List \(movieCDList)")
            
            // 3. update all matching movies to have the same data
            guard let movieCDList = movieCDList else { return }
            
            var movieIDListInCD: [Int] = []
            
            for movieCD in movieCDList {
                movieIDListInCD.append(Int(movieCD.id))
                let movie = moviesIDDict[Int(movieCD.id)]
                movieCD.setValue(movie?.overview, forKey: "overview")
                movieCD.setValue(movie?.releaseDate, forKey: "releaseDate")
                //                            movieCD.setValue(movie?.imgUrlSuffix, forKey: "imgUrlSuffix")
                movieCD.setValue(movie?.name, forKey: "name")
                //                            managedObjectContext.delete(movieCD)
            }
            // 4. add new objects coming from backend/server side
            for movie in movies {
                if !movieIDListInCD.contains(movie.id) {
                    let movieCD = MovieCD(context: managedObjectContext)
                    movieCD.name = movie.name
                    movieCD.id = Int64(movie.id)
                    movieCD.releaseDate = movie.releaseDate
                    //                                movieCD.imgUrlSuffix = movie.imgUrlSuffix
                    movieCD.overview = movie.overview
                }
            }
            // 5. save changes
            try? managedObjectContext.save()
        }
    }
    
    func fetchFromCoreData() -> [MovieModel] {
        let movieCDList = try? persistentContainer.viewContext.fetch(movieCDFetchRequest)
        print("MovieCD list \(movieCDList)")
        var convertedMovies: [MovieModel] = []
        guard let movieCDList = movieCDList else {
            return []
        }
        for movieCD in movieCDList {
            let movie = MovieModel(id: Int(movieCD.id) ?? 1, name: movieCD.name ?? "",
                                   imgUrlSuffix: "", // movieCD.imgUrlSuffix ??
                                   releaseDate: movieCD.releaseDate ?? "", overview: movieCD.overview ?? "")
            convertedMovies.append(movie)
        }
        return convertedMovies
    }
}
