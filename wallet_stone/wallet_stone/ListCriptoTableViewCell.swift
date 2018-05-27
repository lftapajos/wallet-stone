//
//  ListCriptoTableViewCell.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 26/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class ListCriptoTableViewCell: UITableViewCell {

    @IBOutlet weak var moedaLabel: UILabel!
    @IBOutlet weak var cotacaoCompraLabel: UILabel!
    @IBOutlet weak var cotacaoVendaLabel: UILabel!
    @IBOutlet weak var dataHoraCotacaoLabel: UILabel!
    
    func configuraCelulaBrita(cripto: Brita) { //index: Int, Dolar
        
        moedaLabel.text = cripto.nome
        cotacaoCompraLabel.text = "Cotação de Compra: \(String(describing: cripto.cotacaoCompra))"
        cotacaoVendaLabel.text = "Cotação de Venda: \(String(describing: cripto.cotacaoVenda))"
        dataHoraCotacaoLabel.text = "Data: \(cripto.dataHoraCotacao)"
        
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
