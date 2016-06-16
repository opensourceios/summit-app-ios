//
//  EventRemoteDataStore.swift
//  OpenStackSummit
//
//  Created by Claudio on 10/20/15.
//  Copyright © 2015 OpenStack. All rights reserved.
//

import UIKit
import Crashlytics

@objc
public protocol IEventRemoteDataStore {
    func getAverageRating(eventId: Int, completionBlock : (SummitEvent?, NSError?) -> Void)
    func getFeedbackForEvent(eventId: Int, page: Int, objectsPerPage: Int, completionBlock : ([Feedback]?, NSError?) -> Void)
}

public class EventRemoteDataStore: NSObject {
    var deserializerFactory: DeserializerFactory!
    var httpFactory: HttpFactory!
    
    func getAverageRating(eventId: Int, completionBlock : (SummitEvent?, NSError?) -> Void) {
        let http = httpFactory.create(HttpType.ServiceAccount)
        
        http.GET("\(Constants.Urls.ResourceServerBaseUrl)/api/v1/summits/current/events/\(eventId)/published?fields=id,avg_feedback_rate&relations=none") { (responseObject, error) in
            
            if (error != nil) {
                completionBlock(nil, error)
                return
            }
            
            let json = responseObject as! String
            let deserializer : IDeserializer!
            var friendlyError: NSError?
            var event: SummitEvent?
            
            deserializer = self.deserializerFactory.create(DeserializerFactoryType.SummitEvent)
            
            do {
                event = try deserializer.deserialize(json) as? SummitEvent
            }
            catch {
                let nsError = error as NSError
                printerr(nsError)
                Crashlytics.sharedInstance().recordError(nsError)
                let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey :  NSLocalizedString("There was an error getting average feedback rating for event with id \(eventId)", value: nsError.localizedDescription, comment: "")]
                friendlyError = NSError(domain: Constants.ErrorDomain, code: 5001, userInfo: userInfo)
            }
            
            completionBlock(event, friendlyError)
        }
    }
    
    public func getFeedbackForEvent(eventId: Int, page: Int, objectsPerPage: Int, completionBlock : ([Feedback]?, NSError?) -> Void) {
        let http = httpFactory.create(HttpType.ServiceAccount)
        
        http.GET("\(Constants.Urls.ResourceServerBaseUrl)/api/v1/summits/current/events/\(eventId)/feedback?expand=owner&page=\(page)&per_page=\(objectsPerPage)") {(responseObject, error) in
            if (error != nil) {
                completionBlock(nil, error)
                return
            }
            
            let json = responseObject as! String
            let deserializer : IDeserializer!
            var friendlyError: NSError?
            var feedbackList: [Feedback]?
            
            deserializer = self.deserializerFactory.create(DeserializerFactoryType.Feedback)
            
            do {
                feedbackList = try deserializer.deserializePage(json) as? [Feedback]
            }
            catch {
                let nsError = error as NSError
                printerr(nsError)
                Crashlytics.sharedInstance().recordError(nsError)
                let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey :  NSLocalizedString("There was an error getting feedback for event with id \(eventId)", value: nsError.localizedDescription, comment: "")]
                friendlyError = NSError(domain: Constants.ErrorDomain, code: 5001, userInfo: userInfo)
            }
            
            completionBlock(feedbackList, friendlyError)
        }
        
    }
}