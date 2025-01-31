//
//  RootRouter.swift
//  RoutersDemo
//
//  Created by Viktor on 29.01.2025.
//

import SwiftUI

@MainActor
@Observable
final class RootRouter: BaseRouter {

	enum Destination: String, RouterDestination, CaseIterable {
		case splash
		case onbordoing
		case tabs
	}

	// Example "global" destination
	private(set) var destination: Destination = .splash

	// Child routers
	let splashRouter: SplashRouter
	let tabsRouter: TabsRouter

	override init(parent: BaseRouter? = nil, path: NavigationPath = .init()) {
		// Initialize child routers
		// (We pass `self` as parent in a second stage if we want to.)
		splashRouter = SplashRouter()
		tabsRouter = TabsRouter()

		super.init(parent: parent, path: path)

		// Now that super.init is complete, set each child's parent
		splashRouter.parent = self
		tabsRouter.parent = self
	}

	// Simple method to set destination
	func setDestination(_ destination: Destination) {
		self.destination = destination
	}


	override func trackableProperties() {
		super.trackableProperties()
		let _ = destination
	}

	/// Customize logging or side effects on changes
	override func didChange() {
		// For example, log path + the destination
		print("➡️ RootRouter changed: path = \(path), destination = \(destination) ⬅️")
	}

	// Example for deep link handling
	func handleDeepLink(_ deeplink: DeeplinkManager.DeeplinkType) {
		// In this example, any deep link we have goes to the `.tabs` flow.
		setDestination(.tabs)
		// Then forward the link to the tabsRouter
		tabsRouter.handleDeepLink(deeplink)
	}
}

extension BaseRouter {
	var rootRouter: RootRouter? {
		if let parent = parent {
			return parent.rootRouter
		} else {
			return self as? RootRouter
		}
	}
}

enum RootSheet: String, Identifiable {
	case viewA
	case viewB
	var id: String { self.rawValue }
}
