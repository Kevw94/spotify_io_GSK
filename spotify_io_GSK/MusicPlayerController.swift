import UIKit

class MusicPlayerController: UIViewController {
    @IBOutlet weak var imgAlbumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var slider: UISlider!

    
    var selectedMusic: Music?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()

    }

    @IBAction func sliderAction(_ sender: Any) {
    }
    
    func setupUI() {

        //titleLabel.textAlignment = .center
        //titleLabel.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 30)
        //view.addSubview(titleLabel)
        self.titleLabel.text = selectedMusic?.title
        self.artistLabel.text = selectedMusic?.title

        
        //imageView = UIImageView()
        if let imageUrl = selectedMusic?.image {
          imgAlbumCover.downloaded(from: imageUrl)
        }
    }
}
