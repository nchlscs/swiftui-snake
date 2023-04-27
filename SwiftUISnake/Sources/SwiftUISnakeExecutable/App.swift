import SwiftUI
import SwiftUISnake

@main
struct SnakeGameApp: App {

  var body: some Scene {
    WindowGroup {
      GameView(configuration: .init(
        canvasSize: .init(width: 512, height: 512),
        snakeSize: 16,
        speed: 0.1
      ))
      .navigationTitle("Snake")
    }
  }
}
