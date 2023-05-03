import Foundation
import SwiftUI

/// Code based off example from WWDC '21 Video [Protect mutable state with Swift actors](https://developer.apple.com/wwdc21/10133)
actor DownloadTaskCache<Item> {
    enum CacheEntry {
        case inProgress(Task<Item, Error>)
        case downloaded(Item)
    }
    
    private var cache: [URL: CacheEntry] = [:]
    
    func previousRequest(for url: URL) async -> CacheEntry? { cache[url] }
    
    func cache(inProgress task: Task<Item, Error>, at url: URL) {
        cache[url] = .inProgress(task)
    }
    
    func cache(downloaded item: Item, at url: URL) {
        cache[url] = .downloaded(item)
    }
    
    func clear(cacheAt url: URL) {
        cache[url] = nil
    }
}
