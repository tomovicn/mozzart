//
//  APIManager.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/24/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class APIManager
{
    static let shared = APIManager()
    
    private init() { }
    
    private let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 40
        configuration.timeoutIntervalForResource = 40
        
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()

    func getScores(fromTime: TimeInterval, untilTime: TimeInterval, succes: @escaping (_ scores : [Match]) -> Void, failure : @escaping ((String) -> Void) ) {
        
        manager.request(LivescoresRouter.scores(fromTime: fromTime, untilTime: untilTime)).validate().responseArray(keyPath: "livescores") { (response: DataResponse<[Match]>) in

            switch response.result {
            case .success(let matchs):
                succes(matchs)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
        
    }
    
    func getLivescores(succes: @escaping (_ scores : [Match]) -> Void, failure : @escaping ((String) -> Void) ) {
        
        manager.request(LivescoresRouter.liveScores).validate().responseArray(keyPath: "livescores") { (response: DataResponse<[Match]>) in
            
            switch response.result {
            case .success(let matchs):
                succes(matchs)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
        
    }
    
    func getMatchCast(matchId: String, succes: @escaping (_ matchcast : MatchCast) -> Void, failure : @escaping ((String) -> Void) ) {
        
        manager.request(LivescoresRouter.matchcast(matchId: matchId)).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let JSON = response.result.value as? NSDictionary {
                    
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        
        }
    }
    
}