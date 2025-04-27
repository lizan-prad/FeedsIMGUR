import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var posts: [PostModel] = []
    private let service = HomeService()

    // Loads posts from the service
    func loadPosts() {
        service.fetchPosts { [weak self] posts in
            DispatchQueue.main.async {
                self?.posts = posts
            }
        }
    }
}
