//
//  LoaderCell.swift
//  flink
//
//  Created by Ezequiel Barreto on 06/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import UIKit

class LoaderCell: UITableViewCell {

    //MARK: UIELEMENTS
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: CONFIGURATION
    private func configUI(){
        loader.startAnimating()
        loader.color = AppConfigurator.mainColor
        loader.style = .large
    }

}
