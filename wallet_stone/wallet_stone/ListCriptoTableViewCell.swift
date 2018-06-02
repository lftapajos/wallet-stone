//
//  ListCriptoTableViewCell.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 26/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class ListCriptoTableViewCell: UITableViewCell, UITextFieldDelegate {

    var valorCotacaoCompra = 0.0
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
    
    func configuraCelulaMoeda(clienteID: String, saldo: Double, cripto: Moeda) { //index: Int, Dolar
        
        moedaLabel.text = cripto.nome
        moedaAtual = cripto.nome
        saldoAtual = saldo
        paramClienteID = clienteID
        
        let cotacaoCompra = formatCoin("en_US", valor: cripto.cotacaoCompra)
        let cotacaoVenda = formatCoin("en_US", valor: cripto.cotacaoVenda)
        
        cotacaoCompraLabel.text = "Cotação de Compra: U\(String(describing: cotacaoCompra))"
        cotacaoVendaLabel.text = "Cotação de Venda: U\(String(describing: cotacaoVenda))"
        dataHoraCotacaoLabel.text = "Data: \(cripto.dataHoraCotacao)"
        
        valorCotacaoCompra = cripto.cotacaoCompra
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red:0.60, green:0.88, blue:0.96, alpha:1.0).cgColor
        self.layer.cornerRadius = 8
        
        quantidadeTextField.delegate = self
    }
    
    func doneButtonTappedForMyNumericTextField() {
        
        quantidadeTextField.resignFirstResponder()
        let quantidade = quantidadeTextField.text
        
        if ((quantidade! == "") || (Double(quantidade!)! == 0.0)) {
            print("Favor preencher uma quantidade válida!")
            
            //Envia notificação de mensagem
            let mensagemDict:[String: String] = ["mensagem": "Favor preencher uma quantidade válida!"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mensagemRetorno"), object: nil, userInfo: mensagemDict)
            
        } else {
            
            //Calcula compra da Moeda Brita
            if (moedaAtual == MOEDA_BRITA) {
                
                //Calcula Brita
                buyBrita(Double(quantidade!)!)
            }
            
            //Calcula compra da Moeda Bitcoin BTC
            if (moedaAtual == MOEDA_BTC) {
                
                //Calcula BTC
                buyBtc(Double(quantidade!)!)
            }
        }
        quantidadeTextField.text = ""
    }
    
    //Função para comprar moeda Brita
    func buyBrita(_ quantidade: Double) {
        
        //calculateBuyBrita
        calculateBuyBrita(quantidade, valorCotacaoCompra: valorCotacaoCompra, saldoAtual: saldoAtual, clienteID: paramClienteID, moedaAtual: moedaAtual, completion: { (novo_saldo) in
            
            //Se salvou, mostra o novo saldo
            if (novo_saldo > 0) {
                //Envia notificação para atualizar o saldo
                let saldoDict:[String: Double] = ["saldo": novo_saldo]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "atualizaSaldo"), object: nil, userInfo: saldoDict)
            }
        }, failureBlock: {
            //print("Erro!")
        })
    }
    
    //Função para comprar moeda BTC
    func buyBtc(_ quantidade: Double) {
        
        //calculateBuyBtc
        calculateBuyBtc(quantidade, valorCotacaoCompra: valorCotacaoCompra, saldoAtual: saldoAtual, clienteID: paramClienteID, moedaAtual: moedaAtual, completion: { (novo_saldo) in
            
            //Se salvou, mostra o novo saldo
            if (novo_saldo > 0) {
                //Envia notificação para atualizar o saldo
                let saldoDict:[String: Double] = ["saldo": novo_saldo]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "atualizaSaldo"), object: nil, userInfo: saldoDict)
            }
        }, failureBlock: {
            //print("Erro!")
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
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
