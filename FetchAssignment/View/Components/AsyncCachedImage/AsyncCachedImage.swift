import SwiftUI

struct AsyncCachedImage<Content: View>: View {
    private let url: URL?
    private let placeholder: Image
    private let imageModifiers: (Image) -> Content
    @State private var image: Image?
    
    init(url: URL?, placeholder: Image, @ViewBuilder imageModifiers: @escaping (Image) -> Content) {
        self.url = url
        self.placeholder = placeholder
        self.imageModifiers = imageModifiers
    }
    
    private func contentView(image: Image?) -> some View {
        imageModifiers(image ?? placeholder)
    }
    
    var body: some View {
        contentView(image: self.image)
            .onAppear {
                Task {
                    guard let image = try? await ImageDownloader.shared.item(from: url) else { return }
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
    }
}

#if DEBUG
struct AsyncCachedImage_Previews: PreviewProvider {
    static let url = URL(string: "https://www.themealdb.com/images/media/meals/qstyvs1505931190.jpg")
    static let image = Image(systemName: "carrot")
    static var previews: some View {
        AsyncCachedImage(url: url, placeholder: image) { image in
            image.resizable()
        }
    }
}
#endif
