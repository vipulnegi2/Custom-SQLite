//
//  PatientTableViewCell.swift
//  CoreDataExample
//
//  Created by Vipul Negi on 23/08/23.
//

import UIKit

class PatientTableViewCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
