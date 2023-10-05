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
        
        self.songs = LikedMusicModel.shared.likedMusics
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikedMusics), name: NSNotification.Name(rawValue: "MusicLiked"), object: nil)
        
        print(LikedMusicModel.shared.likedMusics)
        self.view.backgroundColor = UIColor.black
        
        table.separatorColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        
        table.dataSource = self
        table.delegate = self
        self.title = "Titres Likés"
        
    }
    
    
    @objc func updateLikedMusics(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let likedMusics = userInfo["likedMusics"] as? [Music] {
            
            self.songs = likedMusics
            self.table.reloadData()
        }
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
        cell.dislikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        cell.dislikeButton.setTitleColor(.white, for: .normal)
        
        
        cell.backgroundColor = UIColor.black
        cell.labelLikes.textColor = UIColor.white
        
        
        return cell
    }
    
    
    
    //-------------- Customiser la hauteur des cells de la tableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "music") as? MusicPlayerController {
            
            vc.musics = songs
            vc.indexSound = indexPath.row
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func dislikeButton(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? UITableViewCell,
           let indexPath = table.indexPath(for: cell) {
            
            let row = indexPath.row
            
            songs.remove(at: row)
            LikedMusicModel.shared.likedMusics.remove(at: row)
            self.table.reloadData()
        }
    }
    
    
}
