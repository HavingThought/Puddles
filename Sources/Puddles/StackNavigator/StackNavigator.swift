//
//  Copyright © 2023 Dennis Müller and all collaborators
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

@available(iOS 16, macOS 13.0, *)
public protocol StackNavigator: View {
    associatedtype Root: Coordinator
    associatedtype Path: Hashable
    associatedtype PathDestination: View

    @MainActor var root: Root { get }
    @MainActor var navigationPath: Binding<[Path]> { get }

    @MainActor func initialPath(for url: URL) -> [Path]?
    @MainActor func handleDeepLink(_ deepLink: URL) async

    @MainActor @ViewBuilder func destination(for path: Path) -> PathDestination

}

@available(iOS 16, macOS 13.0, *)
public extension StackNavigator {

    @MainActor var body: some View {
        StackNavigatorBody<Self>(
            root: root,
            destinationForPathHandler: { path in
                destination(for: path)
            },
            navigationPath: navigationPath
        ) { url in
            await handleDeepLink(url)
        } initialPathHandler: { url in
            initialPath(for: url)
        }
    }
}

@available(iOS 16, macOS 13.0, *)
public extension StackNavigator {

    @MainActor func initialPath(for url: URL) -> [Path]? {
        return nil
    }

    @MainActor func handleDeepLink(_ deepLink: URL) async {}
}

