import SwiftUI
import AVKit

// SwiftUI view for playing a video
struct VideoPlayerView: View {
    let url: URL
    @Binding var isVisible: Bool
    @StateObject private var viewModel = VideoPlayerViewModel()

    var body: some View {
        VideoPlayer(player: viewModel.player)
            .cornerRadius(12)
            .onAppear {
                viewModel.setupPlayer(with: url)
            }
            .onChange(of: isVisible) { newValue, _ in
                !newValue ? viewModel.play() : viewModel.pause() // Play/pause based on visibility
            }
            .onDisappear {
                viewModel.pause()
            }
    }
}

// ViewModel managing AVPlayer instance
class VideoPlayerViewModel: ObservableObject {
    let player = AVPlayer()

    // Set up the player with a given video URL
    func setupPlayer(with url: URL) {
        guard (player.currentItem?.asset as? AVURLAsset)?.url != url else { return }
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
    }

    // Play the video if not already playing
    func play() {
        if player.timeControlStatus != .playing {
            player.play()
        }
    }

    // Pause the video if currently playing
    func pause() {
        if player.timeControlStatus == .playing {
            player.pause()
        }
    }
}
