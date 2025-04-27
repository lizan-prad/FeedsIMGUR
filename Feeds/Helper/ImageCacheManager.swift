//
//  ImageCacheManager.swift
//  Feeds
//
//  Created by Lizan on 27/04/2025.
//

import UIKit
import SwiftUI

// Manager to fetch and cache images manually
class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    // Fetch image from cache or network
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let key = url.absoluteString as NSString
        
        if let cachedImage = cache.object(forKey: key) {
            completion(cachedImage)
            return
        }
        
        // Download image if not cached
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.cache.setObject(image, forKey: key)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}

// SwiftUI view for displaying a cached image
struct CachedImageView: View {
    let url: URL

    var body: some View {
        if let uiImage = ImageCache.shared.image(forKey: url.absoluteString) {
            // Use cached image if available
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            // Otherwise download with AsyncImage
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .onAppear {
                            // Save to cache after successful download
                            ImageCache.shared.set(image: image.asUIImage(), forKey: url.absoluteString)
                        }
                case .failure:
                    Color.gray
                @unknown default:
                    Color.gray
                }
            }
        }
    }
}

// Simple in-memory image cache using NSCache
class ImageCache {
    static let shared = ImageCache()
    private var cache: NSCache<NSString, UIImage> = NSCache()

    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func set(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

// Extension to convert SwiftUI Image into UIKit UIImage
extension Image {
    func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self.resizable().scaledToFill())
        let view = controller.view

        let targetSize = CGSize(width: 300, height: 300)
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: view?.bounds ?? .zero, afterScreenUpdates: true)
        }
    }
}
