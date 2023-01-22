//
//  Movie.swift
//  netflix-clone
//
//  Created by Irfan Izudin on 21/01/23.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int?
    let genre_ids: [Int]?
    let backdrop_path: String?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let name: String?
    let original_name: String?
}
