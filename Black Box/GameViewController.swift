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
    @IBOutlet var gameView: SKView!

    @IBAction func newGame(_ sender: UIButton) {
        setUpGame()
    }

    @IBAction func toggleSound(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        if let audioToggle = defaults.string(forKey: "audio") {
            if audioToggle == "on" {
                sender.setImage(UIImage(named: "AudioOff"), for: UIControlState())
                defaults.setValue("off", forKey: "audio")
            } else {
                sender.setImage(UIImage(named: "AudioOn"), for: UIControlState())
                defaults.setValue("on", forKey: "audio")
            }
        }
    }

    @IBAction func finished(_ sender: UIButton) {
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
        probes.isHidden = true
        incorrect.isHidden = true
        score.isHidden = true
        par.isHidden = true
    }

    func showScore() {
        probes.isHidden = false
        incorrect.isHidden = false
        score.isHidden = false
        if let parValue = scene.getPar() {
            par.isHidden = parValue == 0
        }
    }

    func showFinishedButton() {
        finishedButton.isHidden = false
        newGameButton.isHidden = true
    }

    func showNewGameButton() {
        finishedButton.isHidden = true
        newGameButton.isHidden = false
    }

    func setUpGame() {
        scene = GameScene(size: gameView.bounds.size)
        scene.scaleMode = .aspectFill

        hideScore()
        newGameButton.isHidden = true
        balls.isHidden = false
        balls.text = "Balls: \(scene.game!.size)"
        gameView.presentScene(scene)
    }

    func loadAudioSetting() {
        let defaults = UserDefaults.standard
        if let audio = defaults.string(forKey: "audio") {
            if audio == "on" {
                audioToggleButton.setImage(UIImage(named: "AudioOn"), for: UIControlState())
                defaults.setValue("on", forKey: "audio")
            } else {
                audioToggleButton.setImage(UIImage(named: "AudioOff"), for: UIControlState())
                defaults.setValue("off", forKey: "audio")
            }
        } else {
            defaults.set("on", forKey: "audio")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadAudioSetting()

        gameView?.ignoresSiblingOrder = true
        gameView.allowsTransparency = true

        setUpGame()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        finishedButton.isHidden = !scene.isFinishable()
        balls.isHidden = scene.isFinishable()
    }

}
