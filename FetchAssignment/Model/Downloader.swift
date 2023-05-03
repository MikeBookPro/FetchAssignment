import Foundation

protocol Downloader: AnyObject {
    associatedtype Item
    
    var taskCache: DownloadTaskCache<Item> { get }
    
    func item(from url: URL?) async throws -> Item?
    
    static func downloadItem(from url: URL) async throws -> Item
    
    func prefetch(itemsFrom urls: [URL]) throws
        
}

extension Downloader {
    func item(from url: URL?) async throws -> Item? {
        guard let url else { return nil }
        
        if let cachedRequest = await taskCache.previousRequest(for: url) {
            // A task has either been complete or is in progress
            switch cachedRequest {
                case .downloaded(let item): return item
                case .inProgress(let task): return try await task.value
            }
        }
        
        // Register a new task
        let task = Task {
            try await Self.downloadItem(from: url)
        }
        await taskCache.cache(inProgress: task, at: url)

        do {
            let item = try await task.value
            await taskCache.cache(downloaded: item, at: url)
            return item
        } catch {
            await taskCache.clear(cacheAt: url)
            throw error
        }
    }
    
    func prefetch(itemsFrom urls: [URL]) throws {
        Task.detached {
            await withTaskGroup(of: Item?.self, body: { [weak self] taskGroup in
                let weakSelf = self
                urls.forEach { [weakSelf] url in
                    taskGroup.addTask {
                        try? await weakSelf?.item(from: url)
                    }
                }
            })
        }
        
    }
}

extension Downloader where Item: DataInitializable {
    static func downloadItem(from url: URL) async throws -> Item {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let item = Item(data: data) else { throw ItemFetchError.invalidData }
        return item
    }
}

enum ItemFetchError: Error {
    case invalidData
}
