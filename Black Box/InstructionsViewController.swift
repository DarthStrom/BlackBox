import UIKit

class InstructionsViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        let bundle = Bundle.main
        let filePath = bundle.path(forResource: "README", ofType: "md")
        let inputText = try? String(contentsOfFile: filePath!, encoding: String.Encoding.utf8)
        var markdown = Markdown()
        let outputHtml: String = markdown.transform(inputText!)
        webView.loadHTMLString(outputHtml, baseURL: URL(fileURLWithPath: bundle.bundlePath))
    }

    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
