//
//  PeopleViewController.swift
//  worth
//
//  Created by Matt Bridges on 3/15/15.
//  Copyright (c) 2015 Matt Bridges. All rights reserved.
//

import UIKit

class EarnerChooserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "earnerCell"
    var earners: [Earner] = []
    var delegate: EarnerChooserDelegate?
    private let numberFormatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        self.earners = [
            Earner(annualSalary: 400000, name: "Barack Obama"),
            Earner(annualSalary: 24000000, name: "LeBron James"),
            Earner(annualSalary: 23420244, name: "Beyoncé Knowles"),
            Earner(annualSalary: 21053893, name: "Kanye West"),
            Earner(annualSalary: 3170403420, name: "Bill Gates"),
            Earner(annualSalary: 21932, name: "McDonald's Worker [MA]"),
            Earner(annualSalary: 17219120, name: "Jennifer Anniston"),
            Earner(annualSalary: 1392930, name: "Jessica Alba")
        ]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as PeopleTableViewCell
        var earner = self.earners[indexPath.row];
        cell.salaryLabel.text = numberFormatter.stringFromNumber(earner.annualSalary)
        cell.nameLabel.text = earner.name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.earners.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.earnerChosen(self, earner: self.earners[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
