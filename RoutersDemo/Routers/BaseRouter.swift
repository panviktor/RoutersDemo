//
//  BaseRouter.swift
//  RoutersDemo
//
//  Created by Itay Amzaleg on 10/03/2024.
//

import SwiftUI

@MainActor
@Observable class BaseRouter {
	// Parent reference: nil if this is the root
	weak var parent: BaseRouter?
	// Simple SwiftUI path to track navigation
	var path: NavigationPath

	var isEmpty: Bool {
		return path.isEmpty
	}

	@ObservationIgnored
	var currentDestination: (any RouterDestination)? {
		return decodedPath?.last
	}

	@ObservationIgnored
	var routerDestinationTypes: [any RouterDestination.Type] {
		fatalError("BaseRouter: must override routerDestinationTypes in subclass")
	}

	@ObservationIgnored
	private lazy var decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.userInfo = [.routerDestinationTypes: routerDestinationTypes]
		return decoder
	}()

	@ObservationIgnored
	private var decodedPath: [any RouterDestination]? {
		guard let codableRepresentation = path.codable,
			  let data = try? JSONEncoder().encode(codableRepresentation),
			  let decodedRepresentation = try? decoder.decode(RouterDestinationDecoder.self, from: data) else {
			return nil
		}
		return decodedRepresentation.path
	}

	init(parent: BaseRouter? = nil, path: NavigationPath = .init()) {
		self.parent = parent
		self.path = path
		RouterLogger.log("🎉 Opened (created) with parent: \(String(describing: parent))",
						level: .lifecycle,
						router: routerName)
		observeChanges()
	}

	deinit {
		// Use the non-isolated version of router name
		let name = RouterLogger.getRouterName(self)
		RouterLogger
			.log(
				"🛑 Closed (deinitialized)",
				level: .lifecycle,
				router: name
			)
	}

	func didChange() {
		let cleanPath = cleanPathDescription(path)
		RouterLogger.log("➡️ Path changed: \(cleanPath) ⬅️",
						level: .state,
						router: routerName)
	}

	func trackableProperties() {
		let _ = path
	}
}

// MARK: - Navigation Methods
extension BaseRouter {
	func navigateBack() {
		guard !isEmpty else {
			RouterLogger.log("Attempted to navigate back on empty path",
						   level: .error,
						   router: routerName)
			return
		}

		if let currentDest = currentDestination {
			RouterLogger.log("Navigating back from \(String(describing: currentDest))",
						   level: .navigation,
						   router: routerName)
		}

		path.removeLast()
		logState()
	}

	func popToRoot() {
		RouterLogger.log("Popping to root from path with \(path.count) items",
						level: .navigation,
						router: routerName)
		path.removeLast(path.count)
		logState()
	}

	func contains(_ item: any RouterDestination) -> Bool {
		guard let decodedPath else {
			RouterLogger.log("Failed to decode path while checking for item: \(item.id)",
						   level: .error,
						   router: routerName)
			return false
		}

		let contains = decodedPath.contains(where: { $0.id == item.id })
		RouterLogger.log("Checked for item \(item.id) in path - found: \(contains)",
						level: .info,
						router: routerName)
		return contains
	}
}

// MARK: - Private Helpers
private extension BaseRouter {
	func observeChanges() {
		withObservationTracking {
			trackableProperties()
		} onChange: { [weak self] in
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
				guard let self = self else {
					RouterLogger.log("Router was deallocated during observation",
								   level: .error,
								   router: "Unknown")
					return
				}
				self.didChange()
				self.observeChanges()
			}
		}
	}

	
	var routerName: String {
		String(describing: type(of: self))
	}

	func cleanPathDescription(_ path: NavigationPath) -> String {
		if let decodedItems = decodedPath {
			return decodedItems.map { String(describing: $0) }.joined(separator: " → ")
		}
		return path.count == 0 ? "empty" : "items[\(path.count)]"
	}

	func logNavigation(action: String, destination: Any? = nil) {
		let destinationInfo = destination.map { String(describing: $0) } ?? "none"
		RouterLogger.log("Navigation \(action) -> \(destinationInfo)",
						level: .navigation,
						router: routerName)
	}

	func logState() {
		let pathDescription = cleanPathDescription(path)
		RouterLogger.log("Current path: [\(pathDescription)]",
						level: .state,
						router: routerName)
	}
}
