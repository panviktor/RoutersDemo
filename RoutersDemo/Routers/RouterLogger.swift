//
//  RouterLogger.swift
//  RoutersDemo
//
//  Created by Viktor on 31.01.2025.
//

import Foundation

enum RouterLogger {
	enum Level: String {
		case info = "ℹ️"
		case navigation = "🔄"
		case state = "📱"
		case error = "⚠️"
		case lifecycle = "🎯"
	}

	static func log(_ message: String, level: Level = .info, router: String, function: String = #function) {
		print("\(level.rawValue) [\(router)] \(message)")
	}

	static func getRouterName(_ router: Any) -> String {
		String(describing: type(of: router))
	}
}
