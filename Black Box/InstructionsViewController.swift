import UIKit

class InstructionsViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        let bundle = NSBundle.mainBundle()
        let filePath = bundle.pathForResource("README", ofType: "md")
        let inputText = String(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding, error: nil)
        var markdown = Markdown()
        let outputHtml: String = markdown.transform(inputText!)
        webView.loadHTMLString(outputHtml, baseURL: NSURL.fileURLWithPath(bundle.bundlePath))
    }
    
    @IBAction func dismiss(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}