//
//  ViewController.swift
//  WeatherApp
//
//  Created by ME-Tech MacPro User 2 on 1/20/16.
//  Copyright © 2016 iTrain Asia. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate{

    var locationManager: CLLocationManager!
    var weatherInfo   = []
    var cityInfo  : NSDictionary?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if let weather = self.weatherInfo[indexPath.row]["weather"] {
            if let weatherFirst = weather![0]
            {
                cell?.textLabel!.text = weatherFirst["main"] as? String
                cell?.detailTextLabel!.text = weatherFirst["description"] as? String
                if let urlString = weatherFirst["icon"] {
                let imageData = NSURL(string: "http://openweathermap.org/img/w/\(urlString!).png")
                    if let data = NSData(contentsOfURL: imageData!){
                cell?.imageView!.image = UIImage(data: data)
                    }
                }
            }
        }
        cell?.textLabel?.text
        return cell!
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherInfo.count
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            locationManager.stopUpdatingLocation()
            let url = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(currentLocation.coordinate.latitude)&lon=\(currentLocation.coordinate.longitude)&appid=44db6a862fba0b067b1930da0d769e98")
            let data = NSData(contentsOfURL: url!)
            do
            {
                if let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary{
            
                    weatherInfo = json["list"] as! NSMutableArray
                    if let cityInfo = json["city"] as? NSDictionary {
                       self.cityLabel.text = "\(cityInfo["name"]!) \(cityInfo["country"]!)"
                    }
                    
                    tableView.reloadData()
                }
            }
            catch {
                
                    print(error)
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailsegue") {
            let destVC = segue.destinationViewController as! DetailViewController
            let selectedPath = tableView.indexPathForSelectedRow
            destVC.tempDict = weatherInfo[selectedPath!.row] as? NSDictionary
        }
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        let alertCtrl = UIAlertController(title: "Location error", message: "Cannot detect the location", preferredStyle: .Alert)
        let okBtn = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertCtrl.addAction(okBtn)
        self.presentViewController(alertCtrl, animated: true, completion: nil)
    }
}

