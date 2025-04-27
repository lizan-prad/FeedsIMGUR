import SwiftUI

struct HomeFeedCell: View {
    let post: PostModel
    let isFocused: Bool  // Whether this cell is the most focused
    var onVisibilityChanged: (UUID, CGFloat) -> Void  // Callback when visibility changes

    var body: some View {
        GeometryReader { geo in
            VStack {
                ForEach(post.media.indices, id: \.self) { index in
                    switch post.media[index] {
                    case .image(let url):
                        CachedImageView(url: url)
                            .frame(height: 300)
                            .cornerRadius(12)

                    case .video(let url):
                        VideoPlayerView(url: url, isVisible: .constant(isFocused))
                            .frame(height: 300)  // Video auto-plays if focused
                    }
                }
            }
            .background(
                Color.clear
                    .onAppear { updateVisibility(geo: geo) }  // Initial visibility check
                    .onChange(of: geo.frame(in: .global)) { _, _ in
                        updateVisibility(geo: geo)  // Update visibility when scrolled
                    }
            )
        }
        .frame(height: 320)
    }

    // Calculates visible percentage and informs parent view
    private func updateVisibility(geo: GeometryProxy) {
        let screenHeight = UIScreen.main.bounds.height
        let frame = geo.frame(in: .global)
        let visibleHeight = max(0, min(frame.maxY, screenHeight) - max(frame.minY, 0))
        let percentage = visibleHeight / frame.height
        onVisibilityChanged(post.id, percentage)
    }
}
