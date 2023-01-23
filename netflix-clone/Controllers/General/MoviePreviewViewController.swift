//
//  MoviePreviewViewController.swift
//  netflix-clone
//
//  Created by Irfan Izudin on 22/01/23.
//

import UIKit
import WebKit

class MoviePreviewViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
        label.text = "Avatar the legend of Aang"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Avatar the legend of Aang description"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    private let webPlayerUIView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .systemBackground
        view.addSubview(webPlayerUIView)
        webPlayerUIView.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(downloadButton)
        webView.navigationDelegate = self
        applyConstraints()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = webPlayerUIView.bounds
    
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            webPlayerUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webPlayerUIView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webPlayerUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webPlayerUIView.heightAnchor.constraint(equalToConstant: 250),
            webPlayerUIView.widthAnchor.constraint(equalToConstant: view.bounds.width),

            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: webPlayerUIView.bottomAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            downloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            downloadButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            downloadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            downloadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureMoviePreview(movie: Movie, videoElement: VideoElement) {
        titleLabel.text = movie.title ?? movie.original_title ?? movie.name ?? movie.original_name
        descriptionLabel.text = movie.overview
            if let url = URL(string: "https://www.youtube.com/embed/\(videoElement.id?.videoId ?? "QQjLp1uvQb8")") {
                DispatchQueue.main.async { [weak self] in
                    self?.webView.load(URLRequest(url: url))
                }
            } else {
                print("url nil")
            }
    }
}

extension MoviePreviewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish loaded")

    }
}
