//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by ME-Tech MacPro User 2 on 1/21/16.
//  Copyright © 2016 iTrain Asia. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var tempDict: NSDictionary?
    
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let mainInfo = tempDict!["main"] {
            let humidity = mainInfo["humidity"] as! Double
            self.pressureLbl.text = "Humdity: \(humidity)"
            let temp = mainInfo["temp"] as! Double
            self.tempLabel.text = "Temperature: \(temp - 273) C"
            let pressure = mainInfo["pressure"] as! Double
            self.humidityLbl.text = "Pressure: \(pressure)"
        }
        
        if let weatherInfo = tempDict!["weather"] {
            if let firstInfo = weatherInfo.firstObject {
            self.weatherLbl.text = firstInfo!["main"] as? String
            self.descLbl.text = firstInfo!["description"] as? String
                if let urlString = firstInfo!["icon"] {
                let imageData = NSURL(string: "http://openweathermap.org/img/w/\(urlString!).png")
                if let data = NSData(contentsOfURL: imageData!){
                self.imageView!.image = UIImage(data: data)
                    
                    }
            }
        }
        // Do any additional setup after loading the view.
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
