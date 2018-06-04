//
//  ApiResponse.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 24/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: API de Moedas
class ApiResponse : Mappable {
    
    var dolares : [Dolar]?
    var bitcoins : Bitcoin?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        dolares <- map["value"] //"dolar"
        bitcoins <- map["ticker"]
    }
}

//{
//    "@odata.context": "https://was-p/olinda/servico/PTAX/versao/v1/odata$metadata#_CotacaoDolarDia",
//    "value": [{
//    "cotacaoCompra": 3.6501,
//    "cotacaoVenda": 3.6507,
//    "dataHoraCotacao": "2018-05-23 13:04:41.926"
//    }]
//}

// MARK: Modelo de Brita
class Dolar: Mappable {
    
    var nome : String?
    var cotacaoCompra: Double?
    var cotacaoVenda: Double?
    var dataHoraCotacao: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cotacaoCompra <- map["cotacaoCompra"]
        cotacaoVenda <- map["cotacaoVenda"]
        dataHoraCotacao <- map["dataHoraCotacao"]
    }
}

//{
//    "ticker": {
//        "high": "27990.00000000",
//        "low": "27260.00000000",
//        "vol": "25.59424333",
//        "last": "27555.19002000",
//        "buy": "27555.19002000",
//        "sell": "27614.12987000",
//        "date": 1527466647
//    }
//}

// MARK: Modelo de BTC
class Bitcoin: Mappable {
    
    var nome : String = ""
    var opening: String?
    var high: String?
    var low: String?
    var vol: String?
    var last: String?
    var buy: String?
    var sell: String?
    var date: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        opening <- map["opening"]
        high <- map["high"]
        low <- map["low"]
        vol <- map["vol"]
        last <- map["last"]
        buy <- map["buy"]
        sell <- map["sell"]
        date <- map["date"]
    }
}
