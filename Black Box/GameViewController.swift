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
    @IBOutlet weak var audioToggleButton: UIButton!
    @IBOutlet weak var balls: UILabel!

    @IBAction func newGame(sender: UIButton) {
        setUpGame()
    }

    @IBAction func toggleSound(sender: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let audioToggle = defaults.stringForKey("audio") {
            if audioToggle == "on" {
                sender.setImage(UIImage(named: "AudioOff"), forState: .Normal)
                defaults.setValue("off", forKey: "audio")
            } else {
                sender.setImage(UIImage(named: "AudioOn"), forState: .Normal)
                defaults.setValue("on", forKey: "audio")
            }
        }
    }

    @IBAction func finished(sender: UIButton) {
        if scene.isFinishable() {
            scene.showIncorrectBalls()
            scene.showMissedBalls()
            scene.showCorrectBalls()
            updateScore()
            showNewGameButton()
        } else {
            print("trying to finish with \(scene.game?.marks.count) and need \(scene.game?.size)")
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
        guard let skView = self.view as? SKView else {
            print("view was not an SKView")
            return
        }

        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill

        hideScore()
        newGameButton.hidden = true
        balls.hidden = false
        balls.text = "Balls: \(scene.game!.size)"
        skView.presentScene(scene)
    }

    func loadAudioSetting() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let audio = defaults.stringForKey("audio") {
            if audio == "on" {
                audioToggleButton.setImage(UIImage(named: "AudioOn"), forState: .Normal)
                defaults.setValue("on", forKey: "audio")
            } else {
                audioToggleButton.setImage(UIImage(named: "AudioOff"), forState: .Normal)
                defaults.setValue("off", forKey: "audio")
            }
        } else {
            defaults.setObject("on", forKey: "audio")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = self.view as? SKView

        loadAudioSetting()

        skView?.ignoresSiblingOrder = true

        setUpGame()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        finishedButton.hidden = !scene.isFinishable()
        balls.hidden = scene.isFinishable()
    }

}
