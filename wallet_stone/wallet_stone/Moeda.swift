//
//  Moeda.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 27/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

//Adiciona uma nova moedas ao Realm
func addMoeda(_ nome: String, cotacaoCompra: Double, cotacaoVenda: Double, dataHoraCotacao: String) {
    
    let moeda = Moeda()
    
    moeda.moedaID = UUID().uuidString
    moeda.nome = nome
    moeda.cotacaoCompra = cotacaoCompra
    moeda.cotacaoVenda = cotacaoVenda
    moeda.dataHoraCotacao = dataHoraCotacao
    
    let realm = try! Realm()
    
    try! realm.write {
        realm.add(moeda)
        print("Moeda \(moeda.nome) adicionada no Realm.")
    }
}

//Remove todas as moedas
func deleteMoeda() {
    
    let realm = try! Realm()
    
    let allMoedas = realm.objects(Moeda.self)
    
    try! realm.write {
        realm.delete(allMoedas)
    }
}

//Lista todas as moedas registradas
func listMoedas() -> [Moeda] {
    
    let realm = try! Realm()
    
    let allMoedas = realm.objects(Moeda.self)
    
    let moedas = Array(allMoedas)
    
    return moedas
}

//Recupera as cotações de compra e venda do dólar pela Moeda Brita
func loadDollarQuotes(_ nome: String) -> Moeda {
    let realm = try! Realm()
    
    let allMoedas = realm.objects(Moeda.self).filter("nome = %@", nome)
    
    return allMoedas[0]
}

//Recupera dados da moeda pela moedaID
func loadCoinByName(_ nome: String) -> Moeda {
    
    let realm = try! Realm()
    let moeda = Moeda()
    
    let detailMoeda = realm.objects(Moeda.self).filter("nome = %@", nome) //moedaID
    
    for m in detailMoeda {
        
        moeda.moedaID = m.moedaID
        moeda.nome = m.nome
        moeda.cotacaoCompra = m.cotacaoCompra
        moeda.cotacaoVenda = m.cotacaoVenda
        moeda.dataHoraCotacao = m.dataHoraCotacao
    }
    
    return moeda
}

//Recupera dados da moeda para troca
func loadChangeCoinByName(_ nome: String) -> Moeda {
    
    let realm = try! Realm()
    let moeda = Moeda()
    
    let detailMoeda = realm.objects(Moeda.self).filter("nome != %@", nome)
    
    for m in detailMoeda {
        
        moeda.moedaID = m.moedaID
        moeda.nome = m.nome
        moeda.cotacaoCompra = m.cotacaoCompra
        moeda.cotacaoVenda = m.cotacaoVenda
        moeda.dataHoraCotacao = m.dataHoraCotacao
    }
    
    return moeda
}
