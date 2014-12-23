//
//  ViewController.swift
//  Photo Search Example Alamofire
//
//  Created by David Currie on 12/18/14.
//  Copyright (c) 2014 Urban Airship. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    let instagramClientID = "44b3919e7dbe4373a2aeb600363e561f"
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        searchInstagramByHashtag("KobyBeef")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchInstagramByHashtag (searchString: String) {
        
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        let instagramURLString: String = "https://api.instagram.com/v1/tags/" + searchString + "/media/recent?client_id=" + instagramClientID
        
        println(instagramURLString)
        
        Alamofire.request(.GET, instagramURLString, parameters: nil)
            .responseString { (_, _, string, _) in
                println(string)
            }
            .responseJSON { (_, _, JSON, _) in
                println(JSON)
            
        
                if let dataArray = JSON?.valueForKey("data") as? [AnyObject] {
                    self.scrollView.contentSize = CGSizeMake(320, CGFloat(320*dataArray.count))
                    
                    for var i = 0; i < dataArray.count; i++ {
                        
                        let dataObject: AnyObject = dataArray[i]
                        
                        if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                            println("image " + String(i) + " URL is " + imageURLString)
                            
                            let imageData =  NSData(contentsOfURL: NSURL(string: imageURLString)!)
                            let imageView = UIImageView(image: UIImage(data: imageData!))
                            
                            imageView.frame = CGRectMake(0, CGFloat(320*i), 320, 320)
                            
                            self.scrollView.addSubview(imageView)
                        }
                    }
                }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        searchBar.resignFirstResponder()
        
        searchInstagramByHashtag(searchBar.text)
    }
}