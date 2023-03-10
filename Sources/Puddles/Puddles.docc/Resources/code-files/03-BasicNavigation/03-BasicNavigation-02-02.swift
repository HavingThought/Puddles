import SwiftUI
import Puddles

struct RootNavigator: Navigator {
    @State private var path: [Path] = []

    var root: some View {
        NavigationStack(path: $path) {
            Root(interface: .consume(handleRootAction))
        }
    }

    func applyStateConfiguration(_ configuration: StateConfiguration) {
        switch configuration {
        case .reset:
            path = []
        case .showPage:
            path = [.page]
        }
    }

    @MainActor
    private func handleRootAction(_ action: Root.Action) {
        switch action {
        case .didReachFortyTwo:
            applyStateConfiguration(.showPage)
        }
    }
}

extension RootNavigator {
    enum StateConfiguration: Hashable {
        case reset
        case showPage
    }

    enum Path: Hashable {
        case page
    }
}
