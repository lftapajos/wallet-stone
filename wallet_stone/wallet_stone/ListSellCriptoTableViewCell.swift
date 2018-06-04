//
//  ListSellCriptoTableViewCell.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 29/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class ListSellCriptoTableViewCell: UITableViewCell, UITextFieldDelegate {

    // MARK: Deckarações
    var valorCotacaoVenda = 0.0
    var saldoAtual = 0.0
    var moedaAtual = ""
    var paramClienteID = ""
    
    let clienteModel = ClienteModel()
    let moedaModel = MoedaModel()
    let transacaoModel = TransacaoModel()
    let estoqueModel = EstoqueModel()
    
    @IBOutlet weak var moedaLabel: UILabel!
    @IBOutlet weak var cotacaoCompraLabel: UILabel!
    @IBOutlet weak var cotacaoVendaLabel: UILabel!
    @IBOutlet weak var dataHoraCotacaoLabel: UILabel!
    @IBOutlet weak var quantidadeTextField: UITextField!{
        didSet {
            quantidadeTextField?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    
    // MARK: Configura célula
    func configuraCelulaMoeda(clienteID: String, saldo: Double, cripto: Moeda) {
        
        moedaLabel.text = cripto.nome
        moedaAtual = cripto.nome
        saldoAtual = saldo
        paramClienteID = clienteID
        
        let cotacaoCompra = Help().formatCoin("en_US", valor: cripto.cotacaoCompra)
        let cotacaoVenda = Help().formatCoin("en_US", valor: cripto.cotacaoVenda)
        
        cotacaoCompraLabel.text = "Cotação de Compra: U\(String(describing: cotacaoCompra))"
        cotacaoVendaLabel.text = "Cotação de Venda: U\(String(describing: cotacaoVenda))"
        dataHoraCotacaoLabel.text = "Data: \(cripto.dataHoraCotacao)"
        
        valorCotacaoVenda = cripto.cotacaoVenda
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red:0.60, green:0.88, blue:0.96, alpha:1.0).cgColor
        //UIColor(red:0.26, green:0.62, blue:0.00, alpha:1.0).cgColor
        self.layer.cornerRadius = 8
        
        quantidadeTextField.delegate = self
        
        //Verifica a soma de moedas do Cliente
        let verificaQuantidade = transacaoModel.listAllQuantityByClienteCoin(clienteID, moedaNome: cripto.nome)
        if (verificaQuantidade <= 0) {
            
            removeQuantity()
        }
    }
    
    // MARK: Remove Campos
    func removeQuantity() {
        let label = UILabel()
        label.text = "0"
        label.numberOfLines = 0 // 0 = as many lines as the label needs
        label.frame.origin.x = quantidadeTextField.frame.origin.x
        label.frame.origin.y = quantidadeTextField.frame.origin.y
        label.frame.size.width = quantidadeTextField.bounds.width
        label.font = UIFont(name: "Avenir-Medium", size: 13)
        label.textColor = UIColor(red:0.15, green:0.65, blue:0.74, alpha:1.0)
        label.textAlignment = .center
        label.sizeToFit()
        self.addSubview(label)
        
        quantidadeTextField.removeFromSuperview()
    }
    
    // MARK: Done
    func doneButtonTappedForMyNumericTextField() {
        
        quantidadeTextField.resignFirstResponder()
        let quantidade = quantidadeTextField.text
        
        if ((quantidade! == "") || (Double(quantidade!)! == 0.0)) {
            
            //Envia notificação de mensagem
            let mensagemDict:[String: String] = ["mensagem": "Favor preencher uma quantidade válida!"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mensagemRetorno"), object: nil, userInfo: mensagemDict)
            
        } else {
            
            //Calcula compra da Moeda Brita
            if (moedaAtual == MOEDA_BRITA) {
                
                //Calculo Brita
                sellBrita(Double(quantidade!)!)
            }
            
            //Calcula compra da Moeda Bitcoin BTC
            if (moedaAtual == MOEDA_BTC) {
                
                //Calculo BTC
                sellBtc(Double(quantidade!)!)
            }
            
        }
        quantidadeTextField.text = ""
    }
    
    func sellBrita(_ quantidade: Double) {
        
        //calculateSellBrita
        Help().calculateSellBrita(quantidade, valorCotacaoVenda: valorCotacaoVenda, saldoAtual: saldoAtual, clienteID: paramClienteID, moedaAtual: moedaAtual, completion: { (retorno) in
            
            let erro = retorno["erro"]! as! Int
            let removeCampos = retorno["remove_campos"]! as! Int
            
            if (erro == 0) {
                //Envia notificação para atualizar o saldo
                let saldoDict:[String: Double] = ["saldo": retorno["novo_saldo"] as! Double]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "atualizaSaldo"), object: nil, userInfo: saldoDict)
                
                if (removeCampos == 1) {
                    self.removeQuantity()
                }
                
            } else {
                //Envia notificação de mensagem
                let mensagemDict:[String: String] = ["mensagem": "Saldo insuficiente!"]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mensagemRetorno"), object: nil, userInfo: mensagemDict)
            }
        }, failureBlock: {
            //print("Erro!")
        })
    }
    
    func sellBtc(_ quantidade: Double) {
        
        //calculateBuyBtc
        Help().calculateSellBtc(quantidade, valorCotacaoVenda: valorCotacaoVenda, saldoAtual: saldoAtual, clienteID: paramClienteID, moedaAtual: moedaAtual, completion: { (retorno) in
            
            let erro = retorno["erro"]! as! Int
            let removeCampos = retorno["remove_campos"]! as! Int
            
            if (erro == 0) {
                //Envia notificação para atualizar o saldo
                let saldoDict:[String: Double] = ["saldo": retorno["novo_saldo"] as! Double]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "atualizaSaldo"), object: nil, userInfo: saldoDict)
                
                if (removeCampos == 1) {
                    self.removeQuantity()
                }
                
            } else {
                //Envia notificação de mensagem
                let mensagemDict:[String: String] = ["mensagem": "Saldo insuficiente!"]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mensagemRetorno"), object: nil, userInfo: mensagemDict)
            }
        }, failureBlock: {
            //print("Erro!")
        })
    }
    
    // MARK: TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }

    // MARK: Métodos
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
