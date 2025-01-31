//
//  TabA.swift
//  RoutersDemo
//
//  Created by Itay Amzaleg on 10/03/2024.
//

import SwiftUI

struct TabA: View {
	typealias Destination = TabARouter.Destination

	private let navigationTitle = TabsView.Tab.a.title
	@Environment(TabARouter.self) private var router

	// MARK: - Views
	var body: some View {
		@Bindable var router = router

		NavigationStack(path: $router.path) {
			listView
				.routerDestination(router: router,
								   destination: navigationDestination)
				.navigationTitle(navigationTitle)
		}
	}

	@ViewBuilder private func navigationDestination(_ destination: Destination) -> some View {
		switch destination {
		case .viewOne:
			ViewOne()
		case .viewTwo:
			ViewTwo()
		}
	}

	private var listView: some View {
		List(Destination.allCases) { destination in
			Text(destination.title)
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
				.contentShape(Rectangle())
				.onTapGesture {
					router.navigate(to: destination)
				}
		}
	}
}
