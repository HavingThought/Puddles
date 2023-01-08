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

struct Root: Coordinator {
    @EnvironmentObject private var services: Services
	@StateObject private var interface: Interface<Home.Action> = .init()

    @State private var points: LoadingState<[Event], Never> = .loaded(.repeating(.random, count: 5))
    @State private var searchResults: LoadingState<[Event], Never> = .initial

	var entryView: some View {
		Home(interface: interface, points: points, searchResults: searchResults)
	}

    func interfaces() -> some InterfaceDescription {
        AsyncInterfaceObserver(interface) { action in
            await handleViewAction(action)
        }
    }

	func navigation() -> some NavigationPattern {

	}

	func handleViewAction(_ action: Home.Action) async {
		switch action {
		case .searchEvents(let query):
            searchResults = .loading
            let events = try! await services.events.searchEvents(query: query)
            searchResults = .loaded(events)

		}
	}

}
