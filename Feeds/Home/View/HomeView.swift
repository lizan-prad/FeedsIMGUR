import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var visibilityMap: [UUID: CGFloat] = [:]  // Tracks visibility % of each post
    @State private var focusedPostId: UUID?  // The post currently most visible

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.posts) { post in
                    HomeFeedCell(
                        post: post,
                        isFocused: focusedPostId == post.id  // Tell cell if it's focused
                    ) { id, visibility in
                        visibilityMap[id] = visibility  // Update visibility map when cell reports
                        updateFocusedPost()  // Recalculate which post should be focused
                    }
                    .padding()
                }
            }
        }
        .background(Color.black)  // Background color for ScrollView
        .onAppear {
            viewModel.loadPosts()  // Load posts when view appears
        }
    }

    // Updates which post is the most visible
    private func updateFocusedPost() {
        guard let mostVisible = visibilityMap.max(by: { $0.value < $1.value }) else { return }
        if focusedPostId != mostVisible.key {
            withAnimation(.easeInOut(duration: 0.25)) {
                focusedPostId = mostVisible.key  // Animate focus change
            }
        }
    }
}
