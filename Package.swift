// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-snake",
  platforms: [.macOS(.v14), .iOS(.v14)],
  products: [
    .executable(
      name: "SwiftUISnake",
      targets: ["SwiftUISnake"]
    ),
    .library(
      name: "SnakeGame",
      targets: ["SnakeGame"]
    )
  ],
  targets: [
    .executableTarget(
      name: "SwiftUISnake",
      dependencies: ["SnakeGame"]
    ),
    .target(
      name: "SnakeGame",
      dependencies: []
    ),
  ],
  swiftLanguageModes: [.v6]
)
