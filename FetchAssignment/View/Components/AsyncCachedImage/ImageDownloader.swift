import SwiftUI

class ImageDownloader: Downloader {
    typealias Item = Image
    var taskCache: DownloadTaskCache<Image> = .init()
    static let shared: ImageDownloader = .init()
    
    private init() {}
}


