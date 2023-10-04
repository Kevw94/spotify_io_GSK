import UIKit
import AVKit

class MusicPlayerController: UIViewController {
    var audioPlayer: AVPlayer?
    
    @IBOutlet weak var imgAlbumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var slider: UISlider!

    @IBOutlet weak var controlButton: UIButton!
    
    var musics: [Music]?
    var indexSound: Int?
    let playImage = UIImage(systemName: "play")
    let pauseImage = UIImage(systemName: "pause")

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        if let musicURL = URL(string: self.musics?[self.indexSound!].preview ?? "") {
            let playerItem = AVPlayerItem(url: musicURL)
            self.audioPlayer = AVPlayer(playerItem: playerItem)
            
        }
        self.slider!.minimumValue = 0
        
        
        // SET slider to 0 initial value
        self.slider.value = 0
        if let duration = self.audioPlayer?.currentItem?.asset.duration {
            let durationInSeconds = CMTimeGetSeconds(duration)
            self.slider.maximumValue = Float(durationInSeconds)
        }
        self.slider!.isContinuous = false
        self.slider!.tintColor = UIColor.green
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: audioPlayer?.currentItem)
        self.audioPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.audioPlayer!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.audioPlayer!.currentTime());
                self.slider!.value = Float ( time );
            }
        }
        self.audioPlayer?.play()
        self.controlButton.setImage(self.pauseImage, for: .normal)
        self.controlButton.isSelected = true

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()

    }

    
    @IBAction func sliderChange(_ sender: UISlider) {
        let seconds : Int64 = Int64(slider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
                
        self.audioPlayer!.seek(to: targetTime)
    }
    @IBAction func playButton(_ sender: UIButton) {
            if controlButton.isSelected {
                controlButton.isSelected = false
                print(sender.isSelected)
                controlButton.setImage(self.playImage, for: .normal)
                self.audioPlayer?.pause()
            }
            else {
                controlButton.isSelected = true
                print(sender.isSelected)
                controlButton.setImage(self.pauseImage, for: .normal)
                self.audioPlayer?.play()
            }
        }
    

    
    func setupUI() {        
        self.titleLabel.text = musics?[indexSound!].title
        self.artistLabel.text = musics?[indexSound!].title

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
               if let musicURL = URL(string: self.musics?[self.indexSound!].preview ?? "") {
                   let playerItem = AVPlayerItem(url: musicURL)
                   
                   
                   
                   self.audioPlayer?.pause()
                   self.audioPlayer = nil
                   
                   self.audioPlayer = AVPlayer(playerItem: playerItem)
               }

               
               NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: audioPlayer?.currentItem)
               
               self.audioPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
                   if self.audioPlayer!.currentItem?.status == .readyToPlay {
                       let time : Float64 = CMTimeGetSeconds(self.audioPlayer!.currentTime());
                       self.slider!.value = Float ( time );
                   }
               }

               audioPlayer?.play()
               self.controlButton.isSelected = true
               self.controlButton.setImage(self.pauseImage, for: .normal)
               self.slider.value = 0
           }
       }
}
