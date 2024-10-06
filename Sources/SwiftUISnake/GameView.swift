import SnakeGame
import SwiftUI

public struct GameView: View {

  private let model: ViewModel
  private let scale: CGFloat

  public init(model: ViewModel, scale: CGFloat) {
    self.model = model
    self.scale = scale
  }

  public var body: some View {
    ZStack {
      // Background
      Color(red: 1, green: 199 / 255, blue: 208 / 255)
        .edgesIgnoringSafeArea(.all)
      // Snake
      ForEach(snake.body) { point in
        Rectangle()
          .fill(Color.white)
          .frame(width: scale, height: scale)
          .position(CGPoint(point.point, scale: scale))
          .offset(x: scale / 2, y: scale / 2)
      }
      // Food
      Circle()
        .fill(Color.red)
        .frame(width: scale, height: scale)
        .position(CGPoint(foodPosition.point, scale: scale))
        .offset(x: scale / 2, y: scale / 2)
        .id(foodPosition.id)
      // Info
      VStack {
        HStack {
          Text(scoreText)
          Spacer()
          Text(levelText)
        }
        .foregroundColor(Color.blue)
        .font(.system(.title3, design: .rounded))
        Spacer()
      }
      .padding(8)
      // Phase
      Text(phaseTitle)
        .font(.system(.headline, design: .rounded))
        .foregroundColor(.red)
      // Controls
      Group {
        Button("􀄨") { model.setDirection(.up) }
          .keyboardShortcut(.upArrow, modifiers: [])
        Button("􀄩") { model.setDirection(.down) }
          .keyboardShortcut(.downArrow, modifiers: [])
        Button("􀄪") { model.setDirection(.left) }
          .keyboardShortcut(.leftArrow, modifiers: [])
        Button("􀄫") { model.setDirection(.right) }
          .keyboardShortcut(.rightArrow, modifiers: [])
        Button("􀊄") { model.nextPhase() }
          .keyboardShortcut(.space, modifiers: [])
      }
      .opacity(0)
    }
    .animation(nil, value: 0)
    .onAppear(perform: model.reset)
    .onTapGesture(perform: model.nextPhase)
    .gesture(DragGesture().onEnded(updateDirection))
    .onChange(of: model.timeFrame, model.nextTimeFrame)
    .frame(width: canvasSize.width, height: canvasSize.height)
  }
}

private extension GameView {

  var snake: Snake { model.snake }
  var foodPosition: IdentifiablePoint { model.foodPosition }
  var canvasSize: CGSize { CGSize(model.canvasSize, scale: scale) }

  var phaseTitle: String {
    switch model.phase {
    case .paused: "Tap to play"
    case .failed: "Game over"
    case .running: ""
    }
  }

  var scoreText: String { "Score: \(model.score)" }
  var levelText: String { "Level: \(model.level)" }

  func updateDirection(with gesture: DragGesture.Value) {
    guard model.phase == .running else {
      return
    }
    let start = gesture.startLocation
    let end = gesture.location
    let x = abs(end.x - start.x)
    let y = abs(end.y - start.y)
    if y > x {
      model.setDirection((start.y < end.y) ? .down : .up)
    }
    else {
      model.setDirection((start.x > end.x) ? .left : .right)
    }
  }
}

private extension CGPoint {

  init(_ point: Point, scale: CGFloat) {
    self.init(x: CGFloat(point.x) * scale, y: CGFloat(point.y) * scale)
  }
}

private extension CGSize {

  init(_ size: Size, scale: CGFloat) {
    self.init(
      width: CGFloat(size.width) * scale,
      height: CGFloat(size.height) * scale
    )
  }
}

#Preview {
  GameView(
    model: .init(canvasSize: .init(width: 24, height: 32)),
    scale: 16
  )
}
