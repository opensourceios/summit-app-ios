//
//  MenuAssembly.swift
//  OpenStackSummit
//
//  Created by Claudio on 8/24/15.
//  Copyright © 2015 OpenStack. All rights reserved.
//

import UIKit
import Typhoon

public class MenuAssembly: TyphoonAssembly {
    dynamic func menuWireframe() -> AnyObject {
        return TyphoonDefinition.withClass(MenuWireframe.self) {
            (definition) in
            
            definition.injectProperty("menuViewController", with: self.menuViewController())
        }
    }
    
    dynamic func menuPresenter() -> AnyObject {
        return TyphoonDefinition.withClass(MenuPresenter.self) {
            (definition) in
            
            definition.injectProperty("interactor", with: self.menuInteractor())
            definition.injectProperty("menuWireframe", with: self.menuWireframe())
            
        }
    }
    
    dynamic func menuInteractor() -> AnyObject {
        return TyphoonDefinition.withClass(MenuInteractor.self) {
            (definition) in
            
            definition.injectProperty("session", with: self.session())
        }
    }
    
    dynamic func session() -> AnyObject {
        return TyphoonDefinition.withClass(Session.self)
    }
    
    dynamic func menuViewController() -> AnyObject {
        return TyphoonDefinition.withClass(MenuViewController.self) {
            (definition) in
            
            definition.injectProperty("presenter", with: self.menuPresenter())
        }
    }
}