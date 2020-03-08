//
//  EpisodeCollectionCell.swift
//  flink
//
//  Created by beTech CAPITAL on 07/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import UIKit

class EpisodeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var episodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configUI()
    }
    
    private func configUI(){
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.shadowColor =  UIColor.gray.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.containerView.layer.shadowRadius = 5.0
        self.containerView.layer.shadowOpacity = 0.4
    }
    
}
