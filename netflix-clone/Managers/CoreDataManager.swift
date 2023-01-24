//
//  CoredataManager.swift
//  netflix-clone
//
//  Created by Irfan Izudin on 24/01/23.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "MovieModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load CoreData ", error.localizedDescription )
            } else {
                print("Success load CoreData")
            }
        }
    }
    
    func getDownloadMovies(completion: @escaping(Result<[MovieEntity], Error>) -> ()) {
        let request = NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
        do {
            let result = try container.viewContext.fetch(request)
            completion(.success(result))
        } catch {
            completion(.failure(error))
            print(error.localizedDescription)
        }
    }
    
    func downloadMovie(movie: Movie, completion: @escaping(Result<Void, Error>) -> ()) {
        let newMovie = MovieEntity(context: container.viewContext)
        newMovie.id = Int64(movie.id ?? 0)
        newMovie.title = movie.title
        newMovie.original_title = movie.original_title
        newMovie.name = movie.name
        newMovie.original_name = movie.original_name
        newMovie.poster_path = movie.poster_path
        newMovie.backdrop_path = movie.backdrop_path
        newMovie.overview = movie.overview
        newMovie.popularity = movie.popularity ?? 0
        newMovie.release_date = movie.release_date
        do {
            try container.viewContext.save()
            completion(.success(()))
        } catch {
            print("Failed to save data", error.localizedDescription)
            completion(.failure(error))
        }

    }
        
    
}
