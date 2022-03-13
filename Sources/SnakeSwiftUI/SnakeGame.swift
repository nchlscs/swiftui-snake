import SwiftUI

@main
struct SnakeGameApp: App {
    
    var body: some Scene {
        WindowGroup {
            GameView(configuration: .init())
        }
    }
}

struct Configuration {
    var canvasSize: CGSize = .init(width: 512, height: 512)
    var snakeSize: CGFloat = 16
    var speed: TimeInterval = 0.1
}

struct GameView: View {
    
    @State private var gameState = GameState.paused
    @State private var direction = Direction.down
    @State private var foodPosition = CGPoint.zero
    @State private var time = TimeInterval.zero
    
    @State private var snake: Snake
    @State private var frame: CGRect
    @State private var speed: TimeInterval
    @State private var timer: Timer?

    init(configuration: Configuration) {
        _snake = State(initialValue: .init(
            size: configuration.snakeSize
        ))
        frame = .init(
            origin: .zero, 
            size: configuration.canvasSize
        )
        speed = configuration.speed
    }
    
    var body: some View {
        ZStack {
            Color.white
            Color.pink
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            ForEach(0 ..< snake.body.count, id: \.self) { index in
                Rectangle()
                    .fill(Color.white)
                    .frame(width: snake.size, height: snake.size)
                    .position(snake.body[index])
                    .offset(x: snake.size / 2, y: snake.size / 2)
            }
            Circle()
                .fill(Color.red)
                .frame(width: snake.size, height: snake.size)
                .position(foodPosition)
                .offset(x: snake.size / 2, y: snake.size / 2)
            Text(String(snake.body.count - 1))
                .position(x: 16, y: 16)
                .foregroundColor(Color.blue)
                .font(.system(.title, design: .rounded))
            Text(gameState.title)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.red)
        }
        .onAppear(perform: reset)
        .onTapGesture(perform: switchState)
        .gesture(DragGesture().onEnded(updateDirection))
        .onChange(of: time) { _ in self.run() }
        .frame(width: frame.width, height: frame.height)
    }
    
    private func switchState() {
        switch gameState {
        case .paused:
            gameState = .running
        case .running:
            gameState = .paused
        case .failed:
            gameState = .paused
            reset()
        }
    }
    
    private func reset() {
        snake.reset()
        foodPosition = randomPosition()
        snake.place(to: randomPosition())
        let left = snake.head.x < frame.width / 2
        let top = snake.head.y < frame.height / 2
        if left && top {
            direction = Bool.random() ? .down : .left
        } else if left && !top {
            direction = Bool.random() ? .up : .left
        } else if !left && top {
            direction = Bool.random() ? .down : .right
        } else if !left && !top {
            direction = Bool.random() ? .up : .right
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: speed, 
            repeats: true,
            block: { time += $0.timeInterval }
        )
    }
    
    private func randomPosition() -> CGPoint {
        (0 ..< Int(frame.maxX / snake.size))
            .map { row -> [CGPoint] in
                (0 ..< Int(frame.maxY / snake.size))
                    .map { column -> CGPoint in
                        CGPoint(
                            x: snake.size * CGFloat(row),
                            y: snake.size * CGFloat(column)
                        )
                    }
            }
            .flatMap { $0 }
            .filter {
                !snake.body.contains($0) && $0 != foodPosition
            }
            .randomElement() ?? .zero
    }
    
    private func run() {
        guard gameState == .running else {
            return
        }
        guard frame.contains(snake.head) else {
            gameState = .failed
            return
        }
        snake.move(to: direction)
        if snake.head == foodPosition {
            snake.grow()
            foodPosition = randomPosition()
        }
    }
    
    private func updateDirection(with gesture: DragGesture.Value) {
        guard gameState == .running else {
            return
        }
        let start = gesture.startLocation
        let end = gesture.location
        let x = abs(end.x - start.x)
        let y = abs(end.y - start.y)
        if y > x {
            direction = (start.y < end.y) ? .down : .up
        } else {
            direction = (start.x > end.x) ? .right : .left
        }
    }
}

enum Direction: CaseIterable {
    case up, down, left, right
}

enum GameState {
    
    case paused
    case running
    case failed
    
    var title: String {
        switch self {
        case .paused:
            return "Tap to Play"
        case .failed:
            return "Game Over"
        case .running:
            return ""
        }
    }
}

struct Snake {
    
    let size: CGFloat
    
    private(set) var body = [CGPoint.zero]
    
    private(set) var head: CGPoint {
        get { body[0] }
        set { body[0] = newValue }
    }
    
    mutating func place(to position: CGPoint) {
        head = position
    }
    
    mutating func move(to direction: Direction) {
        var previous = head
        switch direction {
        case .up: 
            head.y -= size
        case .down: 
            head.y += size
        case .left: 
            head.x += size
        case .right: 
            head.x -= size
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
    
    mutating func reset() {
        body = [CGPoint.zero]
    }
}
