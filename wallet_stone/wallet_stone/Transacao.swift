//
//  Transacao.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 29/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

//_ clienteID: String, moedaNome: String, valor: Double, novoSaldo: Double
func saveTransacation(_ clienteID: String, moedaNome: String, valor: Double, tipo: String) {
    
    let realm = try! Realm()
    
    //Filtra moeda pelo nome
    let detailMoeda = realm.objects(Moeda.self).filter("nome = %@", moedaNome)
    
    //Cria dados da Transação de compra
    let transacao = Transacoes()
    transacao.transacaoID = UUID().uuidString
    transacao.clienteID = clienteID
    transacao.moedaID = (detailMoeda.first?.moedaID)!
    transacao.tipo = tipo
    transacao.valorTransacao = valor
    transacao.dataHoraTransacao = ""
    
    try! realm.write {
        realm.add(transacao)
        print("Transação \(transacao.transacaoID) adicionado no Realm.")
    }
}
