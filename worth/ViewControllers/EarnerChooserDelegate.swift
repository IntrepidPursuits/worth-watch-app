//
//  EarnerChooserDelegate.swift
//  worth
//
//  Created by Matt Bridges on 3/15/15.
//  Copyright (c) 2015 Matt Bridges. All rights reserved.
//

import Foundation

protocol EarnerChooserDelegate {
    func earnerChosen(viewController: EarnerChooserViewController, earner: Earner)
}