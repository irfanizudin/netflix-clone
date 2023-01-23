//
//  SearchViewController.swift
//  netflix-clone
//
//  Created by Irfan Izudin on 20/01/23.
//

import UIKit

class SearchViewController: UIViewController {

    private var movies: [Movie] = []
    
    private let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: SearchResultViewController())
        search.searchBar.placeholder = "Search a Movies or TV Shows here..."
        search.searchBar.searchBarStyle = .minimal
        search.searchBar.tintColor = .white
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(searchTableView)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        
        fetchTopRatedTV()
    }
    
    private func fetchTopRatedTV() {
        APICaller.shared.getTopRatedTV { [weak self] result in
            switch result {
            case.success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }
    

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
        let movies = movies[indexPath.row]
        cell.configureUpcomingMovie(movies: movies)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        guard let title = movie.title ?? movie.original_title ?? movie.name ?? movie.original_name else { return }
        
        APICaller.shared.getYoutubeVideo(query: title) { [weak self] result in
            switch result {
            case.success(let videoElement):
                DispatchQueue.main.async {
                    let vc = MoviePreviewViewController()
                    vc.configureMoviePreview(movie: movie, videoElement: videoElement)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultViewControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController else { return }
        
        resultController.delegate = self
        
        APICaller.shared.searchMovies(query: query) { result in
            switch result {
            case.success(let movies):
                resultController.movies = movies
                DispatchQueue.main.async {
                    resultController.searchCollectionView.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchResultViewControllerDidTap(movie: Movie, videoElement: VideoElement) {
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configureMoviePreview(movie: movie, videoElement: videoElement)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
}

