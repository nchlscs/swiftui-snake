import Foundation

public extension GameView {

  struct Configuration {
    public let canvasSize: CGSize
    public let snakeSize: CGFloat
    public let speed: TimeInterval

    public init(
      canvasSize: CGSize,
      snakeSize: CGFloat,
      speed: TimeInterval
    ) {
      self.canvasSize = canvasSize
      self.snakeSize = snakeSize
      self.speed = speed
    }
  }
}
