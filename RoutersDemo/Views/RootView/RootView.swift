//
//  RootView.swift
//  RoutersDemo
//
//  Created by Viktor on 29.01.2025.
//

import SwiftUI

struct RootView: View {

	@Environment(RootRouter.self) private var router

	var body: some View {
		switch router.destination {
		case .splash:
			SplashView()
				.environment(router.splashRouter)
		case .onbordoing:
			OnboardningView()
		case .tabs:
			TabsView()
				.environment(router.tabsRouter)
		}
	}
}

#Preview {
    RootView()
}
