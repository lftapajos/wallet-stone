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
        print("Done");
        quantidadeTextField.resignFirstResponder()
        
        let quantidade = quantidadeTextField.text
        //print("saldoAtual =====> \(saldoAtual)")
        
        let saldoConvertido = (saldoAtual / valorCotacaoCompra)
        //print("saldoConvertido =====> \(saldoConvertido) dólares")
        
        //print("quantidadeTextField =====> \(quantidade ?? "")")
        //print("valorCotacaoCompra =====> \(valorCotacaoCompra)")
        
        let calculoCompra = (Double(quantidade!)! * valorCotacaoCompra)
        //print("calculo =====> \(calculoCompra) dólares")
        
        let calculoFinal = (saldoConvertido - calculoCompra)
        //print("saldo final =====> \(calculoFinal) dólares")
        
        let saldoFinalDesconvertido = (calculoFinal * valorCotacaoCompra)
        //print("saldo final desconvertido =====> \(saldoFinalDesconvertido) reais")
        
        //print("paramClienteID =====> \(paramClienteID)")
        
        atualizaSaldoCliente(paramClienteID, novoSaldo: saldoFinalDesconvertido)
        
        saldoAtual = saldoFinalDesconvertido
        
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
