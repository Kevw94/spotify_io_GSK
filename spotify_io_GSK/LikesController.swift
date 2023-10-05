//
//  LikesController.swift
//  spotify_io_GSK
//
//  Created by coding on 03/10/2023.
//

import UIKit

class LikesController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var table: UITableView!
    var songs: [Music] = []
    var musicService = MusicService()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        table.separatorColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)

        table.dataSource = self
        table.delegate = self
        self.title = "Titres Likés"
        
        
        fetchMusic()
        
    }
    
    
        // ----- Affichage tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "likesCell", for: indexPath) as! CustomViewCell
        let son = songs[indexPath.row]
      
        cell.labelLikes.text = son.title
        //cell.iconImageView.image = UIImage(named: son.picture)
        cell.likesImageView?.downloaded(from: URL(string: son.image)!)
        cell.dislikeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        cell.dislikeButton.setTitleColor(.white, for: .normal)
        
        
        cell.backgroundColor = UIColor.black
        cell.labelLikes.textColor = UIColor.white
        
        
        return cell
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
        
        return 170
    }
    
    
}
