//
//  TerraService.swift
//  zala
//
//  Created by Kyle Carriedo on 5/22/24.
//

import Foundation
import SwiftUI
import Alamofire
import Combine

struct TerraResponse: Codable {
    var expires_in: Int? //900,
    var session_id: String? // "98e6b2b1-973c-4dd8-8c91-408448d3d59a",
    var status: String? //"success",
    var url: String? //"https://widget.tryterra.co/session/98e6b2b1-973c-4dd8-8c91-408448d3d59a"
}

protocol TerraAPIProtocol {
    func createWidget() -> AnyPublisher<TerraResponse, AFError>
}


struct TerraAPI: TerraAPIProtocol {
    
    func createWidget() -> AnyPublisher<TerraResponse, AFError> {
        let token = Network.shared.token()
        let userId = Network.shared.userId() ?? ""
        let url = Enviorment.terraURL
        return AF.request(url, method: .post, parameters:
                            ["referenceID": userId,
                             "authSuccessRedirectURL": "zala://success?user=\(userId)",
                             "authFailureRedirectURL": "zala://failed?user=\(userId)",
                             "language": "en",
                             "showDisconnect": true]
                          , encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(token)"])
            .validate()
            .publishDecodable(type:TerraResponse.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

@Observable class TerraService: ObservableObject {
    
    
    private var subscriptions: Set<AnyCancellable> = []
    private let networking: TerraAPIProtocol = TerraAPI()
    
    func createWidget(handler: @escaping (_ widget: String?) -> Void) {
        networking.createWidget().sink { completion in
            switch completion {
            case .failure(_):
                handler(nil)
                
            case .finished:()
            }
            
        } receiveValue: { res in
            handler(res.url ?? "")
        }
        .store(in: &subscriptions)
    }
}
    
