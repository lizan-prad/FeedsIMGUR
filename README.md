
# Feeds - SwiftUI App for Image and Video Caching

## Overview

`Feeds` is a SwiftUI-based iOS app that allows users to view a collection of posts consisting of images and videos. The app fetches media content from the Imgur API, caches the images and videos, and displays them in a scrollable feed. The app also includes a video player that plays videos when they come into focus and an image cache manager for efficient media loading.

## Project Structure

```
Feeds/
├── FeedsApp.swift                # Main entry point of the app
├── Helper/
│   ├── ImageCacheManager.swift   # Image caching manager using NSCache
│   └── VideoPlayerManager.swift  # Video player manager using AVPlayer
├── Home/
│   ├── Model/
│   │   └── PostModel.swift       # Model for posts containing media
│   ├── Service/
│   │   └── HomeService.swift     # Service to fetch posts from Imgur API
│   ├── View/
│   │   ├── HomeView.swift        # Main feed view for displaying posts
│   │   ├── Cell/
│   │   │   └── HomeFeedCell.swift # View for individual post cells
│   └── ViewModel/
│       └── HomeViewModel.swift   # ViewModel for managing posts
```

## Features

- **Caching**: Caches images and videos for efficient loading. It uses `NSCache` for storing images and plays videos when they come into focus.
- **Lazy Loading**: Lazy loading of posts with the help of SwiftUI's `LazyVStack` for efficient scrolling.
- **Automatic Video Playback**: Videos automatically play when they become visible on the screen and pause when they are not focused.
- **Image and Video Display**: Displays images with caching and videos with a custom player in the feed.

## Installation

1. Clone the repository:

```bash
git clone https://github.com/your-username/Feeds.git
```

2. Open the project in Xcode:

```bash
open Feeds.xcodeproj
```

3. Build and run the project on the simulator or a real device.

## How It Works

### ImageCacheManager

- **ImageCacheManager.swift**: This class is responsible for fetching and caching images from the network. It checks the cache first before downloading from the network. If the image is not cached, it downloads the image asynchronously, saves it in memory cache, and then updates the UI.

### Video Player

- **VideoPlayerView.swift**: A SwiftUI view that uses `AVPlayer` to play videos. The video plays when it becomes visible and pauses when it goes out of view.

### Home View

- **HomeView.swift**: The main screen of the app that displays the feed of posts. It fetches the posts from the service, handles visibility changes, and triggers actions for video playback.

### Post Model

- **PostModel.swift**: This model defines the structure of a post, which includes an array of media (either images or videos).

### Home Service

- **HomeService.swift**: A service to fetch posts from the Imgur API. It processes the JSON response to extract media URLs and their types (image or video).

### Helper Functions

- **ImageCache.swift**: A simple in-memory image cache using `NSCache` to store images for faster retrieval.
- **VideoPlayerManager.swift**: Handles setup and playback of videos, pausing or playing videos based on visibility.

## Usage

1. **Fetching Posts**: The `HomeService` class fetches posts from the Imgur API. It parses the response and returns a list of `PostModel` objects.
   
2. **Displaying Media**: The `HomeFeedCell` view determines if the media is an image or a video and displays it accordingly:
   - Images are displayed using `CachedImageView`.
   - Videos are displayed using `VideoPlayerView`, which automatically plays the video when the cell becomes focused.

3. **Image Caching**: Images are cached using `ImageCacheManager` to ensure that images are loaded quickly without unnecessary network requests.

4. **Video Playback**: The video player plays and pauses videos automatically based on their visibility on the screen using the `VideoPlayerManager`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
