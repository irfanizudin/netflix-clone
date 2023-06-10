# SwiftFlix

SwiftFlix is a Netflix native iOS app clone.

![swiftflix](https://github.com/irfanizudin/netflix-clone/assets/67688261/340a88e6-a087-45f7-bf7d-8865473d56e6)

## Features

- Show movie list based on Trending Movies, Trending TV, Popular Movies, Top Rated TV, Upcoming Movies
- Search movies
- Download movies and save to coredata
- Show movie trailer

## Tech Stack

- UIKit
- Programmatic UI
- Coredata
- WebKit

## Architecture

- MVC architecture pattern

## Dependency

Swift Package Manager is used as a dependency manager. List of dependecies:

- [SDWebImage](https://github.com/SDWebImage/SDWebImage.git)

## API

- [TMDB API](https://developer.themoviedb.org/reference/intro/getting-started)
- [Youtube API](https://developers.google.com/youtube/v3)

## Usage

- To run this app properly, you will need an API key from TMDB API and YouTube API.
- After obtaining the API key, follow these steps:
  1. Create a Swift file named "APIKey.swift" in the "Managers" folder.
  2. Add the following code and replace "YOUR_TMDB_API_KEY" and "YOUR_YOUTUBE_API_KEY" with your respective API keys:
     ```
     struct APIKey {
         static let tmdbAPIKey = "YOUR_TMDB_API_KEY"
         static let youtubeAPIKey = "YOUR_YOUTUBE_API_KEY"
     }
     ```
  3. The app is now ready to be run.
