//
//  ModalLocationViewController.swift
//  flink
//
//  Created by beTech CAPITAL on 08/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import UIKit

class ModalLocationViewController: UIViewController {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimensionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var locationId: String?
    var vm: LocationViewModel = LocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        populateData()
        
    }

    private func populateData(){

        if Tools.hasInternet(){
            Webservice().load(resource:LocationDetailRequests.getLocationDetail(locationId: locationId!)){[weak self] result in
                DispatchQueue.main.async {
                    switch result{
                        case .success(let response):
                            self?.loader.stopAnimating()
                            self?.vm.location = response
                            self?.setUpData(location: (self?.vm.location!)!)
                            
                        case .failure(let error):
                            
                            print(error)
                    }
                }
                
            }
        }
        
    }
    
    private func setUpData(location: LocationDetail){
        self.nameLabel.text = location.name
        self.typeLabel.text = location.type
        self.dimensionLabel.text = location.dimension
    }
    
    private func configUI(){
        loader.style = .large
        loader.color = AppConfigurator.mainColor
        loader.hidesWhenStopped = true
        loader.startAnimating()

        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.containerView.layer.cornerRadius = 15
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(handleClick))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        self.backgroundView.addGestureRecognizer(tapBack)
    }
    
    @objc func handleClick(gesture: UITapGestureRecognizer) {
        self.closeView()
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
       
       if gesture.direction == .down {
        self.closeView()
       }
        
    }
    
    
    func closeView(){
        self.dismiss(animated: true, completion: nil)
    }
}
