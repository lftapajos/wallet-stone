//
//  PerfilViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 27/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {

    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSourceArray = [Moeda]()
    var transacoes = [Transacoes]()
    
    var clienteID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        
        let email = UserDefaults.standard.string(forKey: "emailCliente")
        
        let cliente = listDetailCliente(email!)
        
        clienteID = cliente.clienteID
        
        let saldoFomatado = formatMoeda("pt_BR", valor:  Double(cliente.saldo))
        saldoLabel.text = "\(saldoFomatado)"
        
        nomeLabel.text = cliente.nome
        
        //Carrega Moedas salvas no Realm
        dataSourceArray = listMoedas()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
    }
    
    @IBAction func retornar(_ sender: Any) {
        
        //Remove login do cliente
        UserDefaults.standard.removeObject(forKey: "emailCliente")
        
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    //Chama a View que lista as Transações do cliente
    @IBAction func carregarTransacoes(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TransacoesViewController") as! TransacoesViewController
        controller.clienteID = clienteID
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //Chama a View que lista dados das moedas para salvar compras do cliente
    @IBAction func comprarMoedas(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EntradaViewController") as! EntradaViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PerfilViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath ) as! ListMoedasTableViewCell
        
        let row = indexPath.row
        let moeda = dataSourceArray[row]
        //print("moeda =====> \(moeda.moedaID)")
        
        var quantidade = 0.0
        var valor = 0.0
        
        //Carrega a soma de moedas do Cliente
        quantidade = listAllQuantidadePorClienteMoeda(clienteID, moedaNome: moeda.nome)
        
        //Carrega a soma de valores de moedas do Cliente
        valor = listAllValorPorClienteMoeda(clienteID, moedaNome: moeda.nome)
        
        //Configura a célula
        cell.configuraCelulaMoeda(quantidade: quantidade, valor: valor, moeda: moeda)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
