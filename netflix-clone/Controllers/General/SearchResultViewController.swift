//
//  SearchResultViewController.swift
//  netflix-clone
//
//  Created by Irfan Izudin on 22/01/23.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTap(movie: Movie, videoElement: VideoElement)
}

class SearchResultViewController: UIViewController {

    weak var delegate: SearchResultViewControllerDelegate?
    
    public var movies: [Movie] = []
    
    public let searchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchCollectionView)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchCollectionView.frame = view.bounds
    }
    
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        let posterPath = movies[indexPath.row].poster_path
        cell.configurePoster(url: posterPath ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("tapp from search result")
        let movie = movies[indexPath.row]
        guard let title = movie.name ?? movie.original_name ?? movie.title ?? movie.original_title  else { return }

        APICaller.shared.getYoutubeVideo(query: "\(title) trailer") { [weak self] result in
            switch result {
            case.success(let videoElement):
                self?.delegate?.searchResultViewControllerDidTap(movie: movie, videoElement: videoElement)
                print("tappp")

            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
