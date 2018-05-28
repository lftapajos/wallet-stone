//
//  EntradaViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 25/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class EntradaViewController: UIViewController {

    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSourceArray = [Moeda]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cliente = listDetailCliente("jose@gmail.com")
        saldoLabel.text = "R$ \(cliente.saldo)"
        
        dataSourceArray = listMoedas()
//        print(dataSourceArray.count)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
        
//        let data = "2018/5/23"
        
//        //Carrega dados da cotação do Dólar
//        let apiCall = APIManager.shared.fetchCotacaoDolarFromApi()
//        apiCall.then {
//            dolares -> Void in
//            
//            self.dataSourceArray = dolares
//            self.tableView.reloadData()
//            
//        }.catch { error
//            -> Void in
//        }
        
//        //Carrega dados da cotação do Bitcoin pela data
//        let apiCall2 = APIManager.shared.fetchCotacaoBtcFromApi(data)
//        apiCall2.then {
//            bitcoins -> Void in
//            
//            print(bitcoins[0].opening ?? 0)
//            print(bitcoins[0].closing ?? 0)
//            print(bitcoins[0].quantity ?? 0)
//            print(bitcoins[0].avg_price ?? 0)
//            print(bitcoins[0].date ?? "")
//            
//            }.catch { error
//                -> Void in
//        }
        
    }

    @IBAction func retornar(_ sender: Any) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension EntradaViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath ) as! ListCriptoTableViewCell
        
        let row = indexPath.row
        //let brita = dataSourceArray[row]
        let moeda = dataSourceArray[row]
        
        cell.configuraCelulaMoeda(cripto: moeda) //dolar[row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//        
//        let contatoAtual = dataSourceArray[indexPath.row]
//        controller.contatoSelecionado = contatoAtual
//        
//        self.navigationController?.pushViewController(controller, animated: true)
//        
//    }
    
}
