//
//  ImageDeserializer.swift
//  OpenStackSummit
//
//  Created by Claudio on 8/27/15.
//  Copyright © 2015 OpenStack. All rights reserved.
//

import UIKit
import SwiftyJSON

public class ImageDeserializer: NSObject, IDeserializer {
    var deserializerStorage: DeserializerStorage!
    
    public func deserialize(json : JSON) -> BaseEntity {
        
        let image = Image()
        
        image.id = json["id"].intValue
        image.url = json["url"].stringValue
        
        return image
    }
}
