import SwiftUI

public struct GameView: View {

    @State private var gameState = GameState.paused
    @State private var direction = Direction.down
    @State private var foodPosition = CGPoint.zero
    @State private var time = TimeInterval.zero

    @State private var snake: Snake
    @State private var frame: CGRect
    @State private var speed: TimeInterval
    @State private var timer: Timer?

    public struct Configuration {
        let canvasSize: CGSize
        let snakeSize: CGFloat
        let speed: TimeInterval
    }

    public init(configuration: Configuration) {
        self.snake = .init(
            size: configuration.snakeSize
        )
        self.frame = .init(
            origin: .zero,
            size: configuration.canvasSize
        )
        self.speed = configuration.speed
    }

    public var body: some View {
        ZStack {
            // Background
            Color.white
            Color.pink
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            // Snake
            ForEach(0 ..< snake.body.count, id: \.self) { index in
                Rectangle()
                    .fill(Color.white)
                    .frame(width: snake.size, height: snake.size)
                    .position(snake.body[index])
                    .offset(x: snake.size / 2, y: snake.size / 2)
            }
            // Food
            Circle()
                .fill(Color.red)
                .frame(width: snake.size, height: snake.size)
                .position(foodPosition)
                .offset(x: snake.size / 2, y: snake.size / 2)
            // Length
            Text(String(snake.body.count - 1))
                .position(x: 16, y: 16)
                .foregroundColor(Color.blue)
                .font(.system(.title, design: .rounded))
            // State
            Text(gameState.title)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.red)
            // Controls
            VStack {
                Button("") { direction = .up }
                    .keyboardShortcut(.upArrow, modifiers: [])
                Button("") { direction = .down }
                    .keyboardShortcut(.downArrow, modifiers: [])
                Button("") { direction = .left }
                    .keyboardShortcut(.leftArrow, modifiers: [])
                Button("") { direction = .right }
                    .keyboardShortcut(.rightArrow, modifiers: [])
            }
        }
        .onAppear(perform: reset)
        .onTapGesture(perform: switchState)
        .gesture(DragGesture().onEnded(updateDirection))
        .onChange(of: time) { _ in self.run() }
        .frame(width: frame.width, height: frame.height)
    }
}

private extension GameView {

    func switchState() {
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

    func reset() {
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

    func randomPosition() -> CGPoint {
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

    func run() {
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

    func updateDirection(with gesture: DragGesture.Value) {
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
            direction = (start.x > end.x) ? .left : .right
        }
    }
}
