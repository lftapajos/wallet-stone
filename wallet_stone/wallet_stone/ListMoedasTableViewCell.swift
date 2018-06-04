//
//  ListMoedasTableViewCell.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 27/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class ListMoedasTableViewCell: UITableViewCell {

    // MARK: Declarações
    @IBOutlet weak var moedaLabel: UILabel!
    @IBOutlet weak var quantidadeLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var trocaButton: UIButton!
    
    let clienteModel = ClienteModel()
    let estoqueModel = EstoqueModel()
    
    // MARK: Configura célula
    func configuraCelulaMoeda(moeda: Moeda) {
    
        //Recupera o usuário pelo e-mail logado
        let email = UserDefaults.standard.string(forKey: "emailCliente")
        let cliente = clienteModel.listDetailCliente(email!)
        
        moedaLabel.text = moeda.nome
        
        var estoque = Estoque()
        
        if (moeda.nome == MOEDA_BRITA) {
            
            estoque = estoqueModel.listAllEstoqueByClienteCoin(cliente.clienteID, moedaNome: MOEDA_BRITA)
            
            quantidadeLabel.text = "Quantidade de moedas: \(Double(estoque.quantidade).rounded(toPlaces: 4))"
            
            if (estoque.saldo < 0) {
                
                //Zera Estoque
                estoqueModel.zeraSaldoClienteByCoin(cliente.clienteID, moedaNome: MOEDA_BRITA)
                
                valorLabel.text = "Valores: \(Help().formatCoin("pt_BR", valor: 0))"
            } else {
                valorLabel.text = "Valores: \(Help().formatCoin("pt_BR", valor: estoque.saldo))"
            }
            
        } else if (moeda.nome == MOEDA_BTC) {
           
            let cotacaoDolar = MoedaModel().loadCoinByName(MOEDA_BRITA).cotacaoCompra
            
            estoque = estoqueModel.listAllEstoqueByClienteCoin(cliente.clienteID, moedaNome: MOEDA_BTC)
            
            let quantidadeArredondada = Double(estoque.quantidade).rounded(toPlaces: 7)
            let cotacaoArredondada = Double(moeda.cotacaoCompra).rounded(toPlaces: 4)
            let novoSaldo = ((quantidadeArredondada * cotacaoArredondada) * cotacaoDolar)
            
            quantidadeLabel.text = "Quantidade de moedas: \(Double(estoque.quantidade).rounded(toPlaces: 7))"

            if (estoque.saldo < 0) {
                
                //Zera Estoque
                estoqueModel.zeraSaldoClienteByCoin(cliente.clienteID, moedaNome: MOEDA_BTC)
                
                valorLabel.text = "Valores: \(Help().formatCoin("pt_BR", valor: 0))"
            } else {
                valorLabel.text = "Valores: \(Help().formatCoin("pt_BR", valor: novoSaldo))"
            }
        }
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red:0.60, green:0.88, blue:0.96, alpha:1.0).cgColor
        self.layer.cornerRadius = 8
        
    }
    
    // MARK: Métodos
    @IBAction func trocarMoedas(_ sender: Any) {
        
        let moedaNome = moedaLabel.text
        
        //Envia notificação de mensagem
        let mensagemDict:[String: String] = ["moedaNome": moedaNome!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "trocaMoedaButton"), object: nil, userInfo: mensagemDict)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

// MARK: Configura botões de retorno do teclado
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

// MARK: Adiciona função ao Double
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
