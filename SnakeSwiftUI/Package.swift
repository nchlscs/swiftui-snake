// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to
// build this package.

import PackageDescription

let package = Package(
	name: "SnakeSwiftUI",
	platforms: [.macOS(.v11), .iOS(.v14)],
	products: [
		.library(
			name: "SnakeSwiftUI",
			targets: ["SnakeSwiftUI"]
		)
	],
	targets: [
		.target(
			name: "SnakeSwiftUI",
			dependencies: []
		),
		.executableTarget(
			name: "SnakeSwiftUIExecutable",
			dependencies: ["SnakeSwiftUI"]
		),
		.testTarget(
			name: "SnakeSwiftUITests",
			dependencies: ["SnakeSwiftUI"]
		)
	]
)
