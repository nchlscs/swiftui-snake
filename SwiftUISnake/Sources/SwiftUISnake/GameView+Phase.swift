extension GameView {

  enum Phase {

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
}
