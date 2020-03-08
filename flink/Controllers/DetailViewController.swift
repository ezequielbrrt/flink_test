//
//  DetailViewController.swift
//  flink
//
//  Created by beTech CAPITAL on 07/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var originView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var LocationView: UIView!
    
    var character: ResultCharacter?
    var dvm: DetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateData()
        configUI()
        setUpData()
        
    }
    
    private func populateData(){
        self.dvm = DetailViewModel(character: character!)
    }
    
    private func configUI(){
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        
        configUiCard(view: self.originView)
        configUiCard(view: self.LocationView)
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


    //MARK: COLLECTIONVIEW METHODS
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
