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
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var trocaButton: UIButton!
    
    //Confihura a célula de Moedas
    func configuraCelulaMoeda(quantidade: Double, valor: Double, moeda: Moeda) {
        
        moedaLabel.text = moeda.nome
        quantidadeLabel.text = "Quantidade de moedas: \(quantidade)"
        
        if (moeda.nome == "Brita") {
            valorLabel.text = "Valores: \(formatCoin("pt_BR", valor: valor))"
        } else if (moeda.nome == "BTC") {
            valorLabel.text = "Valores: U\(formatCoin("en_US", valor: valor))"
        }
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red:0.60, green:0.88, blue:0.96, alpha:1.0).cgColor
        self.layer.cornerRadius = 8
        
        //Verifca o saldo do cliente para a moeda selecionada
//        if (quantidade <= 0) {
//            trocaButton.removeFromSuperview()
//        }
        
    }
    
    @IBAction func trocarMoedas(_ sender: Any) {
        
        let moedaNome = moedaLabel.text
        
        //Envia notificação de mensagem
        let mensagemDict:[String: String] = ["moedaNome": moedaNome!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "trocaMoedaButton"), object: nil, userInfo: mensagemDict)
        
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

//Configura botões de retorno do teclado
extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    func doneButtonTapped() { self.resignFirstResponder() }
    func cancelButtonTapped() { self.resignFirstResponder() }
}
