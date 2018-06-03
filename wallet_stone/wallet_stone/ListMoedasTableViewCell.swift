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
    
    let clienteModel = ClienteModel()
    let estoqueModel = EstoqueModel()
    
    //Confihura a célula de Moedas
    func configuraCelulaMoeda(moeda: Moeda) {
        
        let email = UserDefaults.standard.string(forKey: "emailCliente")
        let cliente = clienteModel.listDetailCliente(email!)
        
        moedaLabel.text = moeda.nome
        
        var estoque = Estoque()
        
        if (moeda.nome == MOEDA_BRITA) {
            
            estoque = estoqueModel.listAllEstoquByClienteCoin(cliente.clienteID, moedaNome: MOEDA_BRITA)
            quantidadeLabel.text = "Quantidade de moedas: \(estoque.quantidade)"
            
            if (estoque.saldo < 0) {
                
                //Zera Estoque
                estoqueModel.zeraSaldoClienteByCoin(cliente.clienteID, moedaNome: MOEDA_BRITA)
                
                valorLabel.text = "Valores: \(Help().formatCoin("pt_BR", valor: 0))"
            } else {
                valorLabel.text = "Valores: \(Help().formatCoin("pt_BR", valor: estoque.saldo))"
            }
            
        } else if (moeda.nome == MOEDA_BTC) {
           
            estoque = estoqueModel.listAllEstoquByClienteCoin(cliente.clienteID, moedaNome: MOEDA_BTC)
            quantidadeLabel.text = "Quantidade de moedas: \(estoque.quantidade)"
            
            if (estoque.saldo < 0) {
                
                //Zera Estoque
                estoqueModel.zeraSaldoClienteByCoin(cliente.clienteID, moedaNome: MOEDA_BTC)
                
                valorLabel.text = "Valores: \(Help().formatCoin("pt_BR", valor: 0))"
            } else {
                valorLabel.text = "Valores: \(Help().formatCoin("pt_BR", valor: estoque.saldo))"
            }
        }
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red:0.60, green:0.88, blue:0.96, alpha:1.0).cgColor
        self.layer.cornerRadius = 8
        
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
