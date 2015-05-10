import SpriteKit

extension SKNode {
  var positionInScene: CGPoint? {
    get {
      if let parent = parent {
        return scene?.convertPoint(position, fromNode: parent)
      }
      return nil
    }
  }
}

extension CGVector {
  static let upVector = CGVector(dx: 0, dy: 1.0)
  static let downVector = CGVector(dx: 0, dy: -1.0)
  static let rightVector = CGVector(dx: 1.0, dy: 0)
  static let leftVector = CGVector(dx: -1.0, dy: 0)
}