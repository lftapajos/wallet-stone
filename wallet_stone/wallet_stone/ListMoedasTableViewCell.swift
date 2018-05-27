//
//  ListMoedasTableViewCell.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 27/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class ListMoedasTableViewCell: UITableViewCell {

    @IBOutlet weak var moedaLabel: UILabel!
    @IBOutlet weak var quantidadeLabel: UILabel!
    
    func configuraCelulaMoeda(moeda: Moeda) {
        
        moedaLabel.text = moeda.nome
        quantidadeLabel.text = "\(String(describing: moeda.quantidade))"
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red:0.26, green:0.62, blue:0.00, alpha:1.0).cgColor
        self.layer.cornerRadius = 8
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
