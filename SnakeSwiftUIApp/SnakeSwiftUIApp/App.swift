import SnakeSwiftUI
import SwiftUI

@main
struct SnakeGameApp: App {

	var body: some Scene {
		WindowGroup {
			GeometryReader { proxy in
				GameView(configuration: .init(
					canvasSize: proxy.size,
					snakeSize: proxy.size.width / 32,
					speed: 0.1
				))
			}
			.navigationTitle("Snake")
			#if os(macOS)
				.frame(width: 512, height: 512)
			#endif
		}
	}
}
