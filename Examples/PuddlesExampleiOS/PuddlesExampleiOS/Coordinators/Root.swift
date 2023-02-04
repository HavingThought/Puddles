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

import SwiftUI
import Puddles
import AsyncAlgorithms

enum Path: Hashable {
    case target2
    case target3(number: String, path: [Path2])
}

struct Root: CoordinatorStack {
    @State private var actualPath: [Path] = []

    var path: Binding<[Path]> {
        $actualPath
    }

    var root: some Coordinator {
        DeepLinkTarget1(path: $actualPath)
    }

    func viewForDestination(_ destination: Path) -> some View {
        switch destination {
        case .target2:
            DeepLinkTarget2(path: $actualPath)
        case .target3(let number, let otherPath):
            DeepLinkTarget3(number: number, path: $actualPath)
        }
    }


    func deepLinkOnAppear(url: URL) {

    }
    
    func handleDeeplink(url: URL) async {
        actualPath = [.target2, .target3(number: url.absoluteString, path: [])]
//        try! await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
//        actualPath = [.target2, .target3(number: "42", path: [])]
    }
}
