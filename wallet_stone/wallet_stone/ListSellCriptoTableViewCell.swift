//
//  ListSellCriptoTableViewCell.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 29/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class ListSellCriptoTableViewCell: UITableViewCell, UITextFieldDelegate {

    var valorCotacaoVenda = 0.0
    var saldoAtual = 0.0
    var moedaAtual = ""
    var paramClienteID = ""
    
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
        
        let cotacaoCompra = formatMoeda("en_US", valor: cripto.cotacaoCompra)
        let cotacaoVenda = formatMoeda("en_US", valor: cripto.cotacaoVenda)
        
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
        let verificaQuantidade = listAllQuantidadePorClienteMoeda(clienteID, moedaNome: cripto.nome)
        if (verificaQuantidade <= 0) {
            
            removeQuantidade()
        }
    }
    
    func removeQuantidade() {
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
    
    func doneButtonTappedForMyNumericTextField() {
        
        quantidadeTextField.resignFirstResponder()
        let quantidade = quantidadeTextField.text
        
        if (quantidade == "") {
            print("Favor preencher uma quantidade válida!")
            
            //Envia notificação de mensagem
            let mensagemDict:[String: String] = ["mensagem": "Favor preencher uma quantidade válida!"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mensagemRetorno"), object: nil, userInfo: mensagemDict)
            
        } else {
            
            //Calcula compra da Moeda Brita
            if (moedaAtual == "Brita") {
                
                //Verifica a soma de moedas do Cliente
                let verificaQuantidade = listAllQuantidadePorClienteMoeda(paramClienteID, moedaNome: moedaAtual)
                
                //Somente executa a operação se a quantidade em saldo é maior ou igual a zero
                if (verificaQuantidade >= Double(quantidade!)!) {
                    
                    //Calcula Brita
                    let saldoFinalDesconvertido = calculaVendaBrita(Double(quantidade!)!, saldoAtual: saldoAtual, valorCotacaoVenda: valorCotacaoVenda)
                    
                    //Verifica se existe saldo suciciente para a compra
                    if (saldoFinalDesconvertido > 0) {
                        
                        //Valor da Transação
                        let valorTransacao = (saldoFinalDesconvertido - saldoAtual)
                        
                        print(valorTransacao)
                        //Atualiza saldo do Cliente
                        atualizaSaldoCliente(paramClienteID, moedaNome: moedaAtual, valor: valorTransacao, novoSaldo: saldoFinalDesconvertido)
                        
                        //Grava Transação de compra
                        saveTransacation(paramClienteID, moedaNome: moedaAtual, valor: valorTransacao, tipo: "VENDA", quantidade: Double(quantidade!)!)
                        
                        //Atualiza o saldo atual
                        saldoAtual = saldoFinalDesconvertido
                        
                        //Verifica a soma de moedas do Cliente
                        let verificaQuantidade = listAllQuantidadePorClienteMoeda(paramClienteID, moedaNome: moedaAtual)
                        //Remove campo de quantidade
                        if (verificaQuantidade <= 0) {
                            removeQuantidade()
                        }
                        
                        //Envia notificação para atualizar o saldo
                        let saldoDict:[String: Double] = ["saldo": saldoFinalDesconvertido]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "atualizaSaldo"), object: nil, userInfo: saldoDict)
                        
                        
                    } else {
                        //print("Operação não pode ser executa por falta de saldo!")
                        
                        //Envia notificação de mensagem
                        let mensagemDict:[String: String] = ["mensagem": "Saldo insuficiente!"]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mensagemRetorno"), object: nil, userInfo: mensagemDict)
                    }
                } else {
                    //print("Operação não pode ser executa por falta de saldo!")
                    
                    //Envia notificação de mensagem
                    let mensagemDict:[String: String] = ["mensagem": "Saldo insuficiente!"]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mensagemRetorno"), object: nil, userInfo: mensagemDict)
                }
            }
            
            //Calcula compra da Moeda Bitcoin BTC
            if (moedaAtual == "BTC") {
                
                //Recupera a Cotação do Dólar
                let cotacaoDolar = recuperaCotacoesDolar()
                
                //Converte o saldo de Reais para Dólares
                let saldoConvertido = convertRealToDolar(cotacaoDolar.cotacaoVenda, valor: saldoAtual)
                
                //Verifica a soma de moedas do Cliente
                let verificaQuantidade = listAllQuantidadePorClienteMoeda(paramClienteID, moedaNome: moedaAtual)
                
                //Somente executa a operação se a quantidade em saldo é maior ou igual a zero
                if (verificaQuantidade >= Double(quantidade!)!) {
                    
                    //Calcula BTC
                    let saldoFinalDesconvertido = calculaVendaBtc(Double(quantidade!)!, saldoAtualDolar: saldoConvertido, valorCotacaoVenda: cotacaoDolar.cotacaoVenda)
                    
                    //Verifica se existe saldo suciciente para a compra
                    if (saldoFinalDesconvertido > 0) {
                        
                        //Valor da Transação
                        let valorTransacao = (saldoFinalDesconvertido - saldoAtual)
                        
                        //Atualiza saldo do Cliente
                        atualizaSaldoCliente(paramClienteID, moedaNome: moedaAtual, valor: valorTransacao, novoSaldo: saldoFinalDesconvertido)
                        
                        //Grava Transação de compra
                        saveTransacation(paramClienteID, moedaNome: moedaAtual, valor: valorTransacao, tipo: "VENDA", quantidade: Double(quantidade!)!)
                        
                        //Atualiza o saldo atual
                        saldoAtual = saldoFinalDesconvertido
                        
                        //Verifica a soma de moedas do Cliente
                        let verificaQuantidade = listAllQuantidadePorClienteMoeda(paramClienteID, moedaNome: moedaAtual)
                        if (verificaQuantidade <= 0) {
                            removeQuantidade()
                        }
                        
                        //Envia notificação para atualizar o saldo
                        let saldoDict:[String: Double] = ["saldo": saldoFinalDesconvertido]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "atualizaSaldo"), object: nil, userInfo: saldoDict)
                        
                    } else {
                        //print("Operação não pode ser executa por falta de saldo!")
                        
                        //Envia notificação de mensagem
                        let mensagemDict:[String: String] = ["mensagem": "Saldo insuficiente!"]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mensagemRetorno"), object: nil, userInfo: mensagemDict)
                        
                    }
                } else {
                    //print("Operação não pode ser executa por falta de saldo!")
                    
                    //Envia notificação de mensagem
                    let mensagemDict:[String: String] = ["mensagem": "Saldo insuficiente!"]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mensagemRetorno"), object: nil, userInfo: mensagemDict)
                }
            }
            
        }
        quantidadeTextField.text = ""
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