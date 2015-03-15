//
//  TimerViewController.swift
//  worth
//
//  Created by Matt Bridges on 3/14/15.
//  Copyright (c) 2015 Matt Bridges. All rights reserved.
//

import UIKit

let numberFormatter = NSNumberFormatter()



class TimerViewController: UIViewController, EarnerChooserDelegate {

    var timer: NSTimer?
    @IBOutlet weak var yearLabel: WorthLabel!
    @IBOutlet weak var watchingLabel: WorthLabel!
    @IBOutlet weak var comparisonYearLabel: WorthLabel!
    @IBOutlet weak var comparisonWatchingLabel: WorthLabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var comparisonSalaryLabel: UILabel!
    @IBOutlet weak var soFarLabel: UILabel!
    @IBOutlet weak var comparisonSoFarLabel: UILabel!
    @IBOutlet weak var comparisonNameLabel: UILabel!
    var user: Earner!
    var comparison: Earner!
    var timeFrame = TimeFrame.Year
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        self.user = Earner(annualSalary: 100000, name: "You");
        self.configureUser()
        self.configureComparisonForEarner(Earner(annualSalary: 24000000, name: "LeBron James"));
        self.yearLabel.start()
        self.watchingLabel.start()
        self.comparisonYearLabel.start()
        self.comparisonWatchingLabel.start()
        self.refreshLabels()
        var tap = UITapGestureRecognizer(target: self, action: "toggleTimeFrame")
        self.view.addGestureRecognizer(tap)
    }
    
    func configureUser() {
        self.salaryLabel.text = NSString(format: "%@ / year",
            numberFormatter.stringFromNumber(self.user.annualSalary)!)
        self.yearLabel.dollarsPerSecond = self.user.dollarsPerSecond()
        self.watchingLabel.dollarsPerSecond = self.user.dollarsPerSecond()
    }
    
    func configureComparisonForEarner(earner: Earner) {
        self.comparisonNameLabel.text = earner.name
        self.comparison = earner
        self.comparisonSalaryLabel.text = NSString(format: "%@ / year",
        numberFormatter.stringFromNumber(earner.annualSalary)!)
        self.comparisonYearLabel.dollarsPerSecond = earner.dollarsPerSecond()
        self.comparisonWatchingLabel.dollarsPerSecond = earner.dollarsPerSecond()
    }
    
    func refreshLabels() {
        var unit: NSString
        
        switch timeFrame {
        case .Year:
            unit = "this year"
        case .Month:
            unit = "this month"
        case .Week:
            unit = "this week"
        case .Day:
            unit = "today"
        }
        
        self.soFarLabel.text = NSString(format: "Earned so far %@", unit)
        self.yearLabel.startingValue = self.user.dollarsEarnedForTimeFrame(self.timeFrame);
        self.comparisonSoFarLabel.text = NSString(format: "Earned so far %@", unit)
        self.comparisonYearLabel.startingValue = self.comparison.dollarsEarnedForTimeFrame(self.timeFrame)
    }
    
    func toggleTimeFrame() {
        UIView.animateWithDuration(0.2, animations: {
                self.soFarLabel.alpha = 0
                self.comparisonSoFarLabel.alpha = 0
                self.yearLabel.alpha = 0
                self.comparisonYearLabel.alpha = 0
            }, completion: { _ in
                var current = self.timeFrame.rawValue;
                var newValue = (current + 1) % TimeFrame.allValues.count
                self.timeFrame = TimeFrame(rawValue: newValue)!;
                self.refreshLabels()
                UIView.animateWithDuration(0.2, animations: {
                    self.soFarLabel.alpha = 1
                    self.comparisonSoFarLabel.alpha = 1
                    self.yearLabel.alpha = 1
                    self.comparisonYearLabel.alpha = 1
                })
            })
    }
    
    func earnerChosen(viewController: EarnerChooserViewController, earner: Earner) {
        self.configureComparisonForEarner(earner)
        self.refreshLabels()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "earnerChooserSegue") {
            var earnerChooser = segue.destinationViewController as EarnerChooserViewController
            earnerChooser.delegate = self
        }
    }

}
