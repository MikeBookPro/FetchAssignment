import Foundation
import SwiftUI
import UIKit

protocol DataInitializable {
    init?(data: Data)
}

extension Image: DataInitializable {
    init?(data: Data) {
        guard let uiImage = UIImage(data: data) else { return nil }
        self = Image(uiImage: uiImage)
    }
}
