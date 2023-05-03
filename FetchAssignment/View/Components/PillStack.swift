import SwiftUI

struct PillStack<Element: Hashable,Content: View>: View {
    private let items: [Element]
    private let axis: Axis.Set
    private let spacing: CGFloat
    private let content: (Element) -> Content
    
    private func itemContent(item: Element) -> some View {
        content(item)
    }
    
    @ViewBuilder
    private static func stack(axis: Axis.Set, spacing: CGFloat = 10.0, @ViewBuilder _ content: () -> some View) -> some View {
        if axis == .horizontal {
            LazyHStack(spacing: spacing) {
                content()
            }
        } else {
            LazyVStack(spacing: spacing) {
                content()
            }
        }
    }
    
    init(items: [Element], axis: Axis.Set = .horizontal, spacing: CGFloat = 8.0, @ViewBuilder _ content: @escaping (Element) -> Content) {
        self.items = items
        self.axis = axis
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        ScrollView(self.axis, showsIndicators: false) {
            Self.stack(axis: self.axis) {
                ForEach(items, id: \.self) { item in
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.blue)
                        itemContent(item: item)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct PillStack_Previews: PreviewProvider {
    static let labels: [String] = ["one", "two", "three"]
    static var previews: some View {
        PillStack(items: labels) { label in
            Text(label)
                .font(.caption2)
                .foregroundColor(.white)
                .padding()
                .scaledToFit()
        }
    }
}
#endif
