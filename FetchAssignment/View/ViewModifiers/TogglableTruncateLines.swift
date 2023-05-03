import SwiftUI

struct TogglableTruncateLines: ViewModifier {
    @State private var isTruncated: Bool
    var lineLimit: Int

    init(lineLimit: Int) {
        self.lineLimit = lineLimit
        self._isTruncated = State(initialValue: true)
    }

    func body(content: Content) -> some View {
        content
            .lineLimit(isTruncated ? lineLimit : nil)
            .onTapGesture {
                withAnimation {
                    isTruncated.toggle()
                }
            }
    }
}

extension View {
    func togglableTruncateLines(_ lineLimit: Int) -> some View {
        self.modifier(TogglableTruncateLines(lineLimit: lineLimit))
    }
}

struct ContentView: View {
    var body: some View {
        Text("This is a long text that should be truncated after a certain number of lines. When you tap on the text, it will toggle between showing the full text and the truncated version.")
            .togglableTruncateLines(2)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
