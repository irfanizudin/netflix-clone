//
//  CollectionTableViewCell.swift
//  netflix-clone
//
//  Created by Irfan Izudin on 20/01/23.
//

import UIKit

protocol CollectionTableViewCellDelegate: AnyObject {
    func collectionTableViewCellDidTap(_ cell: CollectionTableViewCell, movie: Movie, videoElement: VideoElement)
}

class CollectionTableViewCell: UITableViewCell {

    weak var delegate: CollectionTableViewCellDelegate?
    
    static let identifier = "CollectionTableViewCell"
    
    private var movies: [Movie] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .yellow
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configureMovies(movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadMovie(indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        CoreDataManager.shared.downloadMovie(movie: movie) { result in
            switch result {
            case.success(()):
                print("Download success")
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let posterPath = movies[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configurePoster(url: posterPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        guard let title = movie.title ?? movie.original_title ?? movie.name ?? movie.original_name else { return }
        
        APICaller.shared.getYoutubeVideo(query: "\(title) trailer") { [weak self] result in
            switch result {
            case.success(let videoElement):
                
                guard let strongSelf = self else { return }
                
                self?.delegate?.collectionTableViewCellDidTap(strongSelf, movie: movie, videoElement: videoElement)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(actionProvider:  { _ in
            let downloadAction = UIAction(title: "Download") { [weak self] _ in
                self?.downloadMovie(indexPath: indexPath)
            }
            return UIMenu(children: [downloadAction])
        })
        return config
    }
}
