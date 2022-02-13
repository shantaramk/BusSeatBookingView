//
//  BusSeatCell.swift
//  BusSeat
//
//  Created by Dkatalis on 12/02/22.
//

import UIKit

class BusSeatCell: UICollectionViewCell {

    @IBOutlet weak var seatIcon: UIImageView!
    @IBOutlet weak var seatNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialisation code
    }
    
    func setData(item: String) {
        seatNumberLabel.text = item
        seatIcon.image = UIImage(named: "seat-empty")
        seatIcon.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        seatIcon.layer.cornerRadius = 6.0
    }
}
