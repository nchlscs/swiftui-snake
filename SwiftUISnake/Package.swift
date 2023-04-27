// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to
// build this package.

import PackageDescription

let package = Package(
  name: "swiftui-snake",
  platforms: [.macOS(.v11), .iOS(.v14)],
  products: [
    .library(
      name: "SwiftUISnake",
      targets: ["SwiftUISnake"]
    ),
  ],
  targets: [
    .target(
      name: "SwiftUISnake",
      dependencies: []
    ),
    .executableTarget(
      name: "SwiftUISnakeExecutable",
      dependencies: ["SwiftUISnake"]
    ),
    .testTarget(
      name: "SwiftUISnakeTests",
      dependencies: ["SwiftUISnake"]
    ),
  ]
)
