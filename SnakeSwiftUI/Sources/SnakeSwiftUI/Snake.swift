import Foundation

struct Snake {

    let size: CGFloat
    private(set) var body = [CGPoint.zero]

    private(set) var head: CGPoint {
        get { body[0] }
        set { body[0] = newValue }
    }

    mutating func place(to position: CGPoint) {
        body = [position]
    }

    mutating func move(to direction: Direction) {
        var previous = head
        switch direction {
        case .up:
            head.y -= size
        case .down:
            head.y += size
        case .left:
            head.x -= size
        case .right:
            head.x += size
        }
        for index in 1 ..< body.count {
            let current = body[index]
            body[index] = previous
            previous = current
        }
    }

    mutating func grow() {
        body.append(head)
    }
}
