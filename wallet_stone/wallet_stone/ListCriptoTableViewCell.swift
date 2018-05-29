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
        
        valorCotacaoCompra = cripto.cotacaoCompra
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red:0.26, green:0.62, blue:0.00, alpha:1.0).cgColor
        self.layer.cornerRadius = 8
        
        quantidadeTextField.delegate = self
        
    }
    
    func doneButtonTappedForMyNumericTextField() {
        //print("Done");
        
        quantidadeTextField.resignFirstResponder()
        let quantidade = quantidadeTextField.text
        
        //Calcula compra da Moeda Brita
        if (moedaAtual == "Brita") {
            
            //Calcula Brita
            let saldoFinalDesconvertido = calculaCompraBrita(Double(quantidade!)!, saldoAtual: saldoAtual, valorCotacaoCompra: valorCotacaoCompra)
            
            //Verifica se existe saldo suciciente para a compra
            if (saldoFinalDesconvertido > 0) {
                
                //Valor da Transação
                let valorTransacao = (saldoAtual - saldoFinalDesconvertido)
                
                //Atualiza saldo do Cliente
                atualizaSaldoCliente(paramClienteID, moedaNome: moedaAtual, valor: valorTransacao, novoSaldo: saldoFinalDesconvertido)
                
                //Grava Transação de compra
                saveTransacation(paramClienteID, moedaNome: moedaAtual, valor: valorTransacao, tipo: "COMPRA", quantidade: Double(quantidade!)!)
                
                //Atualiza o saldo atual
                saldoAtual = saldoFinalDesconvertido

            } else {
                print("Operação não pode ser executa por falta de saldo!")
            }
        }
        
        //Calcula compra da Moeda Bitcoin BTC
        if (moedaAtual == "BTC") {
            
            //Recupera a Cotação do Dólar
            let cotacaoDolar = recuperaCotacoesDolar()
            
            //Converte o saldo de Reais para Dólares
            let saldoConvertido = convertRealToDolar(cotacaoDolar.cotacaoCompra, valor: saldoAtual)
            
            //Calcula BTC
            let saldoFinalDesconvertido = calculaCompraBtc(Double(quantidade!)!, saldoAtualDolar: saldoConvertido, valorCotacaoCompra: cotacaoDolar.cotacaoCompra)
            
            //Verifica se existe saldo suciciente para a compra
            if (saldoFinalDesconvertido > 0) {
                
                //Valor da Transação
                let valorTransacao = (saldoAtual - saldoFinalDesconvertido)
                
                //Atualiza saldo do Cliente
                atualizaSaldoCliente(paramClienteID, moedaNome: moedaAtual, valor: valorTransacao, novoSaldo: saldoFinalDesconvertido)
                
                //Grava Transação de compra
                saveTransacation(paramClienteID, moedaNome: moedaAtual, valor: valorTransacao, tipo: "COMPRA", quantidade: Double(quantidade!)!)
                
                //Atualiza o saldo atual
                saldoAtual = saldoFinalDesconvertido
            } else {
                print("Operação não pode ser executa por falta de saldo!")
            }
            
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
