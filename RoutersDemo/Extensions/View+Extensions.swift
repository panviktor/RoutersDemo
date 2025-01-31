//
//  View+Extensions.swift
//  RoutersDemo
//
//  Created by Itay Amzaleg on 10/03/2024.
//

import SwiftUI

extension View {

    func routerDestination<D, C>(router: BaseRouter,
                                 @ViewBuilder destination: @escaping (D) -> C) -> some View where D : Hashable, C : View {
        navigationDestination(for: D.self) { item in
            destination(item)
        }
    }
}
