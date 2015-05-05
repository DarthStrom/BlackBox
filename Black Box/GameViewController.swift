import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var scene = GameScene(size: CGSize(width: 0, height: 0))
    
    @IBOutlet weak var probes: UILabel!
    @IBOutlet weak var incorrect: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var par: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var finishedButton: UIButton!
    
    @IBAction func newGame(sender: UIButton) {
        setUpGame()
    }
    
    @IBAction func finished(sender: UIButton) {
        if scene.isFinishable() {
            scene.showIncorrectBalls()
            scene.showMissedBalls()
            scene.showCorrectBalls()
            updateScore()
            showNewGameButton()
        } else {
            println("trying to finish with \(scene.game?.marks.count) and need \(scene.game?.size)")
            hideScore()
        }
    }
    
    func updateScore() {
        probes.text = "Probes: \(scene.getProbes())"
        incorrect.text = "Incorrect: \(scene.getIncorrectBalls())"
        score.text = "Score: \(scene.getScore())"
        par.text = "Par: \(scene.getPar()!)"
        showScore()
    }
    
    func hideScore() {
        probes.hidden = true
        incorrect.hidden = true
        score.hidden = true
        par.hidden = true
    }
    
    func showScore() {
        probes.hidden = false
        incorrect.hidden = false
        score.hidden = false
        if let parValue = scene.getPar() {
            par.hidden = parValue == 0
        }
    }
    
    func showFinishedButton() {
        finishedButton.hidden = false
        newGameButton.hidden = true
    }
    
    func showNewGameButton() {
        finishedButton.hidden = true
        newGameButton.hidden = false
    }
    
    func setUpGame() {
        let skView = self.view as! SKView
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        hideScore()
        newGameButton.hidden = true
        skView.presentScene(scene)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        setUpGame()
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        finishedButton.hidden = !scene.isFinishable()
    }
}
