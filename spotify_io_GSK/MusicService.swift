import Foundation

struct Music {
    var title: String
    let urlPage: String
    var image: String
}

extension Music {
    init?(json: [String: AnyObject]) {
        guard let title = json["title"] as? String,
              let url = json["link"] as? String,
              let image = json["album"]?["cover"] as? String
        else {
            return nil
        }

        self.title = title
        self.urlPage = url
        self.image = image
    }
}

class MusicService {
    func fetchMusic(completion: @escaping ([Music]?, Error?) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://api.deezer.com/search?q=a")!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil, error)
                return
            }

            var songs: [Music] = []

            if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: AnyObject],
               let items = json["data"] as? [[String: AnyObject]] {
                for item in items {
                    if let music = Music(json: item) {
                        songs.append(music)
                    }
                }
                completion(songs, nil)
            } else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse data"]))
            }
        }
        task.resume()
    }
}
