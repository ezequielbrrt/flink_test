//
//  ModalLocationViewController.swift
//  flink
//
//  Created by beTech CAPITAL on 08/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import UIKit

class ModalLocationViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimensionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var character: ResultCharacter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        
        
    }

    
    private func configUI(){
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.containerView.layer.cornerRadius = 15
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
       
       if gesture.direction == .down {
        self.closeView()
       }
    }
    
    
    func closeView(){
        self.dismiss(animated: true, completion: nil)
    }
}
