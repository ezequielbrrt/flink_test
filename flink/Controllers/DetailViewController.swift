//
//  DetailViewController.swift
//  flink
//
//  Created by Ezequiel Barreto on 07/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UIELEMENTS
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var originView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var LocationView: UIView!
    @IBOutlet weak var episodeCollectionView: UICollectionView!
    
    // MARK: VARIABLES
    var character: ResultCharacter?
    var dvm: DetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateData()
        configUI()
        setUpData()
        
    }
    
    // MARK: POPULATEMETHODS
    private func populateData(){
        self.dvm = DetailViewModel(character: character!)
    }
    
    // MARK: CONFIGMETHODS
    private func configUI(){
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        
        configUiCard(view: self.originView)
        configUiCard(view: self.LocationView)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showLocationModal))
        let gestureOrigin = UITapGestureRecognizer(target: self, action:  #selector(self.showOriginModal))
        
        self.LocationView.addGestureRecognizer(gesture)
        self.originView.addGestureRecognizer(gestureOrigin)
    
    }
    
    private func configUiCard(view: UIView){
        view.layer.cornerRadius = 10
        view.layer.shadowColor =  UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 12.0
        view.layer.shadowOpacity = 0.4
    }
    
    private func setUpData(){
        
        self.title = self.dvm?.characterDetail.name
        self.specieLabel.text = self.dvm?.characterDetail.species
        self.statusLabel.text = self.dvm?.characterDetail.status
        self.typeLabel.text = self.dvm?.characterDetail.type
        self.genderLabel.text = self.dvm?.characterDetail.gender
        self.originLabel.text = self.dvm?.characterDetail.origin?.name
        self.locationLabel.text = self.dvm?.characterDetail.location?.name
        Tools.downloadImage(url: URL(string: self.dvm!.characterDetail.image!)!) { (image, error) in
            if error == nil {
                DispatchQueue.main.async {
                    
                    self.profileImageView.image = image
                }
            }
        }
    }
    
    // MAKR: OPENMODAL METHODS
    @objc private func showLocationModal(){
        if Tools.hasInternet(){
            showModal(id: self.dvm!.characterDetail.location!.url.components(separatedBy: "/").last!)
        }else{
            showAlertNoWifi()
        }
        
    }
    
    @objc private func showOriginModal(){
        if Tools.hasInternet(){
            showModal(id: self.dvm!.characterDetail.origin!.url.components(separatedBy: "/").last!)
        }else{
            showAlertNoWifi()
        }
        
    }
    
    private func showModal(id: String, isLocation: Bool = true){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modalLocation = storyBoard.instantiateViewController(withIdentifier: "ModalLocationViewController") as! ModalLocationViewController
        modalLocation.locationId = id
        modalLocation.isLocation = isLocation
        modalLocation.modalPresentationStyle = .overFullScreen
        self.present(modalLocation, animated: true, completion: nil)
    }
    
    private func showAlertNoWifi(){
        let alert = UIAlertController(title: Strings.noWifi, message: Strings.noWifiDesc, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default, handler:nil))
        self.present(alert, animated: true)
    }
    
    //MARK: COLLECTIONVIEW METHODS
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Tools.hasInternet(){
            let episodeUrl = self.dvm?.characterDetail.episode![indexPath.row]
            showModal(id: (episodeUrl?.components(separatedBy: "/").last)!, isLocation: false)
        }else{
            showAlertNoWifi()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dvm!.characterDetail.episode!.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let vm = self.dvm!.characterDetail.episode![indexPath.row]
        let episode = vm.components(separatedBy: "/").last
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCollectionCell", for: indexPath) as! EpisodeCollectionCell
        
        cell.episodeLabel.text = episode
        
        return cell
    }
}
