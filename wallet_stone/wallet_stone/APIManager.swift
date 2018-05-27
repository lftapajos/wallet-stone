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
import SwiftyJSON

class APIManager {
    
    static let shared = APIManager()
    
    public enum Response {
        case Failed(error : String)
        case Success(data : [String: Any])
    }
    
    private init() {
        
    }
    
    //Carrega dados da Cotação diária do Dólar
    func fetchCotacaoDolarFromApi() -> Promise<[Dolar]> {
        
        let urlString = "\(API_COTACAO_DOLAR)"
        //?id_profissional=\(id_profissional)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return Promise<[Dolar]> {
            fullfil,reject -> Void in
            return Alamofire.request(urlString).responseString {
                response in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch (response.result) {
                case .success(let responseString):
                    print(responseString)
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
    func fetchCotacaoBtcFromApi(_ data: String) -> Promise<[Bitcoin]> {
        
        let urlString = "\(API_COTACAO_BITCOIN)\(data)"
        //?id_profissional=\(id_profissional)
        
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
                    let json = "{\"data\": [\(responseString)]}"
                    //print(json)
                    
                    let bitcoinResponse = ApiResponse(JSONString:"\(json)")!
                    fullfil(bitcoinResponse.bitcoins!)
                case .failure(let error):
                    print(error)
                    reject(error)
                }
            }
        }
    }
}
