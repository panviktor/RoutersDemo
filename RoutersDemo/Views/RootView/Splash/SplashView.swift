//
//  SplashView.swift
//  RoutersDemo
//
//  Created by Viktor on 29.01.2025.
//

import SwiftUI

struct SplashView: View {

	@Environment(SplashRouter.self) private var router

	var body: some View {
		Text("SplashView")
			.onTapGesture {
				router.navigate(to: .tabs) 
			}
	}
}

#Preview {
    SplashView()
}
