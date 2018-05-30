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
    
    @IBOutlet weak var moedaOrigemLabel: UILabel!
    @IBOutlet weak var moedaOrigemQuantidadeLabel: UILabel!
    @IBOutlet weak var moedaOrigemValorLabel: UILabel!
    
    @IBOutlet weak var moedaTrocaLabel: UILabel!
    @IBOutlet weak var moedaTrocaQuantidadeLabel: UILabel!
    @IBOutlet weak var moedaTrocaValorLabel: UILabel!
    
    var clienteID = ""
    var moedaOrigem = ""
    var moedaTroca = ""
    
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
        
        let saldoFomatado = formatMoeda("pt_BR", valor:  Double(cliente.saldo))
        saldoLabel.text = "\(saldoFomatado)"
        
        nomeLabel.text = cliente.nome
        
        moedaOrigemLabel.text = "De: \(moedaOrigem)"
        moedaTrocaLabel.text = "Por: \(moedaTroca)"
        
        moeda1 = recuperaMoedaPorNome(moedaOrigem)
        moeda2 = recuperaMoedaPorNome(moedaTroca)
        
        let quantidadeOrigem = listAllQuantidadePorClienteMoeda(clienteID, moedaNome: moedaOrigem)
        let quantidadeTroca = listAllQuantidadePorClienteMoeda(clienteID, moedaNome: moedaTroca)

        let valorOrigem = listAllValorPorClienteMoeda(clienteID, moedaNome: moedaOrigem)
        let valorTroca = listAllValorPorClienteMoeda(clienteID, moedaNome: moedaTroca)
        
        //var valorOrigemFormatado = Double(valorOrigem)
        //var valorTrocaFormatado = Double(valorTroca)
        
        //Origem
        if (moedaOrigem == "Brita") {
            let valorOrigemFormatado = formatMoeda("pt_BR", valor: valorOrigem)
            moedaOrigemValorLabel.text = "\(valorOrigemFormatado)"
            
        } else if (moedaOrigem == "BTC") {
            //let valorOrigemConvertido = convertDolarToReal(moeda1.cotacaoCompra, valor: valorOrigem)
            let valorOrigemFormatado = formatMoeda("en_US", valor: valorOrigem)
             moedaOrigemValorLabel.text = "U\(valorOrigemFormatado)"
        }
        
        //Troca
        if (moedaTroca == "Brita") {
            let valorTrocaFormatado = formatMoeda("pt_BR", valor: valorTroca)
            moedaTrocaValorLabel.text = "\(valorTrocaFormatado)"
            
        } else if (moedaTroca == "BTC") {
            let valorTrocaFormatado = formatMoeda("en_US", valor: valorTroca)
            moedaTrocaValorLabel.text = "U\(valorTrocaFormatado)"
        }
        
        moedaOrigemQuantidadeLabel.text = "\(quantidadeOrigem)"
        moedaTrocaQuantidadeLabel.text = "\(quantidadeTroca)"
        
        //moedaTrocaValorLabel.text = "\(valorTroca)"
        
        //print("Moeda de Origem: \(moedaOrigem)")
        //print("Moeda de Troca: \(moedaTroca)")
        
    }
    
    func doneButtonTappedForMyNumericTextField() {
        quantidadeTextField.resignFirstResponder()
        
        //quantidadeTextField.text = ""

        print("Quantidade selecionada.")
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
