//
//  Youtube.swift
//  netflix-clone
//
//  Created by Irfan Izudin on 22/01/23.
//

import Foundation

struct YoutubeResponse: Codable {
    let items: [VideoElement]?
}

struct VideoElement: Codable {
    let id: VideoID?
}

struct VideoID: Codable {
    let videoId: String?
}
