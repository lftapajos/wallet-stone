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
            if (moedaAtual == "Brita") {
                
                //Calcula Brita
                calculateBrita(Double(quantidade!)!)
            }
            
            //Calcula compra da Moeda Bitcoin BTC
            if (moedaAtual == "BTC") {
                
                //Calcula BTC
                calculateBtc(Double(quantidade!)!)
            }
        }
        
        quantidadeTextField.text = ""
    }
    
    func formatCurrency(_ value: Double) -> Double{
        
        let stringValue = String(format: "%.2f", value)
        let outputString = Double(stringValue)
        
        return outputString!
    }
    
    func calculateBrita(_ quantidade: Double) {
        
        //calculateBuyBrita
        
        //Calcula Brita
        let valor_compra = (formatCurrency(quantidade) * formatCurrency(valorCotacaoCompra))
        print("valor_compra =====> \(valor_compra)")
        
        let saldoFormatado = formatCurrency(Double(saldoAtual))
        print("saldoFormatado =====> \(saldoFormatado)")
        
        let novo_saldo = (saldoFormatado - valor_compra)
        print("novo_saldo =====> \(novo_saldo)")
        
        //Verifica se existe saldo suciciente para a compra
        if (novo_saldo > 0) {
            
            //Atualiza saldo do Cliente
            clienteModel.atualizaSaldoCliente(paramClienteID, novoSaldo: novo_saldo)
            
            //Grava Transação de compra
            transacaoModel.saveTransacation(paramClienteID, moedaNome: moedaAtual, valor: valor_compra, tipo: "COMPRA", quantidade: quantidade)
            
            //Envia notificação para atualizar o saldo
            let saldoDict:[String: Double] = ["saldo": novo_saldo]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "atualizaSaldo"), object: nil, userInfo: saldoDict)
            
        }
    }
    
    func calculateBtc(_ quantidade: Double) {
        
        //Recupera a Cotação do Dólar
        let cotacaoDolar = moedaModel.loadDollarQuotes("Brita")
        
        //Recupera a Cotação de BTC
        let cotacaoBtc = moedaModel.loadDollarQuotes("BTC")
        
        //Saldo atual conevertido para dólar
        let saldoAtualConvertidoDolar = (saldoAtual / cotacaoDolar.cotacaoCompra)
        
        //Converte o saldo de Reais para Dólares
        let saldoConvertido = Double(quantidade * cotacaoBtc.cotacaoCompra)
        
        //Calcula BTC
        let saldoFinalDesconvertido = calculateBuyBtc(saldoAtualConvertidoDolar, saldoConvercao: saldoConvertido, valorCotacaoCompra: cotacaoDolar.cotacaoCompra)
        
        //Verifica se existe saldo suciciente para a compra
        if (saldoFinalDesconvertido > 0) {
            
            //Valor da Transação
            let valorTransacao = (saldoAtual - saldoFinalDesconvertido)
            
            //Atualiza saldo do Cliente
            clienteModel.atualizaSaldoCliente(paramClienteID, novoSaldo: saldoFinalDesconvertido)
            
            //Grava Transação de compra
            transacaoModel.saveTransacation(paramClienteID, moedaNome: moedaAtual, valor: valorTransacao, tipo: "COMPRA", quantidade: quantidade)
            
            //Atualiza o saldo atual
            saldoAtual = saldoFinalDesconvertido
            
            //Envia notificação para atualizar o saldo
            let saldoDict:[String: Double] = ["saldo": saldoFinalDesconvertido]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "atualizaSaldo"), object: nil, userInfo: saldoDict)
            
        } else {
            //print("Operação não pode ser executa por falta de saldo!")
            
            //Envia notificação de mensagem
            let mensagemDict:[String: String] = ["mensagem": "Saldo insuficiente!"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mensagemRetorno"), object: nil, userInfo: mensagemDict)
        }
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
