//
//  AlertWindow.swift
//  flink
//
//  Created by beTech CAPITAL on 08/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation
import UIKit

class AlertWindow: UIViewController
{
    @IBOutlet weak var background : UIView?
    @IBOutlet weak var text : UILabel?
    
    @IBOutlet weak var leftView : UIView?
    @IBOutlet weak var rightView : UIView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.text?.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        Tools.pullViewCenter(View: leftView!, Points: (leftView?.frame.size.width)!)
        Tools.pushViewCenter(View: rightView!, Points: (rightView?.frame.size.width)!)
        
        background?.layer.shadowColor = UIColor.black.cgColor
        background?.layer.shadowOpacity = 0.25
        background?.layer.shadowOffset = CGSize.zero
        background?.layer.shadowRadius = 5
        
        rightView?.backgroundColor = UIColor.red
        leftView?.backgroundColor = UIColor.red
        self.text?.textColor = UIColor.white
        
    }
    
    func setText(withText : String)
    {
        text?.text = withText
    }
    
    func doYourMagic()
    {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations:
            {
                Tools.pullViewCenter(View: self.rightView!, Points: (self.leftView?.frame.size.width)!)
                Tools.pushViewCenter(View: self.leftView!, Points: (self.rightView?.frame.size.width)!)
                
        }, completion: { _ in
            UIView.animate(withDuration: 0.20, animations: {self.text?.alpha = 1})
        })
    }
    
    func kill()
    {
        self.view.removeFromSuperview()
        self.removeFromParent()
        
    }
    
    func hidden()
    {
        
        UIView.animate(withDuration: 0.15, animations: {self.text?.alpha = 0})
        
        UIView.animate(withDuration: 0.30, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations:
            {
                Tools.pullViewCenter(View: self.leftView!, Points: (self.leftView?.frame.size.width)!)
                Tools.pushViewCenter(View: self.rightView!, Points: (self.rightView?.frame.size.width)!)
                
        }, completion: { _ in
            
            self.leftView?.removeFromSuperview()
            self.rightView?.removeFromSuperview()
            self.background?.removeFromSuperview()
            self.text?.removeFromSuperview()
            
            self.view.removeFromSuperview()
            self.removeFromParent()
            
        })
    }
    
    func hiddenInModalViewController()
    {
        UIView.animate(withDuration: 0.15, animations: {self.text?.alpha = 0})
        
        UIView.animate(withDuration: 0.30, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations:
            {
                Tools.pullViewCenter(View: self.leftView!, Points: (self.leftView?.frame.size.width)!)
                Tools.pushViewCenter(View: self.rightView!, Points: (self.rightView?.frame.size.width)!)
                
        }, completion: { _ in
            
            self.leftView?.removeFromSuperview()
            self.rightView?.removeFromSuperview()
            self.background?.removeFromSuperview()
            self.text?.removeFromSuperview()
            
            self.view.removeFromSuperview()
            self.removeFromParent()
            
        })
    }
    
}

