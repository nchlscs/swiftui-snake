import Observation

@MainActor
@Observable
public final class ViewModel {
  public private(set) var phase = Phase.paused
  public private(set) var direction = Direction.down
  public private(set) var level = 1
  public private(set) var snake = Snake()
  public private(set) var foodPosition = IdentifiablePoint(id: -1, point: .zero)
  public private(set) var canvasSize: Size
  public private(set) var timeFrame = 0

  private var task: Task<Void, any Error>? {
    didSet { oldValue?.cancel() }
  }

  public var score: Int { snake.body.count - 1 }

  public init(canvasSize: Size) {
    self.canvasSize = canvasSize
  }

  public func nextPhase() {
    switch phase {
    case .paused:
      phase = .running
      task = Task {
        defer { task = nil }
        while phase == .running {
          let delay = max(20, 200 - level * 20)
          try await Task.sleep(for: .milliseconds(delay))
          nextTimeFrame()
        }
      }
    case .running:
      phase = .paused
    case .failed:
      phase = .paused
      reset()
    }
  }

  public func nextTimeFrame() {
    guard phase == .running else {
      return
    }
    guard canvasSize.contains(snake.head.point) else {
      phase = .failed
      return
    }
    snake.move(to: direction)
    if snake.head.point == foodPosition.point {
      snake.grow()
      foodPosition.point = randomPosition()
      if score % 5 == 0 {
        level = min(10, level + 1)
      }
    }
  }

  public func setDirection(_ newValue: Direction) {
    guard direction != newValue else {
      return
    }
    guard direction != newValue.opposite else {
      return
    }
    direction = newValue
  }

  public func reset() {
    foodPosition.point = randomPosition()
    snake.place(to: randomPosition())
    let isLeftHalf = snake.head.point.x < canvasSize.width / 2
    let isTopHalf = snake.head.point.y < canvasSize.height / 2
    switch (isLeftHalf, isTopHalf) {
    case (true, true):
      setDirection(Bool.random() ? .down : .right)
    case (true, false):
      setDirection(Bool.random() ? .up : .right)
    case (false, true):
      setDirection(Bool.random() ? .down : .left)
    case (false, false):
      setDirection(Bool.random() ? .up : .left)
    }
  }
}

private extension ViewModel {

  func randomPosition() -> Point {
    var points = [Point]()
    let busyPoints: Set<Point> = snake.body.reduce(
      into: [foodPosition.point]
    ) { points, body in
      points.insert(body.point)
    }

    for column in 0..<canvasSize.width {
      for row in 0..<canvasSize.height {
        let point = Point(x: column, y: row)
        if !busyPoints.contains(point) {
          points.append(point)
        }
      }
    }

    if let point = points.randomElement() {
      return point
    }

    reset()
    nextPhase()
    return .zero
  }
}
