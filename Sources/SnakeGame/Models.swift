public enum Phase {
  case paused
  case running
  case failed
}

public struct Point: Hashable {
  public var x: Int
  public var y: Int

  public init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

extension Point {
  static var zero: Point { Point(x: 0, y: 0) }
}

public struct IdentifiablePoint: Identifiable {
  public let id: Int
  public var point: Point

  init(id: Int, point: Point = Point.zero) {
    self.id = id
    self.point = point
  }
}

public struct Size: Hashable {
  public var width: Int
  public var height: Int

  public init(width: Int, height: Int) {
    self.width = width
    self.height = height
  }
}

extension Size {

  func contains(_ point: Point) -> Bool {
    (0..<width) ~= point.x && (0..<height) ~= point.y
  }
}

public enum Direction {
  case up, down, left, right
}

extension Direction {

  var opposite: Direction {
    switch self {
    case .up: .down
    case .down: .up
    case .left: .right
    case .right: .left
    }
  }
}

public struct Snake {

  public private(set) var body = [IdentifiablePoint(id: 0)]

  private(set) var head: IdentifiablePoint {
    get { body[0] }
    set { body[0] = newValue }
  }

  mutating func place(to position: Point) {
    body = [.init(id: 0, point: position)]
  }

  mutating func move(to direction: Direction) {
    var previous = head.point

    switch direction {
    case .up: head.point.y -= 1
    case .down: head.point.y += 1
    case .left: head.point.x -= 1
    case .right: head.point.x += 1
    }

    for index in 1..<body.count {
      let current = body[index]
      body[index].point = previous
      previous = current.point
    }
  }

  mutating func grow() {
    body.append(.init(id: body.count, point: head.point))
  }
}
