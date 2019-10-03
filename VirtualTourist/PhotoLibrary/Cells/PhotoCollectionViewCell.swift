//
//  PhotoCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Elaine Ernst on 2019/10/01.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(image: UIImage){
        self.photo.image = image
    }

}
