//
//  EnvironmentValues+Extensions.swift
//  RoutersDemo
//
//  Created by Itay Amzaleg on 10/03/2024.
//

import SwiftUI

struct CurrentTabKey: EnvironmentKey {
	static let defaultValue: Binding<TabsView.Tab> = .constant(.a)
}

struct PresentedSheetKey: EnvironmentKey {
    static let defaultValue: Binding<TabsSheet?> = .constant(nil)
}

@MainActor
struct InboxRouterRouterKey: @preconcurrency EnvironmentKey {
	static let defaultValue: any InboxNavigationProtocol = TabCRouter()
}

extension EnvironmentValues {
    var currentTab: Binding<TabsView.Tab> {
        get { self[CurrentTabKey.self] }
        set { self[CurrentTabKey.self] = newValue }
    }
    
    var inboxRouter: any InboxNavigationProtocol {
        get { self[InboxRouterRouterKey.self] }
        set { self[InboxRouterRouterKey.self] = newValue }
    }
    
    var presentedSheet: Binding<TabsSheet?> {
        get { self[PresentedSheetKey.self] }
        set { self[PresentedSheetKey.self] = newValue }
    }
}
