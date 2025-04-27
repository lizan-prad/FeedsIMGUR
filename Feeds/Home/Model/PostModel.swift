import Foundation

// Model representing a single post
struct PostModel: Identifiable {
    let id = UUID()
    let media: [MediaType]
}

// Enum for different types of media
enum MediaType {
    case image(URL)
    case video(URL)
}
