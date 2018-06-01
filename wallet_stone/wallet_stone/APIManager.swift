//
//  APIManager.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 24/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class APIManager {
    
    static let shared = APIManager()
    
    public enum Response {
        case Failed(error : String)
        case Success(data : [String: Any])
    }
    
    private init() {
        
    }
    
    //Carrega dados da Cotação diária do Dólar
    func fetchDollarQuotationFromApi(_ data: String) -> Promise<[Dolar]> {
        
        let urlString = "\(API_COTACAO_DOLAR)?%40dataCotacao='\(data)'&%24format=json"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return Promise<[Dolar]> {
            fullfil,reject -> Void in
            return Alamofire.request(urlString).responseString {
                response in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch (response.result) {
                case .success(let responseString):
                    //print(responseString)
                    let dolarResponse = ApiResponse(JSONString:"\(responseString)")!
                    fullfil(dolarResponse.dolares!)
                case .failure(let error):
                    print(error)
                    reject(error)
                }
            }
        }
    }
    
    //Carrega dados da Cotação do Bitcoin para o dia
    func fetchBtcQuotationFromApi() -> Promise<[Bitcoin]> {
        
        let urlString = "\(API_COTACAO_BITCOIN)"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return Promise<[Bitcoin]> {
            fullfil,reject -> Void in
            return Alamofire.request(urlString).responseString {
                response in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch (response.result) {
                case .success(let responseString):
                    //print(responseString)
                    
                    //Conversão necessária devido à formatação do JSON
                    //let json = "{\"data\": [\(responseString)]}"
                    //print(json)
                    //let bitcoinResponse = ApiResponse(JSONString:"\(json)")!
                    
                    let bitcoinResponse = ApiResponse(JSONString:"\(responseString)")!
                    fullfil([bitcoinResponse.bitcoins!])
                case .failure(let error):
                    print(error)
                    reject(error)
                }
            }
        }
    }
    
    //Função para carregar dados da API
    func loadAPIdata(_ resultDate: String, completion: @escaping (Bool)->(), failureBlock: @escaping ()->Void) {
        
        //Carrega a API com a moeda BRITA ao modelo de Moeda do Realm
        let apiCall = self.fetchDollarQuotationFromApi(resultDate)
        apiCall.then {
            dolares -> Void in
            
            //Adiciona cotação de Brita ao Realm
            addMoeda("Brita", cotacaoCompra: dolares[0].cotacaoCompra!, cotacaoVenda: dolares[0].cotacaoVenda!, dataHoraCotacao: dolares[0].dataHoraCotacao!)
            
            //Carrega a API com a moeda BTC
            let apiCall2 = self.fetchBtcQuotationFromApi()
            apiCall2.then {
                bitcoins -> Void in
                
                let cotacaoCompra = Double((bitcoins[0].buy! as NSString).doubleValue)
                let cotacaoVenda = Double((bitcoins[0].sell! as NSString).doubleValue)
                
                //Adiciona cotação de BTC ao modelo de Moeda do Realm
                addMoeda("BTC", cotacaoCompra: cotacaoCompra, cotacaoVenda: cotacaoVenda, dataHoraCotacao: "\(bitcoins[0].date!)")
                
                //Efetua retorno
                completion(true)
                
                }.catch { error
                    -> Void in
            }
            
        }.catch { error
            -> Void in
        }
    }
}
