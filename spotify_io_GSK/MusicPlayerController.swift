import UIKit

class MusicPlayerController: UIViewController {
    
    var selectedMusic: Music?
    
    var musicTitle: String?
    var musicImage: URL?
    var titleLabel: UILabel!
    var imageView: UIImageView!
    
    var slider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupUI()
    }

    func displaySliderValue(_ sender: UISlider) {
        let selectedValue = sender.value
    }
    
    func setupUI() {
        titleLabel = UILabel()
        titleLabel.text = selectedMusic?.title
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 30)
        view.addSubview(titleLabel)

        imageView = UIImageView()
        if let imageUrl = selectedMusic?.image {
            imageView.downloaded(from: imageUrl)
        }
        imageView.frame = CGRect(x: (view.frame.size.width - 300) / 2, y: 100, width: 300, height: 300)
        view.addSubview(imageView)
    }
}
