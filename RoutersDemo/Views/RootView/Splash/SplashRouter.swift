//
//  SplashRouter.swift
//  RoutersDemo
//
//  Created by Viktor on 29.01.2025.
//

import SwiftUI

@MainActor
@Observable
final class SplashRouter: BaseRouter {
	enum Destination: String, RouterDestination {
		case onbordoing
		case login
		case tabs
	}

	func navigate(to destination: Destination) {
		switch destination {
		case .onbordoing:
			print("Go to onboard screen…")
		case .login:
			print("Go to login…")
		case .tabs:
			rootRouter?.setDestination(.tabs)
		}
	}
}
