//
//  WorthLabel.swift
//  worth
//
//  Created by Matt Bridges on 3/14/15.
//  Copyright (c) 2015 Matt Bridges. All rights reserved.
//

import UIKit

let fps = 25.0

class WorthLabel: UILabel {
    
    var startingValue: Double = 0
    var dollarsPerSecond: Double = 0
    
    private var timer: NSTimer?
    private let numberFormatter = NSNumberFormatter()
    
    required init(coder aDecoder: NSCoder) {
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        super.init(coder: aDecoder)
    }
    
    func start() {
        let startTime = CACurrentMediaTime()
        let loop = NSBlockOperation({
            [unowned self] in
            let currentTime = CACurrentMediaTime()
            let elapsedTime = currentTime - startTime
            self.text = self.numberFormatter
                .stringFromNumber(self.startingValue + (self.dollarsPerSecond * elapsedTime))
        })
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0/fps,
            target: loop,
            selector: "main",
            userInfo: nil,
            repeats: true)
    }
}
