//
//  TrocaViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 30/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class TrocaViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var quantidadeTextField: UITextField!{
        didSet {
            quantidadeTextField?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    @IBOutlet weak var valorLabel: UILabel!
    
    @IBOutlet weak var confirmaTrocaLabel: UILabel!
    @IBOutlet weak var confirmaTrocaButton: UIButton!
    
    @IBOutlet weak var moedaOrigemLabel: UILabel!
    @IBOutlet weak var moedaOrigemQuantidadeLabel: UILabel!
    @IBOutlet weak var moedaOrigemValorLabel: UILabel!
    
    @IBOutlet weak var moedaTrocaLabel: UILabel!
    @IBOutlet weak var moedaTrocaQuantidadeLabel: UILabel!
    @IBOutlet weak var moedaTrocaValorLabel: UILabel!
    
    var clienteID = ""
    var moedaOrigem = ""
    var moedaTroca = ""
    var operacaoMinimaBrita = 3.0
    
    var quantidadeOrigem = 0.0
    var quantidadeTroca = 0.0
    
    var valorOrigem = 0.0
    var valorTroca = 0.0
    
    var moeda1 = Moeda()
    var moeda2 = Moeda()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        quantidadeTextField.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let email = UserDefaults.standard.string(forKey: "emailCliente")
        let cliente = listDetailCliente(email!)
        clienteID = cliente.clienteID
        
        let saldoFomatado = formatCoin("pt_BR", valor:  Double(cliente.saldo))
        saldoLabel.text = "\(saldoFomatado)"
        
        nomeLabel.text = cliente.nome
        
        moedaOrigemLabel.text = "De: \(moedaOrigem)"
        moedaTrocaLabel.text = "Por: \(moedaTroca)"
        
        //Recupera os dados das moedas de troca
        moeda1 = loadCoinByName(moedaOrigem)
        moeda2 = loadCoinByName(moedaTroca)
        
        //Recupera a quantidade de cada moeda para efetuar a troca
        quantidadeOrigem = listAllQuantityByClienteCoin(clienteID, moedaNome: moedaOrigem)
        quantidadeTroca = listAllQuantityByClienteCoin(clienteID, moedaNome: moedaTroca)

        //Recupera o valor de cada moeda para efetuar a troca
        valorOrigem = listAllValueByClienteCoin(clienteID, moedaNome: moedaOrigem)
        valorTroca = listAllValueByClienteCoin(clienteID, moedaNome: moedaTroca)
        
        //Formata campos para início dos cálculos
        formatInitialFields()
    }
    
    func formatInitialFields() {
        
        //Origem
        if (moedaOrigem == "Brita") {
            let valorOrigemFormatado = formatCoin("pt_BR", valor: valorOrigem)
            moedaOrigemValorLabel.text = "\(valorOrigemFormatado)"
            
        } else if (moedaOrigem == "BTC") {
            //let valorOrigemConvertido = convertDollarToReal(moeda1.cotacaoCompra, valor: valorOrigem)
            let valorOrigemFormatado = formatCoin("en_US", valor: valorOrigem)
            moedaOrigemValorLabel.text = "U\(valorOrigemFormatado)"
        }
        
        //Troca
        if (moedaTroca == "Brita") {
            let valorTrocaFormatado = formatCoin("pt_BR", valor: valorTroca)
            moedaTrocaValorLabel.text = "\(valorTrocaFormatado)"
            valorLabel.text = "\(valorTrocaFormatado)"
            
        } else if (moedaTroca == "BTC") {
            let valorTrocaFormatado = formatCoin("en_US", valor: valorTroca)
            moedaTrocaValorLabel.text = "U\(valorTrocaFormatado)"
            valorLabel.text = "U\(valorTrocaFormatado)"
        }
        
        moedaOrigemQuantidadeLabel.text = "\(quantidadeOrigem)"
        moedaTrocaQuantidadeLabel.text = "\(quantidadeTroca)"
    }
    
    func trataConfirmacaoButton(_ habilita: Bool) {
        confirmaTrocaLabel.isHidden = habilita
        confirmaTrocaButton.isHidden = habilita
    }
    
    @IBAction func confirmarTroca(_ sender: Any) {
        
        print("Confirmar a troca de moedas.")
        confirmBritaByBtc()
        
    }
    
    func confirmBritaByBtc() {
        
        let quantidade = quantidadeTextField.text
        let quantidadeDouble = Double(quantidade!)!
        
        //Calcula valor da operação
        let valor = (quantidadeDouble / moeda2.cotacaoVenda)
        
        //Operações de cálculo para conversão de Brita para BTC
        let novaQuantidadeOrigem = (quantidadeOrigem - quantidadeDouble)
        let novaQuantidadeTroca = (quantidadeTroca + valor)
        
        let novoValorOrigem = (novaQuantidadeOrigem * moeda1.cotacaoVenda)
        let novoValorTroca = (novaQuantidadeTroca * moeda2.cotacaoVenda)
        
        let novoValorOrigemConvertido = convertDollarToReal(moeda1.cotacaoVenda, valor: novoValorOrigem)
        let novoValorTrocaConvertido = (novoValorTroca + valorTroca)
      
        
        //Grava Transação de troca
        saveTransacation(clienteID, moedaNome: "Brita", valor: novoValorOrigemConvertido, tipo: "TROCA", quantidade: quantidadeDouble)
        saveTransacation(clienteID, moedaNome: "BTC", valor: novoValorTrocaConvertido, tipo: "TROCA", quantidade: novaQuantidadeTroca)
        
        //Mostra mensagem
        Alert(controller: self).showError(message: "Troca de Brita por BTC efetuada com sucesso!", handler : { action in
            self.dismiss(animated: false)
        })
        
        //Desabilita botão de confirmação
        trataConfirmacaoButton(true)
        
    }
    
    func calculateBritaByBtc() {
        
        let quantidade = quantidadeTextField.text
        
        if ((quantidade! == "") || (Double(quantidade!)! == 0.0)) {
            
            //Desabilita botão de confirmação
            trataConfirmacaoButton(true)
            
            //Mostra mensagem por quantidade válida
            Alert(controller: self).showError(message: "Favor preencher uma quantidade válida!", handler : { action in
                self.dismiss(animated: false)
            })
            
        } else {
            
            let quantidadeDouble = Double(quantidade!)!
            if (quantidadeDouble < operacaoMinimaBrita) {
                
                //Desabilita botão de confirmação
                trataConfirmacaoButton(true)
                
                //Mostra mensagem valor baixo para a operação
                Alert(controller: self).showError(message: "O valor é muito baixo para realizar esta operação!", handler : { action in
                    self.dismiss(animated: false)
                })
                
            } else {
                
                //Calcula valor da operação
                let valor = (quantidadeDouble / moeda2.cotacaoVenda)
                
                //Se a quantidade é maior que o saldo de Brita, mostra erro.
                if (quantidadeDouble > quantidadeOrigem) {
                    
                    //Desabilita botão de confirmação
                    trataConfirmacaoButton(true)
                    
                    //Mostra mensagem de saldo insuficiente
                    Alert(controller: self).showError(message: "Saldo insuficiente para realizar a troca!", handler : { action in
                        self.dismiss(animated: false)
                    })
                    
                } else {
                    
                    //Operações de cálculo para conversão de Brita para BTC
                    let novaQuantidadeOrigem = (quantidadeOrigem - quantidadeDouble)
                    let novaQuantidadeTroca = (quantidadeTroca + valor)
                    
                    let novoValorOrigem = (novaQuantidadeOrigem * moeda1.cotacaoVenda)
                    let novoValorTroca = (novaQuantidadeTroca * moeda2.cotacaoVenda)
                    
                    let novoValorOrigemConvertido = convertDollarToReal(moeda1.cotacaoVenda, valor: novoValorOrigem)
                    let novoValorTrocaConvertido = (novoValorTroca + valorTroca)
                    
                    //Atualiza campos
                    updateFieldsBritaByBtc(novaQuantidadeOrigem, valueOrigem: novoValorOrigemConvertido, qtdeChange: novaQuantidadeTroca, valueChange: novoValorTroca, valueTemp: novoValorTrocaConvertido)
                    
                    //Habilita botão de confirmação
                    trataConfirmacaoButton(false)
                }
            }
        }
    }
    
    func calculateBtcByBrita() {
        
        let quantidade = quantidadeTextField.text
        
        if ((quantidade! == "") || (Double(quantidade!)! == 0.0)) {
            
            //Desabilita botão de confirmação
            trataConfirmacaoButton(true)
            
            //Mostra mensagem por quantidade válida
            Alert(controller: self).showError(message: "Favor preencher uma quantidade válida!", handler : { action in
                self.dismiss(animated: false)
            })
            
        } else {
            
            let quantidadeDouble = Double(quantidade!)!
            //Calcula valor da operação
            let valor = (quantidadeDouble / moeda2.cotacaoVenda)
            
            //Se a quantidade é maior que o saldo de Brita, mostra erro.
            if (quantidadeDouble > quantidadeOrigem) {
                
                //Desabilita botão de confirmação
                trataConfirmacaoButton(true)
                
                //Mostra mensagem de saldo insuficiente
                Alert(controller: self).showError(message: "Saldo insuficiente para realizar a troca!", handler : { action in
                    self.dismiss(animated: false)
                })
                
            } else {
                
                //Operações de cálculo para conversão de Brita para BTC
                let novaQuantidadeOrigem = (quantidadeOrigem - quantidadeDouble)
                let novaQuantidadeTroca = (quantidadeTroca + valor)
                
                let novoValorOrigem = (novaQuantidadeOrigem * moeda1.cotacaoVenda)
                let novoValorTroca = (novaQuantidadeTroca * moeda2.cotacaoVenda)
                
                let novoValorOrigemConvertido = convertDollarToReal(moeda1.cotacaoVenda, valor: novoValorOrigem)
                let novoValorTrocaConvertido = (novoValorTroca + valorTroca)
                
                //Atualiza campos
                updateFieldsBtcByBrita(novaQuantidadeOrigem, valueOrigem: novoValorOrigemConvertido, qtdeChange: novaQuantidadeTroca, valueChange: novoValorTroca, valueTemp: novoValorTrocaConvertido)
                
                //Habilita botão de confirmação
                trataConfirmacaoButton(false)
            }
        }
        
    }
    
    func updateFieldsBritaByBtc(_ qtdeOrigem: Double, valueOrigem: Double, qtdeChange: Double, valueChange: Double, valueTemp: Double) {
        
        valorLabel.text = "U\(formatCoin("en_US", valor: valueTemp))"
        
        moedaOrigemQuantidadeLabel.text = "\(qtdeOrigem)"
        moedaOrigemValorLabel.text = "\(formatCoin("pt_BR", valor: valueOrigem))"
        
        moedaTrocaQuantidadeLabel.text = "\(qtdeChange)"
        moedaTrocaValorLabel.text = "U\(formatCoin("en_US", valor: valueTemp))"
    }
    
    func updateFieldsBtcByBrita(_ qtdeOrigem: Double, valueOrigem: Double, qtdeChange: Double, valueChange: Double, valueTemp: Double) {
        
        valorLabel.text = "\(formatCoin("pt_BR", valor: valueTemp))"
        
        moedaOrigemQuantidadeLabel.text = "\(qtdeOrigem)"
        moedaOrigemValorLabel.text = "\(formatCoin("en_US", valor: valueOrigem))"
        
        moedaTrocaQuantidadeLabel.text = "\(qtdeChange)"
        moedaTrocaValorLabel.text = "\(formatCoin("pt_BR", valor: valueTemp))"
    }
    
    func doneButtonTappedForMyNumericTextField() {
        quantidadeTextField.resignFirstResponder()
        
        if (moedaOrigem == "Brita") {
            calculateBritaByBtc()
        } else if (moedaOrigem == "BTC") {
            calculateBtcByBrita()
        }
        
    }
    
    @IBAction func retornar(_ sender: Any) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
