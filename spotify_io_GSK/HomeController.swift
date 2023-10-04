import UIKit

class HomeController: UIViewController {

    var collectionView: UICollectionView!
    var songs: [Music] = []
    var musicService = MusicService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = UIColor(hex: "#191414")
        self.title = "Bienvenue"
        
        setCollectionViewLayout()
        setCollectionViewDataParameters()
        view.addSubview(collectionView)
        
        fetchMusic()
        
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
        let size = (view.frame.size.width / 2) - 15
        layout.itemSize = CGSize(width: size, height: size)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(hex: "#191414")
    }
    
    func setCollectionViewDataParameters() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MusicCellController.self, forCellWithReuseIdentifier: "MusicCell")
    }
    
    func fetchMusic() {
        musicService.fetchMusic { [weak self] (songs, error) in
            guard let songs = songs else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }

            self?.songs = songs
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCell", for: indexPath) as! MusicCellController
        cell.titleLabel.text = songs[indexPath.row].title
        if let imageUrl = URL(string: songs[indexPath.row].image) {
            cell.imageView.downloaded(from: imageUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       /* let musicPlayerController = MusicPlayerController()
        musicPlayerController.selectedMusic = songs[indexPath.row]
        if let imageUrl = URL(string: songs[indexPath.row].image) {
            musicPlayerController.musicImage = imageUrl
        }
        self.present(musicPlayerController, animated: true, completion: nil)*/
        
        if let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "music") as? MusicPlayerController {
            
            vc.musics = songs
            vc.indexSound = indexPath.row
            self.present(vc, animated: true, completion: nil)
        }

    }
}
