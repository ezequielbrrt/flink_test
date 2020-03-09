//
//  Tools.swift
//  flink
//
//  Created by Ezequiel Barreto on 06/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class Tools: NSObject{
    
    class func RGB(r : Int, g : Int, b : Int) -> UIColor{
        return UIColor.init(red: RGBNumber(number: r),
                            green: RGBNumber(number: g),
                            blue: RGBNumber(number: b),
                            alpha: 1.0)
    }
    
    class func RGBNumber(number : Int) -> CGFloat{
           return CGFloat.init(Double(number) / 255.0)
    }
    
    class func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        let imageCache = NSCache<NSString, UIImage>()

        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil)
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                } else if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                } else {
                    completion(nil, NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "Error getting image"]))
                }
            }.resume()
        }
    }
    
    class func upView(View : UIView, Points : CGFloat) {
        var NewFrame : CGRect = View.frame
        NewFrame.origin.y = View.frame.origin.y - Points
        View.frame = NewFrame
    }
    
    class func downView(View : UIView, Points : CGFloat) {
        var NewFrame : CGRect = View.frame
        NewFrame.origin.y = View.frame.origin.y + Points
        View.frame = NewFrame
    }
    
    class func pushViewCenter(View : UIView, Points : CGFloat) {
        var NewFrame : CGPoint = View.center
        NewFrame.x = View.center.x + Points;
        View.center = NewFrame
    }
    
    class func pullViewCenter(View : UIView, Points : CGFloat) {
        var NewFrame : CGPoint = View.center
        NewFrame.x = View.center.x - Points;
        View.center = NewFrame
    }
    
    
    class func hasInternet() -> Bool{
        
           var zeroAddress = sockaddr_in()
           zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
           zeroAddress.sin_family = sa_family_t(AF_INET)
           
           let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
               $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                   SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
               }
           }
           
           var flags = SCNetworkReachabilityFlags()
           if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
               return false
           }
           let isReachable = flags.contains(.reachable)
           let needsConnection = flags.contains(.connectionRequired)
           return (isReachable && !needsConnection)
       }

}

extension UITableView {
    
    ///Show an activity indicator view inside table view at center
    func showLoader(){
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        
        let activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.color = AppConfigurator.mainColor
        activityView.startAnimating()
        
        activityView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.addSubview(activityView)
        
        activityView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        activityView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
        
    }
    
    /// Show a view inside table view at center, the view can contains a button to do some action
    func setEmptyView(title: String, message: String,
                         messageImage: UIImage, select: Selector? = nil,
                         delegate: UIViewController? = nil) {
           
           let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
           
           let titleLabel = UILabel()
           let messageLabel = UILabel()
           let messageImageView = UIImageView()
           
           messageImageView.backgroundColor = .clear
           
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           messageLabel.translatesAutoresizingMaskIntoConstraints = false
           messageImageView.translatesAutoresizingMaskIntoConstraints = false
           
           
           titleLabel.textColor = UIColor.black
           titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
           messageLabel.textColor = UIColor.lightGray
           messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
           
           emptyView.addSubview(titleLabel)
           emptyView.addSubview(messageLabel)
           emptyView.addSubview(messageImageView)
           
           
           messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
           messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -105).isActive = true
           messageImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
           messageImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
           titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10).isActive = true
           titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
           
           messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
           messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -25).isActive = true
           messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 25).isActive = true
           
           
           messageImageView.image = messageImage
           titleLabel.text = title
           messageLabel.text = message
           messageLabel.numberOfLines = 0
           messageLabel.textAlignment = .center
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { messageImageView.shake()}
           
           if delegate != nil{
               
               let button = UIButton()
               button.setTitle(Strings.retry, for: .normal)
               button.isEnabled = true
               button.translatesAutoresizingMaskIntoConstraints = false
               emptyView.addSubview(button)
               
               button.addTarget(delegate, action: select!, for: .touchUpInside)
               button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20).isActive = true
               button.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
               
               button.setTitleColor(.white, for: .normal)
               button.widthAnchor.constraint(equalToConstant: 120).isActive = true
               button.backgroundColor = AppConfigurator.mainColor
           }
           
           
           self.backgroundView = emptyView
           self.separatorStyle = .none
       }
    
    /// Restore the table view background, with the option to show separator style
    func restore(showSingleLine: Bool = true) {
        self.backgroundView = nil
        if showSingleLine{
            self.separatorStyle = .singleLine
        }
        
    }
}

extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
