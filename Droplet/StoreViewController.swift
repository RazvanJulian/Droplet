//
//  StoreViewController.swift
//  Droplet
//
//  Created by Razvan Julian on 16/09/17.
//  Copyright © 2017 Jake Lin. All rights reserved.
//

import UIKit
import GoogleMobileAds
import StoreKit

class StoreViewController: UIViewController, GADBannerViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    let colors = [#colorLiteral(red: 0.08235294118, green: 0.6980392157, blue: 0.5411764706, alpha: 1), #colorLiteral(red: 0.07058823529, green: 0.5725490196, blue: 0.4470588235, alpha: 1), #colorLiteral(red: 0.9333333333, green: 0.7333333333, blue: 0, alpha: 1), #colorLiteral(red: 0.9411764706, green: 0.5450980392, blue: 0, alpha: 1), #colorLiteral(red: 0.1411764706, green: 0.7803921569, blue: 0.3529411765, alpha: 1), #colorLiteral(red: 0.1176470588, green: 0.6431372549, blue: 0.2941176471, alpha: 1), #colorLiteral(red: 0.8784313725, green: 0.4156862745, blue: 0.03921568627, alpha: 1), #colorLiteral(red: 0.7882352941, green: 0.2470588235, blue: 0, alpha: 1), #colorLiteral(red: 0.1490196078, green: 0.5098039216, blue: 0.8352941176, alpha: 1), #colorLiteral(red: 0.1137254902, green: 0.4156862745, blue: 0.6784313725, alpha: 1), #colorLiteral(red: 0.8823529412, green: 0.2, blue: 0.1607843137, alpha: 1), #colorLiteral(red: 0.7019607843, green: 0.1411764706, blue: 0.1098039216, alpha: 1), #colorLiteral(red: 0.7098039216, green: 0.4549019608, blue: 0.9607843137, alpha: 1), #colorLiteral(red: 0.537254902, green: 0.2352941176, blue: 0.662745098, alpha: 1), #colorLiteral(red: 0.4823529412, green: 0.1490196078, blue: 0.6235294118, alpha: 1), #colorLiteral(red: 0.6862745098, green: 0.7137254902, blue: 0.7333333333, alpha: 1), #colorLiteral(red: 0.1529411765, green: 0.2196078431, blue: 0.2980392157, alpha: 1), #colorLiteral(red: 0.1294117647, green: 0.1843137255, blue: 0.2470588235, alpha: 1), #colorLiteral(red: 0.5137254902, green: 0.5843137255, blue: 0.5843137255, alpha: 1), #colorLiteral(red: 0.4235294118, green: 0.4745098039, blue: 0.4784313725, alpha: 1)]
    
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var restoreButton: UIButton!
    @IBOutlet var purchaseButton: UIButton!
    @IBOutlet var returnButton: UIButton!
    
    @IBOutlet var bannerview: GADBannerView!
    
    
    
    var product: SKProduct?
    var productID = "Droplet.removeAds"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        label1.layer.cornerRadius = 10.0
        label2.layer.cornerRadius = 10.0
        
        purchaseButton.layer.cornerRadius = 10.0
        returnButton.layer.cornerRadius = 10.0
        restoreButton.layer.cornerRadius = 10.0
        
        
        
        purchaseButton.isEnabled = false
        SKPaymentQueue.default().add(self)
        getPurchaseInfo()
        
        
        bannerview.isHidden = true
        bannerview.delegate = self
        
        
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        label1.backgroundColor = color
        label2.textColor = color
        textView.textColor = color
        purchaseButton.backgroundColor = color
        returnButton.backgroundColor = color
        restoreButton.backgroundColor = color
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let save = UserDefaults.standard
        
        if save.value(forKey: "Droplet.Purchase") == nil {
            
        
        bannerview.adUnitID = "ca-app-pub-8073575255978731/4665645460"
        bannerview.adSize = kGADAdSizeSmartBannerPortrait
        
        bannerview.rootViewController = self
        bannerview.load(GADRequest())
        
        } else {
            
            bannerview.isHidden = true
            
        }
        
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
    
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        
        bannerView.isHidden = true
        
        
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func restoreAction(_ sender: Any) {
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }
    
    
    @IBAction func purchaseAction(_ sender: AnyObject) {
        
            let payment = SKPayment(product: product!)
            SKPaymentQueue.default().add(payment)
        
    
    }
    
    
    @IBAction func returnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }


    
    func getPurchaseInfo() {
        
        if SKPaymentQueue.canMakePayments(){
            
            let request = SKProductsRequest(productIdentifiers: NSSet(objects: self.productID) as! Set<String>)
            
            request.delegate = self
            request.start()
            
        } else {
            
            label2.text = "Warning"
            textView.text = "Please enable in - app purchases in your Settings"
            
        }
        
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        var products = response.products
        
        if products.count == 0 {
            
            label2.text = "Warning"
            textView.text = "Product Not Found"
            
        } else {
            
            
            product = products[0]
            label2.text = product?.localizedTitle
            textView.text = product?.localizedDescription
            purchaseButton.isEnabled = true
            
        }
        
        let invalids = response.invalidProductIdentifiers
        
        for product in invalids {
            
            print("Product not found: \(product)")
            
            
        }
        
        
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                
                SKPaymentQueue.default().finishTransaction(transaction)
                label2.text = "Thank you!"
                textView.text = "The service has been purchased"
                purchaseButton.isEnabled = false
                
                let save = UserDefaults.standard
                save.set(true, forKey: "Droplet.Purchase")
                save.synchronize()
                
                
            case SKPaymentTransactionState.restored:
                
                SKPaymentQueue.default().finishTransaction(transaction)
                label2.text = "Thank you!"
                textView.text = "The service has been restored"
                purchaseButton.isEnabled = false
                
                let save = UserDefaults.standard
                save.set(true, forKey: "Droplet.Purchase")
                save.synchronize()
            
                
            case SKPaymentTransactionState.failed:
                label2.text = "Warning"
                textView.text = "The service hasn't been purchased"
                
            default:
                break
                
            }
            
            
        }
        
        
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
