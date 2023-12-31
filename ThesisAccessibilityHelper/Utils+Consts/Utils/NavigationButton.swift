import SwiftUI
// https://stackoverflow.com/questions/58897453/how-to-perform-an-action-after-navigationlink-is-tapped

struct NavigationButton<Destination: View, Label: View>: View {
    var delay: TimeInterval = .zero
    var action: () -> Void = { }
    var destination: () -> Destination
    var label: () -> Label

    @State private var isActive = false

    var body: some View {
        Button(action: {
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + delay) {
                self.action()
                self.isActive.toggle()
            }
        }) {
            self.label()
                .background(
                    ScrollView { // Fixes a bug where the navigation bar may become hidden on the pushed view
                        NavigationLink(destination: LazyDestination { self.destination() }, isActive: self.$isActive) { EmptyView() }
                    }
                )
        }
    }
}

// This view lets us avoid instantiating our Destination before it has been pushed.
struct LazyDestination<Destination: View>: View {
    var destination: () -> Destination
    var body: some View {
        self.destination()
    }
}
