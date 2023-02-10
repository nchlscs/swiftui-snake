import SwiftUI

public struct GameView: View {

	@State private var phase = Phase.paused
	@State private var direction = Direction.down
	@State private var foodPosition = CGPoint.zero
	@State private var time = TimeInterval.zero

	@State private var snake: Snake
	@State private var frame: CGRect
	@State private var speed: TimeInterval
	@State private var timer: Timer?

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
			ForEach(snake.body) { point in
				Rectangle()
					.fill(Color.white)
					.frame(width: snake.size, height: snake.size)
					.position(point.point)
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
			Text(phase.title)
				.font(.system(.headline, design: .rounded))
				.foregroundColor(.red)
			// Controls
			Group {
				Button("􀄨") { setDirection(.up) }
					.keyboardShortcut(.upArrow, modifiers: [])
				Button("􀄩") { setDirection(.down) }
					.keyboardShortcut(.downArrow, modifiers: [])
				Button("􀄪") { setDirection(.left) }
					.keyboardShortcut(.leftArrow, modifiers: [])
				Button("􀄫") { setDirection(.right) }
					.keyboardShortcut(.rightArrow, modifiers: [])
				Button("􀊄") { switchPhase() }
					.keyboardShortcut(.space, modifiers: [])
            }
            .opacity(0)
		}
		.onAppear(perform: reset)
		.onTapGesture(perform: switchPhase)
		.gesture(DragGesture().onEnded(updateDirection))
		.onChange(of: time) { _ in self.run() }
		.frame(width: frame.width, height: frame.height)
	}
}

private extension GameView {

	func switchPhase() {
		switch phase {
		case .paused:
			phase = .running
		case .running:
			phase = .paused
		case .failed:
			phase = .paused
			reset()
		}
	}

	func reset() {
		foodPosition = randomPosition()
		snake.place(to: randomPosition())
		let left = snake.head.point.x < frame.width / 2
		let top = snake.head.point.y < frame.height / 2
		if left && top {
			setDirection(Bool.random() ? .down : .right)
		} else if left && !top {
			setDirection(Bool.random() ? .up : .right)
		} else if !left && top {
			setDirection(Bool.random() ? .down : .left)
		} else if !left && !top {
			setDirection(Bool.random() ? .up : .left)
		}
		timer?.invalidate()
		timer = Timer.scheduledTimer(
			withTimeInterval: speed,
			repeats: true,
			block: { time += $0.timeInterval }
		)
	}

	func randomPosition() -> CGPoint {
		var points = [CGPoint]()
		let ignorePoints = snake.body
			.reduce(into: [foodPosition]) { $0.append($1.point) }

		for column in 0 ..< Int(frame.maxX / snake.size) {
			for row in 0 ..< Int(frame.maxY / snake.size) {
				let point = CGPoint(
					x: snake.size * CGFloat(column),
					y: snake.size * CGFloat(row)
				)
				if !ignorePoints.contains(point) {
					points.append(point)
				}
			}
		}

		return points.randomElement() ?? .zero
	}

	func run() {
		guard phase == .running else {
			return
		}
		guard frame.contains(snake.head.point) else {
			phase = .failed
			return
		}
		snake.move(to: direction)
		if snake.head.point == foodPosition {
			snake.grow()
			foodPosition = randomPosition()
		}
	}

	func updateDirection(with gesture: DragGesture.Value) {
		guard phase == .running else {
			return
		}
		let start = gesture.startLocation
		let end = gesture.location
		let x = abs(end.x - start.x)
		let y = abs(end.y - start.y)
		if y > x {
			setDirection((start.y < end.y) ? .down : .up)
		} else {
			setDirection((start.x > end.x) ? .left : .right)
		}
	}

	func setDirection(_ newValue: Direction) {
		guard direction != newValue else {
			return
		}
		guard direction != newValue.opposite else {
			return
		}
		direction = newValue
	}
}
