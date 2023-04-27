import Foundation

struct Snake {

  let size: CGFloat
  private(set) var body = [IdentifiablePoint()]

  private(set) var head: IdentifiablePoint {
    get { body[0] }
    set { body[0] = newValue }
  }

  mutating func place(to position: CGPoint) {
    body = [.init(point: position)]
  }

  mutating func move(to direction: Direction) {
    var previous = head
    switch direction {
    case .up:
      head.point.y -= size
    case .down:
      head.point.y += size
    case .left:
      head.point.x -= size
    case .right:
      head.point.x += size
    }
    for index in 1 ..< body.count {
      let current = body[index]
      body[index].point = previous.point
      previous = current
    }
  }

  mutating func grow() {
    body.append(.init(point: head.point))
  }
}

struct IdentifiablePoint: Identifiable {
  let id = UUID()
  var point = CGPoint.zero
}
