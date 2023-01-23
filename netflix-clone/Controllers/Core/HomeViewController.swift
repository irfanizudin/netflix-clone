//
//  HomeViewController.swift
//  netflix-clone
//
//  Created by Irfan Izudin on 20/01/23.
//

import UIKit


enum Section: Int {
    case trendingMovies = 0
    case trendingTV = 1
    case popularMovies = 2
    case topRatedTV = 3
    case upcomingMovies = 4
}

class HomeViewController: UIViewController {

    private var randomTrendingMovie: Movie?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular Movies", "Top Rated TV", "Upcoming Movies"]
    
    private let homeFeedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(homeFeedTableView)
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        
        configureNavbar()

        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTableView.tableHeaderView = headerView
        getRandomTrendingMovie()

    }
    
    private func getRandomTrendingMovie() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case.success(let movies):
                self?.randomTrendingMovie = movies.randomElement()
                self?.headerView?.configureHeaderImage(posterPath: self?.randomTrendingMovie?.poster_path ?? "/9xkGlFRqrN8btTLU0KQvOfn2PHr.jpg")
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
        
    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
    
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTableView.frame = view.bounds
//        NSLayoutConstraint.activate([
//            homeFeedTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
//        ])
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Section.trendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let movies):
                    cell.configureMovies(movies: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.trendingTV.rawValue:
            APICaller.shared.getTrendingTV { result in
                switch result {
                case.success(let movies):
                    cell.configureMovies(movies: movies)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.popularMovies.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case.success(let movies):
                    cell.configureMovies(movies: movies)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.topRatedTV.rawValue:
            APICaller.shared.getTopRatedTV { result in
                switch result {
                case.success(let movies):
                    cell.configureMovies(movies: movies)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.upcomingMovies.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case.success(let movies):
                    cell.configureMovies(movies: movies)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .preferredFont(forTextStyle: .headline)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let defaultOffset = view.safeAreaInsets.top
//        let offset = scrollView.contentOffset.y + defaultOffset
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionTableViewCellDelegate {
    func collectionTableViewCellDidTap(_ cell: CollectionTableViewCell, movie: Movie, videoElement: VideoElement) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configureMoviePreview(movie: movie, videoElement: videoElement)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
