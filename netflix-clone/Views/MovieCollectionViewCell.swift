//
//  MovieCollectionViewCell.swift
//  netflix-clone
//
//  Created by Irfan Izudin on 21/01/23.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configurePoster(url: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(url)") else { return }
        posterImageView.sd_setImage(with: url)
    }
    
}
