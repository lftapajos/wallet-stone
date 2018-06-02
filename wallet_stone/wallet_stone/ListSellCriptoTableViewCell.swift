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
    
    func doneButtonTappedForMyNumericTextField() {
        
        quantidadeTextField.resignFirstResponder()
        let quantidade = quantidadeTextField.text
        
        if ((quantidade! == "") || (Double(quantidade!)! == 0.0)) {
            //print("Favor preencher uma quantidade válida!")
            
            //Envia notificação de mensagem
            let mensagemDict:[String: String] = ["mensagem": "Favor preencher uma quantidade válida!"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mensagemRetorno"), object: nil, userInfo: mensagemDict)
            
        } else {
            
            //Calcula compra da Moeda Brita
            if (moedaAtual == MOEDA_BRITA) {
                
                //Calculo Brita
                calculateBrita(Double(quantidade!)!)
            }
            
            //Calcula compra da Moeda Bitcoin BTC
            if (moedaAtual == MOEDA_BTC) {
                
                //Calculo BTC
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
        
        //novo_saldo = (Double(saldo) + (quantidade * cotacao_Compra))
        
        //Calcula Brita
        let valor_venda = (formatCurrency(quantidade) * formatCurrency(valorCotacaoVenda))
        //print("valor_venda =====> \(valor_venda)")
        
        let saldoFormatado = formatCurrency(Double(saldoAtual))
        //print("saldoFormatado =====> \(saldoFormatado)")
        
        let novo_saldo = (saldoFormatado + valor_venda)
        //print("novo_saldo =====> \(novo_saldo)")
        
        //Verifica a soma de moedas do Cliente
        let verificaQuantidade = transacaoModel.listAllQuantityByClienteCoin(paramClienteID, moedaNome: moedaAtual)
        //print("verificaQuantidade =====> \(verificaQuantidade)")
        
        //Verifica se existe saldo suciciente para a compra
        if (verificaQuantidade >= quantidade) {
            
            //Verifica se existe saldo suciciente para a compra
            if (novo_saldo > 0) {
                
                //Atualiza saldo do Estoque
                estoqueModel.updateSaldoCliente(paramClienteID, moedaNome: MOEDA_BRITA, novaQuantidade: -quantidade, novoSaldo: -valor_venda)
                
                //Atualiza saldo do Cliente
                clienteModel.atualizaSaldoCliente(paramClienteID, novoSaldo: novo_saldo)
                
                //Grava Transação de venda
                transacaoModel.saveTransacation(paramClienteID, moedaNome: moedaAtual, valor: valor_venda, tipo: "VENDA", quantidade: quantidade)
                
                //Verifica a soma de moedas do Cliente
                let verificaQuantidade = transacaoModel.listAllQuantityByClienteCoin(paramClienteID, moedaNome: moedaAtual)
                
                //Remove campo de quantidade se o saldo zerar
                if (verificaQuantidade <= 0) {
                    removeQuantity()
                }
                
                //Envia notificação para atualizar o saldo
                let saldoDict:[String: Double] = ["saldo": novo_saldo]
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
    
    func calculateBtc(_ quantidade: Double) {
        
        //calculateBuyBtc
        
        //Recupera a Cotação do Dólar
        let cotacaoDolar = moedaModel.loadDollarQuotes(MOEDA_BRITA)
        
        //Recupera a Cotação de BTC
        let cotacaoBtc = moedaModel.loadDollarQuotes(MOEDA_BTC)
        
        //Converte a cotação para Real
        let cotacao_formatada = (formatCurrency(cotacaoBtc.cotacaoVenda) * formatCurrency(cotacaoDolar.cotacaoVenda))
        //print("cotacao_formatada =====> \(cotacao_formatada)")
        
        //Calcula o valor da venda em reais
        let valor_venda = (quantidade * formatCurrency(cotacao_formatada))
        //print("valor_venda =====> \(valor_venda)")
        
        //Saldo atual formatado
        let saldoFormatado = formatCurrency(Double(saldoAtual))
        //print("saldoFormatado =====> \(saldoFormatado)")
        
        //Calcula novo saldo em reais
        let novo_saldo = (saldoFormatado + valor_venda)
        //print("novo_saldo =====> \(novo_saldo)")
        
        //Verifica a soma de moedas do Cliente
        let verificaQuantidade = formatCurrency(transacaoModel.listAllQuantityByClienteCoin(paramClienteID, moedaNome: moedaAtual))
        //print("verificaQuantidade =====> \(verificaQuantidade)")
        
        //Verifica se existe saldo suciciente para a compra
        if (verificaQuantidade >= quantidade) {
            
            //Verifica se existe saldo suciciente para a compra
            if (novo_saldo > 0) {
                
                //Atualiza saldo do Estoque
                estoqueModel.updateSaldoCliente(paramClienteID, moedaNome: MOEDA_BTC, novaQuantidade: -quantidade, novoSaldo: -valor_venda)
                
                //Atualiza saldo do Cliente
                clienteModel.atualizaSaldoCliente(paramClienteID, novoSaldo: novo_saldo)
                
                //Grava Transação de venda
                transacaoModel.saveTransacation(paramClienteID, moedaNome: moedaAtual, valor: valor_venda, tipo: "VENDA", quantidade: quantidade)
                
                //Verifica a soma de moedas do Cliente
                let verificaQuantidade = transacaoModel.listAllQuantityByClienteCoin(paramClienteID, moedaNome: moedaAtual)
                if (verificaQuantidade <= 0) {
                    removeQuantity()
                }
                
                //Envia notificação para atualizar o saldo
                let saldoDict:[String: Double] = ["saldo": novo_saldo]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "atualizaSaldo"), object: nil, userInfo: saldoDict)
            } else {
                //Envia notificação de mensagem
                let mensagemDict:[String: String] = ["mensagem": "Saldo insuficiente!"]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mensagemRetorno"), object: nil, userInfo: mensagemDict)
            }
        } else {
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
