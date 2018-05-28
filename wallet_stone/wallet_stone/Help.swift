//
//  Help.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 28/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation

func formatMoeda(_ codigo: String, valor: Double) -> String {
    
    let formatter = NumberFormatter()
    let locale = Locale(identifier: codigo)
    formatter.locale = locale
    formatter.numberStyle = .currency
    let valorFormatado = formatter.string(from: valor as NSNumber)
    return valorFormatado!
    
}

//func calculaCompraMoeda(_ saldo: Double, valorBruto: Double, conversao: String) {
//    
//}
