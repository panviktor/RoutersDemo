//
//  AppRouter.swift
//  RoutersDemo
//
//  Created by Itay Amzaleg on 10/03/2024.
//

import Foundation
import SwiftUI

@MainActor
@Observable
class TabsRouter: BaseRouter {

	// A sheet you might present from your tabs:
	var presentedSheet: TabsSheet?

	// Which tab is currently selected
	var selectedTab: TabsView.Tab = .a

	// All child routers for each tab
	var tabARouter = TabARouter()
	var tabBRouter = TabBRouter()
	var tabCRouter = TabCRouter()
	var tabDRouter = TabDRouter()

	// MARK: - Lifecycle

	override init(parent: BaseRouter? = nil, path: NavigationPath = .init()) {
		super.init(parent: parent, path: path)

		// Each child tab router's parent is `self`
		tabARouter.parent = self
		tabBRouter.parent = self
		tabCRouter.parent = self
		tabDRouter.parent = self
	}

	// MARK: - Deep Link Handling

	/// If you receive a deep link that belongs in the tabs flow, handle it here.
	func handleDeepLink(_ deeplink: DeeplinkManager.DeeplinkType) {
		switch deeplink {
		case .chat:
			// e.g. select tab C, open inbox or chat
			selectedTab = .c
			tabCRouter.navigate(to: .inbox)

		case .transportation(let type):
			// e.g. select tab B, navigate to the transportation route
			selectedTab = .b
			tabBRouter.navigate(to: .transportation(type: type))
		}
	}
}
