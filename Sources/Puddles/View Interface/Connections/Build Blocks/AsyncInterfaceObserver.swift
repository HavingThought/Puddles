import SwiftUI

public struct AsyncInterfaceObserver<Action, I: Interface<Action>>: InterfaceDescription {

    var interface: I
    var actionHandler: @Sendable (_ action: Action) async -> Void

    public init(
        _ interface: I,
        actionHandler: @Sendable @escaping (_ action: Action) async -> Void
    ) {
        self.interface = interface
        self.actionHandler = actionHandler
    }
}

public extension AsyncInterfaceObserver {

    @MainActor
    var body: some View {
        Color.clear
            .onReceive(interface.actionPublisher) { action in
                Task {
                    await actionHandler(action)
                }
            }
    }
}
