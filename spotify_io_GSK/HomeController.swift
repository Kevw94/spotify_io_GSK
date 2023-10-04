//
//  ViewController.swift
//  spotify_io_GSK
//
//  Created by kevin on 03/10/2023.
//

import UIKit

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    struct Music {
        var title: String
        var imagePlaceholder: UIColor
    }
    
    var collectionView: UICollectionView!
    
    var songs: [Music] = [
        Music(title: "Chanson 1", imagePlaceholder: UIColor(hex: "#FAA0A0")),
        Music(title: "Chanson 2", imagePlaceholder: .green),
        Music(title: "Chanson 1", imagePlaceholder: .green),
        Music(title: "Chanson 2", imagePlaceholder: .green),
        Music(title: "Chanson 1", imagePlaceholder: .green),
        Music(title: "Chanson 2", imagePlaceholder: .green),
        Music(title: "Chanson 1", imagePlaceholder: .green),
        Music(title: "Chanson 2", imagePlaceholder: .green),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: "#191414")
        self.title = "Bienvenue"
        
        setCollectionViewLayout()
        setCollectionViewDataParameters()
        


        view.addSubview(collectionView)

        // Configuration des contraintes
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    func setCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.size.width/2) - 15, height: 200)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(hex: "#191414")
    }
    
    func setCollectionViewDataParameters() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MusicCellController.self, forCellWithReuseIdentifier: "MusicCell")
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCell", for: indexPath) as! MusicCellController
        cell.titleLabel.text = songs[indexPath.row].title
        cell.imageView.backgroundColor = songs[indexPath.row].imagePlaceholder
        return cell
    }
}




