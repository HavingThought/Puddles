import SwiftUI
import Puddles

struct RootNavigator: Navigator {
    @State private var path: [Path] = []

    var root: some View {
        NavigationStack(path: $path) {
            Root(interface: .consume(handleRootAction))
                .navigationDestination(for: Path.self) { path in
                    destination(for: path)
                }
        }
    }

    @MainActor @ViewBuilder
    func destination(for path: Path) -> some View {
        switch path {
        case .page:
            Text("🎉")
                .navigationTitle("It's the answer!")
        }
    }

    func applyTargetState(_ state: TargetState) {
        switch state {
        case .reset:
            path = []
        case .showPage:
            path = [.page]
        case .showDeletionConfirmation:
            // Show deletion confirmation
        }
    }

    @MainActor
    private func handleRootAction(_ action: Root.Action) {
        switch action {
        case .didReachFortyTwo:
            applyTargetState(.showPage)
        case .didTapShowQueryableDemo:
            applyTargetState(.showDeletionConfirmation)
        }
    }
}

extension RootNavigator {
    enum TargetState: Hashable {
        case reset
        case showPage
        case showDeletionConfirmation
    }

    enum Path: Hashable {
        case page
    }
}
