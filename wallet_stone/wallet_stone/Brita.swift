//
//  Brita.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 27/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

func addCotacaoBrita(_ nome: String, cotacaoCompra: Double, cotacaoVenda: Double, dataHoraCotacao: String) {
    
    let moeda = Brita()
    
    moeda.nome = nome
    moeda.cotacaoCompra = cotacaoCompra
    moeda.cotacaoVenda = cotacaoVenda
    moeda.dataHoraCotacao = dataHoraCotacao
    
    let realm = try! Realm()
    
    deleteCotacaoBrita()
    
    try! realm.write {
        realm.add(moeda)
        print("Cotação da moeda \(moeda.nome) adicionado no Realm.")
    }
}

func listCotacaoBrita() -> [Brita] {
    
    let realm = try! Realm()
    
    let allCotacaoBrita = realm.objects(Brita.self)
    
    return [allCotacaoBrita[0]]
    
//    for brita in allCotacaoBrita {
//        //print("Brita: \(brita.nome)")
//        return brita
//    }
    
}

func deleteCotacaoBrita() { //moeda: Brita
    
    let realm = try! Realm()
    
    let allCotacaoBrita = realm.objects(Brita.self)
    
    try! realm.write {
        realm.delete(allCotacaoBrita)
    }
}
