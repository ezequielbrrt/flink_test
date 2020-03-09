//
//  MessageView.swift
//  flink
//
//  Created by beTech CAPITAL on 08/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation
import UIKit

class MessageView: UIViewController {
    
    @IBOutlet weak var viewConnection : UIView?
    @IBOutlet weak var textDisplay : UILabel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        textDisplay?.text = "error de conexión"
        
        textDisplay?.adjustsFontSizeToFitWidth = true
        
        if viewConnection != nil
        {
            viewConnection?.alpha = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        //Tools.DownView(View: self.viewConnection!, Points: 100)
    }
    
    func show()
    {
        viewConnection?.alpha = 1
        
        UIView.animate(withDuration: 0.30, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations:
            {
                self.view.alpha = 1
                Tools.downView(View: self.viewConnection!, Points: 130)
                
        }, completion:
            { _ in
        })
    }
    
    func hidden()
    {
        UIView.animate(withDuration: 0.30, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations:
            {
                self.view.alpha = 0
                Tools.upView(View: self.viewConnection!, Points: 130)
                
        }, completion:
            { _ in
                
                self.view.removeFromSuperview()
                self.removeFromParent()
        })
    }
    
}

