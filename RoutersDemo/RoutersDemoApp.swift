//
//  RoutersDemoApp.swift
//  RoutersDemo
//
//  Created by Itay Amzaleg on 10/03/2024.
//

import SwiftUI

@main
struct RoutersDemoApp: App {
    @Bindable private var rootRouter = RootRouter()

	var body: some Scene {
		WindowGroup {
			RootView()
				.environment(rootRouter)
				.onReceive(DeeplinkManager.shared.userActivityPublisher) { deeplink in
					rootRouter.handleDeepLink(deeplink)
				}
				.task {
					try? await Task.sleep(for: .seconds(3))
					DeeplinkManager.shared.userActivityPublisher.send(.chat)
				}
		}
	}
}
