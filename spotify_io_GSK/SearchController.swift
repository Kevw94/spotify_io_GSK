//
//  SearchController.swift
//  spotify_io_GSK
//
//  Created by coding on 03/10/2023.
//

import UIKit

class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var songs: [Music] = []
    var musicService = MusicService()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: "#191414")
        
        self.title = "Recherche"

        table.separatorColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        table.dataSource = self
        table.delegate = self
        
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = .systemGray
        searchBar.barTintColor = UIColor(hex: "#191414")
        searchBar.placeholder = "Recherchez"
        
        
        fetchMusic()
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell", for: indexPath) as! CustomViewCell
        let son = songs[indexPath.row]
      
        cell.label.text = son.image
        //cell.iconImageView.image = UIImage(named: son.picture)
        if let pictureURL = URL(string: son.image) {
            cell.imageView?.downloaded(from: pictureURL)
        }
        
        //cell.imageView?.downloaded(from: URL(string: son.picture)!)
        
        
        
        cell.backgroundColor = UIColor(hex: "#191414")
        cell.label.textColor = UIColor.white
        
        
        return cell
    }
    
    //------------------- alertDialog -----------------

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let son = songs[indexPath.row]
        let music = "Voulez-vous écouter \(son.title) ?"

        let alert = UIAlertController(title: "Hey", message: music, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { action in
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "likesPage") as? LikesController {
               
                self.present(vc, animated: true, completion: nil)
            }
        }))
        alert.addAction((UIAlertAction(title: "Non", style: .cancel, handler: nil)))
        
        
        self.present(alert, animated: true, completion: nil)
    }

    func fetchMusic() {
        musicService.fetchMusic { [weak self] (songs, error) in
            guard let songs = songs else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            self?.songs = songs
            DispatchQueue.main.async {
                self?.table.reloadData()
            }
        }
        
    }
    
    
    //-------------- Customiser la hauteur des cells de la tableView
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 155
    }
    
    // -------- Update la selection lors de la recherche -------
    
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        // Mettez à jour l'URL de recherche avec le texte entré
        if let url = URL(string: "https://api.deezer.com/search?q=\(text)") {
            // Utilisez l'URL avec succès
            let updatedURL = url
            
            // Effectuez une nouvelle requête
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: updatedURL) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                        if let data = json as? [String: AnyObject] {
                            
                            if let items = data["data"] as? [[String: AnyObject]] {
                                
                                // Réinitialisez votre tableau data avec les nouveaux résultats
                                self.songs.removeAll()
                                
                                for item in items {
                                    if let artist = Music(json: item) {
                                        self.songs.append(artist)
                                    }
                                }
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.table.reloadData()
                   // self.table.isUserInteractionEnabled = true
                }
            }
            task.resume()
          
        } else {
            // Gérer le cas où la création de l'URL a échoué
            print("Erreur : Impossible de créer l'URL.")
        }

      
    }
}


