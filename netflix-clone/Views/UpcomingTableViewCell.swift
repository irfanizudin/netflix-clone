//
//  UpcomingTableViewCell.swift
//  netflix-clone
//
//  Created by Irfan Izudin on 21/01/23.
//

import UIKit
import SDWebImage

class UpcomingTableViewCell: UITableViewCell {

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "heroImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
        label.text = "Avatar"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playButtonCircle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    static let identifier = "UpcomingTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButtonCircle)
        applyConstraints()
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: playButtonCircle.leadingAnchor, constant: -10),
            
            playButtonCircle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            playButtonCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButtonCircle.widthAnchor.constraint(equalToConstant: 40),
            playButtonCircle.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    public func configureUpcomingMovie(movies: Movie) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(movies.poster_path ?? "")") else { return }
        posterImageView.sd_setImage(with: url)
        titleLabel.text = movies.title ?? movies.original_title ?? movies.name ?? movies.original_name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
