//
//  ContentService.swift
//  zala
//
//  Created by Kyle Carriedo on 4/25/24.
//

import Foundation
import Combine
import Alamofire


enum Engagement {
    case like
    case dislike
    case viewed
    
    func url(id: String) -> String {
        switch self {
        case .like: return "post/like/\(id)"
            
        case .dislike: return "post/dislike/\(id)"
            
        case .viewed: return "post/view/\(id)"
            
        }
    }
}

struct ZalaContentResponse: Codable {
    var message: String?
}

protocol ContentServiceAPIProtocol {
    func fetchContent(superUserID: String)  -> AnyPublisher<[ZalaContent], AFError>
    func updateContent(engagement: Engagement, id: String)  -> AnyPublisher<ZalaContentResponse, AFError>
    func browseAll()  -> AnyPublisher<[ZalaContent], AFError>
    func forYou(subscribers:[String]) -> AnyPublisher<[ZalaContent], AFError>
}

struct ContentServiceAPI: ContentServiceAPIProtocol {
    func updateContent(engagement: Engagement, id: String) -> AnyPublisher<ZalaContentResponse, Alamofire.AFError> {
        let url = "\(Enviorment.zalaContent)\(engagement.url(id: id))"
        return AF.request(url, method: .post, headers: HTTPHeaders(HTTPHeaders.token))
            .validate()
            .publishDecodable(type:ZalaContentResponse.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchContent(superUserID: String) -> AnyPublisher<[ZalaContent], Alamofire.AFError> {
        let url = "\(Enviorment.zalaContent)content/\(superUserID)"
//        , headers: HTTPHeaders(HTTPHeaders.token)
        return AF.request(url, method: .get, encoding: JSONEncoding.default, headers: HTTPHeaders(HTTPHeaders.token))
            .validate()
            .publishDecodable(type:[ZalaContent].self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    } 
    
    func browseAll() -> AnyPublisher<[ZalaContent], Alamofire.AFError> {
        let url = "\(Enviorment.zalaContent)posts/browseAll"
        return AF.request(url, method: .get, encoding: JSONEncoding.default, headers: HTTPHeaders(HTTPHeaders.token))
            .validate()
            .publishDecodable(type:[ZalaContent].self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func forYou(subscribers:[String]) -> AnyPublisher<[ZalaContent], Alamofire.AFError> {
        let url = "\(Enviorment.zalaContent)posts/forYou"
        return AF.request(url, method: .post,
                          parameters: ["creatorIds": subscribers],
                          encoding: JSONEncoding.default,
                          headers: HTTPHeaders(HTTPHeaders.token))
            .validate()
            .publishDecodable(type:[ZalaContent].self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

@Observable class ContentService {
    private var subs: Set<AnyCancellable> = []
    private let networking: ContentServiceAPIProtocol = ContentServiceAPI()
    var content: [ZalaContent] = []
    var updatedContent: ZalaContent? = nil
    
    func updatePost(engagement: Engagement, id: String) {
        networking.updateContent(engagement: engagement, id: id).sink { completion in
//            guard let self = self else { return }
            switch completion {
            case .failure(_): break
                
                
            case .finished:()
            }
            
        } receiveValue: { _ in
        }
        .store(in: &subs)
    }
    
    func getContentFor(superUserId:String) {
        networking.fetchContent(superUserID: superUserId).sink { completion in
//            guard let self = self else { return }
            switch completion {
            case .failure(_): break
                
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.content = response
        }
        .store(in: &subs)
    }
    
    func forYou(subscribers:[String]) {
        networking.forYou(subscribers: subscribers).sink { completion in
//            guard let self = self else { return }
            switch completion {
            case .failure(_): break
                
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.content = response
        }
        .store(in: &subs)
    }
    
    func browseAll() {
        networking.browseAll().sink { completion in
//            guard let self = self else { return }
            switch completion {
            case .failure(_): break
                
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.content = response
        }
        .store(in: &subs)
    }
}
