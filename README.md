# BaseRouter for SwiftUI

A powerful, observable navigation management system that provides centralized routing, consistent logging, and state management for SwiftUI applications.

## 🌟 Why BaseRouter?

Modern SwiftUI applications often involve complex navigation flows - from authentication to onboarding, tabbed interfaces to nested modal presentations. While SwiftUI's `NavigationPath` provides the foundation for navigation state management, coordinating these flows across a large application presents several challenges:

### Challenges in SwiftUI Navigation

1. **State Management**: Navigation state can become scattered across views, making it difficult to track the current navigation stack.
2. **Debugging**: Understanding navigation flows during development and troubleshooting requires consistent, comprehensive logging.
3. **Code Organization**: Different flows (login, onboarding, main content) need clear separation while maintaining a consistent pattern.

BaseRouter addresses these challenges through a unified, observable navigation system.

## 🎯 Core Features

### 1. Centralized Navigation State

BaseRouter uses SwiftUI's `NavigationPath` as a single source of truth for navigation state, ensuring consistency across your application:

```swift
@MainActor
@Observable class BaseRouter {
    // Parent reference for nested navigation
    weak var parent: BaseRouter?
    
    // Core navigation state
    var path: NavigationPath
    
    // Quick state check
    var isEmpty: Bool { path.isEmpty }
}
```

### 2. Comprehensive Logging System

Built-in logging provides visibility into your application's navigation flow:

```swift
enum RouterLogger {
    enum Level: String {
        case info = "ℹ️"
        case navigation = "🟢"
        case state = "📱"
        case error = "⚠️"
        case lifecycle = "🔄"
    }
    
    static func log(_ message: String,
                    level: Level = .info,
                    router: String,
                    function: String = #function) {
        let timestamp = DateFormatter.localizedString(
            from: Date(),
            dateStyle: .none,
            timeStyle: .medium
        )
        print("\(level.rawValue) [\(timestamp)] [\(router)] \(function): \(message)")
    }
}
```

Example log output:
```
🔄 [TabARouter] Opened (created) with parent: Optional(RootRouter)
📱 [TabARouter] Path changed: viewOne → viewTwo
⚠️ [TabARouter] Attempted to navigate back on empty path
```

### 3. Automatic State Observation

Leverages Swift's modern observation system to react to navigation changes:

```swift
private func observeChanges() {
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
```

### 4. Clean Navigation API

Simple, intuitive navigation methods with built-in safety checks:

```swift
extension BaseRouter {
    func navigateBack() {
        guard !isEmpty else {
            RouterLogger.log("Attempted to navigate back on empty path",
                             level: .error,
                             router: routerName)
            return
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
}
```

## 🚀 Implementation Guide

### Creating Flow-Specific Routers

Extend BaseRouter for different navigation flows in your application:

```swift
@MainActor
@Observable final class RootRouter: BaseRouter {
    enum Destination: String, RouterDestination {
        case splash
        case onboarding
        case tabs
    }
    
    // Current global destination
    private(set) var destination: Destination = .splash
    
    // Child routers
    let splashRouter: SplashRouter
    let tabsRouter: TabsRouter
    
    override init(parent: BaseRouter? = nil, path: NavigationPath = .init()) {
        splashRouter = SplashRouter()
        tabsRouter = TabsRouter()
        super.init(parent: parent, path: path)
        
        // Set parent relationships after initialization
        splashRouter.parent = self
        tabsRouter.parent = self
    }

    func setDestination(_ destination: Destination) {
		    self.destination = destination
	  }
}
```

### Integrating with SwiftUI Views

Connect your router to SwiftUI navigation:

```swift
struct RootView: View {
	@Environment(RootRouter.self) private var router

	var body: some View {
		switch router.destination {
		case .splash:
			SplashView()
				.environmentObject(router.splashRouter)  // Must match @EnvironmentObject type
		case .tabs:
			TabsView()
				.environmentObject(router.tabsRouter)  // Must match @EnvironmentObject type
		}
	}
}
```

## 🔍 Advanced Features

### Deep Linking Support

BaseRouter can handle deep linking through a hierarchical router structure:

```swift
extension RootRouter {
    func handleDeepLink(_ deeplink: DeeplinkManager.DeeplinkType) {
        // Navigate to the appropriate tab
        setDestination(.tabs)
        // Forward the deep link to the tabs router
        tabsRouter.handleDeepLink(deeplink)
    }
}
```


## 📊 Benefits

1. **Scalability**: Easily manage complex navigation hierarchies
2. **Maintainability**: Centralized logging and state management
3. **Debugging**: Comprehensive logging system for navigation flows
4. **Type Safety**: Strong typing for navigation destinations

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 💡 Acknowledgments

Built with Swift and SwiftUI, inspired by the need for better navigation management in modern iOS applications. Based on https://github.com/itayAmza/RoutersDemo  
