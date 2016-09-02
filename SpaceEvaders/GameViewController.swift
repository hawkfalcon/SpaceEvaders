import UIKit
import SpriteKit
import Social
import GameKit
import StoreKit

class GameViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var product_id: String?

    override func viewDidLoad() {
        product_id = "PREMIUM"
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let options: [String:Bool] = defaults.dictionary(forKey: "options") as? [String:Bool] {
            Options.option.setOptions(options: options)
        }
        let scene = MainMenuScene(size: CGSize(width: 2048, height: 1536))
        let skView = self.view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        scene.viewController = self
        skView.presentScene(scene)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.shareAction(_:)), name: NSNotification.Name(rawValue: "social"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.unlockPremium(_:)), name: NSNotification.Name(rawValue: "premium"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.restore(_:)), name: NSNotification.Name(rawValue: "restore"), object: nil)

        SKPaymentQueue.default().add(self)
    }

    func viewControllerForPresentingModalView() -> UIViewController {
        return self
    }

    override var shouldAutorotate: Bool {
        get {
            return true
        }
    }

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }  
    }  


    func shareAction(_ notification: Notification) {
        let score = (notification as NSNotification).userInfo!["score"] as! String
        let type = (notification as NSNotification).userInfo!["type"] as! NSString
        if SLComposeViewController.isAvailable(forServiceType: type as String) {
            let social = SLComposeViewController(forServiceType: type as String)
            var text = "I scored \(score) in Space Evaders! Can you beat that? https://appsto.re/us/lgcg5.i"
            if score == "-1" {
                text = "Check out the iPhone game Space Evaders! https://appsto.re/us/lgcg5.i"
            }
            social?.setInitialText(text)
            self.present(social!, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to your social media account to share!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "I will", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGC() {
        GCHelper.sharedInstance.showGameCenter(self, viewState: .default)
    }

    func restore(_ notifaction: Notification) {
        print("Restoring purchase!", terminator: "")
        if (SKPaymentQueue.canMakePayments()) {
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
    }
    
    func unlockPremium(_ notification: Notification) {
        if (SKPaymentQueue.canMakePayments()) {
            let productID = Set(arrayLiteral: self.product_id!)
            let productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productID)
            productsRequest.delegate = self
            productsRequest.start()
            print("Fetching Products")
        } else {
            print("Can't make purchases")
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let count: Int = response.products.count
        if (count > 0) {
            let validProduct: SKProduct = response.products[0] 
            if (validProduct.productIdentifier == self.product_id) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                buyProduct(validProduct)
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }


    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error Fetching product information")
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Received Payment Transaction Response from Apple")

        for transaction: AnyObject in transactions {
            if let trans: SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased, .restored:
                    print("Product Purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    Options.option.set(option: "premium", val: true)
                    break
                case .failed:
                    print("Purchased Failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                default:
                    break
                }
            }
        }
    }

    func buyProduct(_ product: SKProduct) {
        print("Sending the Payment Request to Apple")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}
