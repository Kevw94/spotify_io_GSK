import UIKit
import AVKit

class MusicPlayerController: UIViewController {
    var audioPlayer: AVPlayer?
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var nextMusicButton: UIButton!
    @IBOutlet weak var prevMusicButton: UIButton!
    @IBOutlet weak var imgAlbumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var controlButton: UIButton!
    
    var musics: [Music]?
    var indexSound: Int?
    let playImage = UIImage(systemName: "play")
    let pauseImage = UIImage(systemName: "pause")
    
    var musicPlayerManager = MusicPlayerManager.shared
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicPlayerManager.playMusic(with: self.musics?[self.indexSound!])
        customMusicPlayerLayout()
        
        self.slider!.minimumValue = 0
        
        
        
        // SET slider to 0 initial value
        self.slider.value = 0
        if let duration = musicPlayerManager.audioPlayer?.currentItem?.asset.duration {
            let durationInSeconds = CMTimeGetSeconds(duration)
            self.slider.maximumValue = Float(durationInSeconds)
        }
        self.slider!.isContinuous = false
        self.slider!.tintColor = UIColor.green
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: musicPlayerManager.audioPlayer?.currentItem)
        musicPlayerManager.audioPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.musicPlayerManager.audioPlayer!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.musicPlayerManager.audioPlayer!.currentTime());
                self.slider!.value = Float ( time );
            }
            
        }
        self.controlButton.setImage(self.pauseImage, for: .normal)
        self.controlButton.isSelected = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
        
    }
    
    
    @IBAction func prevMusicButton(_ sender: UIButton) {
        if self.indexSound! > 0 {
            self.indexSound? -= 1
            
            playNextTrack()
            setupUI()
        }
        
    }
    
    @IBAction func nextMusicButton(_ sender: UIButton) {
        if self.indexSound! < self.musics?.count ?? 0 {
            self.indexSound? += 1
            
            playNextTrack()
            setupUI()
        }
        
    }
    
    
    @IBAction func sliderChange(_ sender: UISlider) {
        let seconds : Double = Double(slider.value)
        musicPlayerManager.seek(to: seconds)
    }
    @IBAction func playButton(_ sender: UIButton) {
        if controlButton.isSelected {
            controlButton.isSelected = false
            controlButton.setImage(self.playImage, for: .normal)
            musicPlayerManager.pause()
        }
        else {
            controlButton.isSelected = true
            controlButton.setImage(self.pauseImage, for: .normal)
            musicPlayerManager.play()
        }
    }
    
    
    
    @IBAction func likeButton(_ sender: Any) {
        
        if likeButton.currentImage == UIImage(systemName: "heart") {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                // Code à exécuter lorsque le cœur devient rempli
            } else {
               likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                // Code à exécuter lorsque le cœur devient non rempli
            }
    }
    
    
    func setupUI() {
        
        self.titleLabel.text = musics?[indexSound!].title
        self.artistLabel.text = musics?[indexSound!].artist.name
        
        if let imageUrl = musics?[indexSound!].image {
            imgAlbumCover.downloaded(from: imageUrl)
        }
    }
    
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        self.controlButton.isSelected = false
        self.controlButton.setImage(self.playImage, for: .normal)
        if self.indexSound! < self.musics?.count ?? 0 {
            self.indexSound? += 1
            
            playNextTrack()
            setupUI()
        }
    }
    
    func playNextTrack() {
        if self.indexSound! < self.musics?.count ?? 0 {
            musicPlayerManager.playMusic(with: self.musics?[self.indexSound!])
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: musicPlayerManager.audioPlayer?.currentItem)
            
            musicPlayerManager.audioPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
                if self.musicPlayerManager.audioPlayer!.currentItem?.status == .readyToPlay {
                    let time : Float64 = CMTimeGetSeconds(self.musicPlayerManager.audioPlayer!.currentTime());
                    self.slider!.value = Float ( time );
                }
            }
            
        
            self.controlButton.isSelected = true
            self.controlButton.setImage(self.pauseImage, for: .normal)
            self.slider.value = 0
        }
    }
    
    func customMusicPlayerLayout() {
            self.view.backgroundColor = UIColor(hex: "#191414")
            self.titleLabel.textColor = UIColor.white
            self.artistLabel.textColor = UIColor.white
            self.slider.tintColor = UIColor(hex: "#1ed760")
            
            // Couleur pour les boutons
            self.controlButton.tintColor = UIColor(hex: "#FFFFFF")
            self.controlButton.layer.masksToBounds = true
            self.controlButton.layer.cornerRadius = 35
            self.nextMusicButton.tintColor = UIColor(hex: "#1ed760")
            self.prevMusicButton.tintColor = UIColor(hex: "#1ed760")
            
            self.likeButton.tintColor = UIColor(hex: "#FFFFFF")
            let likeButtonSize = self.likeButton.frame.size.width
            self.likeButton.layer.cornerRadius = likeButtonSize / 2
            self.likeButton.layer.masksToBounds = true
            self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
}
