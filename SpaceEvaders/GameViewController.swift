import UIKit
import SpriteKit
import Social
import GameKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        let sound = defaults.boolForKey("sound")
        Options.setSound(sound)
        let music = defaults.boolForKey("music")
        Options.setMusic(music)
        let indicator = defaults.boolForKey("indicator")
        Options.setIndicator(indicator)
        let mode = defaults.stringForKey("mode")
        if mode != nil {
           Options.setMode(Options.Mode(rawValue: mode!)!)
        }
        let scene = MainMenuScene(size:CGSize(width: 2048, height: 1536))
        let skView = self.view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        scene.viewController = self
        skView.presentScene(scene)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "shareAction:", name: "social", object: nil)
    }
    
    func viewControllerForPresentingModalView() -> UIViewController {
        return self
    }
    
    override func shouldAutorotate() -> Bool{
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool  {
        return true
    }

    func shareAction(notification:NSNotification) {
        let score = notification.userInfo!["score"] as! String
        let type = notification.userInfo!["type"] as! NSString
        if SLComposeViewController.isAvailableForServiceType(type as String){
            let social = SLComposeViewController(forServiceType: type as String)
            var text = "I scored \(score) in Space Evaders! Can you beat that? https://appsto.re/us/lgcg5.i"
            if score == "-1" {
                text = "Check out the iPhone game Space Evaders! https://appsto.re/us/lgcg5.i"
            }
            social.setInitialText(text)
            self.presentViewController(social, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to your social media account to share!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "I will", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func openGC() {
        GCHelper.sharedInstance.showGameCenter(self, viewState: .Default)
    }
}
