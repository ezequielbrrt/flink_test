//
//  ModalLocationViewController.swift
//  flink
//
//  Created by Ezequiel Barreto on 08/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import UIKit

class ModalLocationViewController: UIViewController {

    //MARK: UIELEMENTS
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimensionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var typeTitleLabel: UILabel!
    @IBOutlet weak var dimentsionTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var stackView: [UIStackView]!
    
    // MARK: VARIABLES
    var isLocation: Bool = true
    var locationId: String?
    var vm: LocationViewModel = LocationViewModel()
    var vmEpisode: EpisodeViewModel = EpisodeViewModel()
    var episodeVariables = ["Episode", "Air Date", "Episode location"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        populateData()
        
    }

    // MARK: CONFIGURATION METHODS
    
    private func populateData(){

        if Tools.hasInternet(){
            if isLocation {
                Webservice().load(resource:LocationDetailRequests.getLocationDetail(locationId: locationId!)){[weak self] result in
                    DispatchQueue.main.async {
                        switch result{
                            case .success(let response):
                                self?.loader.stopAnimating()
                                self?.showElements(hidden: false)
                                self?.vm.location = response
                                self?.setUpData(location: (self?.vm.location!)!)
                                
                            case .failure(let error):
                                print(error)
                        }
                    }
                    
                }
            }else{
               Webservice().load(resource:EpisodeRequest.getEpisodeId(episodeId: locationId!)){[weak self] result in
                    DispatchQueue.main.async {
                        switch result{
                            case .success(let response):
                                self?.loader.stopAnimating()
                                self?.showElements(hidden: false)
                                self?.vmEpisode.episode = response
                                self?.setUpDataEpisode(episode: (self?.vmEpisode.episode!)!)
                                
                            case .failure(let error):
                                print(error)
                        }
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
    
    private func setUpDataEpisode(episode: EpisodeDetail){
        self.nameLabel.text = episode.name
        self.typeLabel.text = episode.episode
        self.dimensionLabel.text = episode.airDate
        self.typeTitleLabel.text = self.episodeVariables[0]
        self.dimentsionTitleLabel.text = self.episodeVariables[1]
        self.titleLabel.text = self.episodeVariables[2]
    }
    
    private func showElements(hidden: Bool){
        self.titleLabel.isHidden = hidden
        for sv in stackView{
            sv.isHidden = hidden
        }
    }
    
    private func configUI(){
        loader.style = .large
        loader.color = AppConfigurator.mainColor
        loader.hidesWhenStopped = true
        loader.startAnimating()
        showElements(hidden: true)
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.containerView.layer.cornerRadius = 15
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(handleClick))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        self.backgroundView.addGestureRecognizer(tapBack)
    }
    
    // MARK: CARDS CLICKS METHODS
    @objc func handleClick(gesture: UITapGestureRecognizer) {
        self.closeView()
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
       
       if gesture.direction == .down {
        self.closeView()
       }
        
    }
    
    // MARK: CLOSE VIEW
    func closeView(){
        self.dismiss(animated: true, completion: nil)
    }
}
