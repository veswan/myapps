//
//  ViewController.swift
//  PokeMonApp
//
//  Created by Vishwan Aranha on 7/20/16.
//  Copyright © 2016 Vishwan Aranha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let urlString = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20local.search%20where%20zip%3D%2794085%27%20and%20query%3D%27pizza%27&format=json&callback="
        
        let session = URLSession.shared
        
        let url:URL = URL(string: urlString)!

        let request = NSMutableURLRequest(url: url)


        let task = session.dataTask(with: request, completionHandler:{
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8)
            print(dataString)
            
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                print(dictionary)
                
            } catch {
                print("error")
            }
            
            
            
        }) 
        
        task.resume()


        
    }


}

