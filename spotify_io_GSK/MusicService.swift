import Foundation

struct Artist {
    let name: String
}

extension Artist {
    init?(json: [String: AnyObject]) {
        guard let name = json["name"] as? String else {
            return nil
        }
        self.name = name
    }
}


struct Music {
    let title: String
    let urlPage: String
    let image: String
    let artist: Artist
    let preview: String
}

extension Music {
    init?(json: [String: AnyObject]) {
        guard let title = json["title"] as? String,
              let url = json["link"] as? String,
              let image = json["album"]?["cover"] as? String,
              let preview  = json["preview"] as? String,
              let artistJSON = json["artist"] as? [String: AnyObject],
              let artist = Artist(json: artistJSON),
              let _ = json["link"]
                
        else {
            return nil
        }

        self.title = title
        self.urlPage = url
        self.image = image
        self.artist = artist
        self.preview = preview
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
