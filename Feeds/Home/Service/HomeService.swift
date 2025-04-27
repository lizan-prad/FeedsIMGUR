import Foundation

class HomeService {
    private let clientID = "509cbddd377291c"  // Imgur API client ID
    
    // Fetches posts from Imgur API
    func fetchPosts(completion: @escaping ([PostModel]) -> Void) {
        let url = URL(string: "https://api.imgur.com/3/gallery/hot/viral/0.json")!
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let dataArray = json["data"] as? [[String: Any]] else {
                completion([])
                return
            }

            let posts = dataArray.compactMap { dict -> PostModel? in
                guard let id = dict["id"] as? String,
                      let link = ((dict["images"] as? [[String: Any]])?.first?["link"] as? String),
                      let url = URL(string: link) else { return nil }
                
                let type = ((dict["images"] as? [[String: Any]])?.first?["type"] as? String) ?? ""
                let media: [MediaType]
                
                // Determine if the media is a video or image
                if type.contains("video") {
                    media = [.video(url)]
                } else if type.contains("image") {
                    media = [.image(url)]
                } else {
                    return nil
                }
                
                return PostModel(media: media)
            }

            completion(posts)
        }.resume()
    }
}
