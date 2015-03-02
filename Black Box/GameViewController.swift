import UIKit
import SpriteKit

class GameViewController: UIViewController {

  var scene = GameScene(size: CGSize(width: 0, height: 0))
  
  @IBOutlet weak var probes: UILabel!
  @IBOutlet weak var incorrect: UILabel!
  @IBOutlet weak var score: UILabel!
  
  @IBAction func finished(sender: UIButton) {
    if scene.isFinishable() {
      probes.text = "Probes: \(scene.getProbes())"
      incorrect.text = "Incorrect: \(scene.getIncorrectBalls())"
      score.text = scene.getScore()
      showScore()
    } else {
      println("trying to finish with \(scene.game.marks.count) and need \(scene.game.balls)")
      hideScore()
    }
  }
  
  func hideScore() {
    probes.hidden = true
    incorrect.hidden = true
    score.hidden = true
  }
  
  func showScore() {
    probes.hidden = false
    incorrect.hidden = false
    score.hidden = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure the view.
    let skView = self.view as SKView
    skView.showsFPS = true
    skView.showsNodeCount = true
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = true
    
    /* Set the scale mode to scale to fit the window */
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .AspectFill
    
    hideScore()
    skView.presentScene(scene)
  }
  
  override func shouldAutorotate() -> Bool {
    return true
  }
  
  override func supportedInterfaceOrientations() -> Int {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    } else {
      return Int(UIInterfaceOrientationMask.All.rawValue)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
