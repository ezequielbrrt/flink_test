//
//  Tools.swift
//  flink
//
//  Created by beTech CAPITAL on 06/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation
import UIKit

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

}

extension UITableView {
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
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { messageImageView.shake()
           }
           //Tools.shakeAnimation(viewAnimation: messageImageView, moveScale: 2, minimumAlpha: 8, duration: 2)
           
           
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
               //Tools.setRoundedButton(button: button)
               //Tools.setHeightButton(button: button)
               //Tools.setFont(UIComponent: button)
           }
           
           
           self.backgroundView = emptyView
           self.separatorStyle = .none
       }
    
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
