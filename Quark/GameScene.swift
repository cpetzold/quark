import SpriteKit

class GameScene: SKScene {
  var touching: Bool = false
  var lastUpdateTimeInterval: CFTimeInterval?
  let world: SKNode
  let camera: SKNode

  override init(size: CGSize) {
    world = SKNode()
    camera = SKNode()

    super.init(size: size)

    anchorPoint = CGPoint(x: 0.5, y: 0.5)

    addEntity(camera)
    addChild(world)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addEntity(entity: SKNode) {
    world.addChild(entity)
  }

  override func didSimulatePhysics() {
    if let cameraPosInScene = camera.positionInScene {
      camera.parent?.position -= cameraPosInScene
    }
  }

  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    touching = true
  }

  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    touching = false
  }

  override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
    touching = false
  }

  func updateWithDeltaTime(dt: CFTimeInterval) {
  }

  override func update(currentTime: CFTimeInterval) {
    var dt: CFTimeInterval = currentTime
    if let luti = lastUpdateTimeInterval {
      dt = currentTime - luti
    }
    lastUpdateTimeInterval = currentTime
    updateWithDeltaTime(dt)
  }
}
