//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Nicolas Dubus on 2015-10-04.
//  Copyright © 2015 WorldDubination. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBAction func whatsTheWeather(sender: AnyObject) {
        var url = NSURL(string: "http://www.weather-forecast.com/locations/" + textField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-")
 + "/forecasts/latest")
        
        if (url != nil) {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                
                var urlError = false
                var weather = ""
                
                if (error == nil) {
                    var urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding) as NSString!
                    
                    var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\"")
                    
                    if urlContentArray.count > 0 {
                        var weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                        if weatherArray.count > 0 {
                            weather = weatherArray[0] as String!
                            weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        }
                    } else {
                        urlError = true
                    }
                    
                } else {
                    urlError = true
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if urlError == true {
                        self.showError()
                        
                    } else {
                        self.weatherLabel.text = weather
                    }
                })
                
            })
            task.resume()
            
        } else {
            showError()
        }

        
    }
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    func showError() {
        weatherLabel.text = "Could not find weather results for " + textField.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

