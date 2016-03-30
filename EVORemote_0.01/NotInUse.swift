//
//  NotInUse.swift
//  EVORemote_0.01
//
//  Created by Reed Miller on 6/17/15.
//  Copyright (c) 2015 com.RMTEK. All rights reserved.
//

import Foundation




//
//  ViewController.swift
//  EVORemote_0.01
//
//  Created by Reed Miller on 5/25/15.
//  Copyright (c) 2015 com.RMTEK. All rights reserved.
//

//import UIKit
//
//class ViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    
//    var temp = ""
//    var IPAdd = "10.0.1.12"
//    var Array = [PlateItemModel]()
//    
//    var ArrayRealPlate = [PlateItemModel]()
//    
//    
//    @IBOutlet var IP: UITextField!
//    @IBOutlet var dataout1: UITextView!
//    @IBOutlet var ProgressBar: UIProgressView!
//    
//    @IBOutlet var wast1: UIProgressView!
//    @IBOutlet var wast2: UIProgressView!
//    
//    
//    @IBOutlet var DI1: UIProgressView!
//    
//    @IBOutlet var DI2: UIProgressView!
//    
//    @IBOutlet var NameOut: UILabel!
//    @IBOutlet var StatusOut: UILabel!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        let diceRoll = Int(arc4random_uniform(7))
//        
//        var newthing = PlateItemModel(Lable: String(diceRoll), Name: String(diceRoll), Status: diceRoll)
//        
//        for index in 1...97{
//            newthing.Lable = String(index)
//            
//            ArrayRealPlate.append(newthing)
//            
//        }
//        
//        
//        
//        
//        wast1.transform = CGAffineTransformMakeRotation(CGFloat(M_PI + M_PI_2))
//        wast2.transform = CGAffineTransformMakeRotation(CGFloat(M_PI + M_PI_2))
//        DI1.transform = CGAffineTransformMakeRotation(CGFloat(M_PI + M_PI_2))
//        DI2.transform = CGAffineTransformMakeRotation(CGFloat(M_PI + M_PI_2))
//        
//        
//        IP.delegate = self
//        
//        
//        var MainTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("DoAllTheThings"), userInfo: nil, repeats: true)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        return 12
//        
//    }
//    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 8
//    }
//    
//    
//    @IBOutlet var theCollection: UICollectionView!
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
//        
//        //var lable = cell.viewWithTag(9898) as! UILabel
//        var ID = cell.viewWithTag(9898) as! UILabel
//        
//        //thing = collectionView
//        
//        //lable.text = Array[indexPath.row + 12 * indexPath.section].Name
//        
//        ID.text = ArrayRealPlate[indexPath.row + 12 * indexPath.section].Lable
//        
//        cell.layer.cornerRadius = cell.frame.size.width/2
//        cell.clipsToBounds = true
//        //  cell.layer.borderWidth = 5.0
//        
//        
//        if ArrayRealPlate[indexPath.row + 12 * indexPath.section].Status == 1
//        {
//            cell.layer.backgroundColor = UIColor.grayColor().CGColor
//        }
//            
//        else if ArrayRealPlate[indexPath.row + 12 * indexPath.section].Status == 2
//        {
//            cell.layer.backgroundColor = UIColor.orangeColor().CGColor
//        }
//            
//        else if ArrayRealPlate[indexPath.row + 12 * indexPath.section].Status == 3
//        {
//            cell.layer.backgroundColor = UIColor.greenColor().CGColor
//        }
//        
//        //collectionView.reloadData()
//        
//        return cell
//        
//    }
//    
//    
//    func fireTestPlate()
//    {
//        //        Array.removeAll(keepCapacity: false)
//        //
//        //        for index in 1...97{
//        //            let diceRoll = Int(arc4random_uniform(7))
//        //
//        //            var newthing = PlateItemModel(Lable: String(diceRoll), Name: String(diceRoll), Status: String(diceRoll))
//        //
//        //            newthing.Lable = String(index)
//        //
//        //            Array.append(newthing)
//        //        }
//        
//        
//        
//        // theCollection.hidden = !theCollection.hidden
//        // thing.reloadData()
//        
//        //self.collectionView?.reloadData()
//        // [collectionView, reloadData]
//        
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    @IBAction func IPChanged(sender: AnyObject) {
//        
//        IPAdd = (sender as! UITextField).text
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        self.view.endEditing(true)
//    }
//    
//    @IBAction func RunListLoop(sender: AnyObject) {
//        
//        var helloWorldTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("RunListStatus"), userInfo: nil, repeats: true)
//        
//        
//    }
//    
//    @IBAction func loopFluid(sender: AnyObject) {
//        
//        var fluid = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: Selector("FluidStatusAPICall"), userInfo: nil, repeats: true)
//        
//    }
//    
//    
//    
//    @IBAction func FluidStatus(sender: AnyObject) {
//        
//        
//        FluidStatusAPICall()
//        
//        // ProcessStatusAPICall("apqdWisIzE+r8z+hRqr4Ew")
//    }
//    
//    
//    @IBAction func RunListStatus(sender: AnyObject) {
//        
//        RunListStatus()
//        
//        
//    }
//    
//    
//    func DoAllTheThings()
//    {
//        StatusAPICall()
//        FluidStatusAPICall()
//        MakePlateFromAPIData()
//    }
//    
//    
//    func  RunListStatus()
//    {
//        
//        MakePlateFromAPIData()
//        
//        // ProcessStatusAPICall("sjlZnQDaPUqEbqEuOcektw")
//        
//    }
//    
//    
//    
//    func MakePlateFromAPIData()
//    {
//        var proccessID = "sjlZnQDaPUqEbqEuOcektw"
//        
//        var urlToMod = "http://" + IPAdd + ":9001/api/processstatus/" + proccessID
//        
//        var myUrl = NSURL(string: urlToMod);
//        
//        //  myUrl +=  "api/processstatus/" + proccessID
//        
//        let request = NSMutableURLRequest(URL:myUrl!);
//        request.HTTPMethod = "GET";
//        
//        // Compose a query string
//        let postString = "";
//        
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil
//            {
//                println("error=\(error)")
//                self.temp = "error=\(error)"
//                self.setVal()
//                return
//            }
//            
//            // You can print out response object
//            // println("response = \(response)")
//            
//            
//            // Print out response body
//            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//            // println("responseString = \(responseString)")
//            
//            //Let's convert response sent from a server side script to a NSDictionary object:
//            
//            var err: NSError?
//            var myJSON = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error:&err) as? NSDictionary
//            
//            
//            let json = JSON(myJSON!)
//            
//            self.temp = json.description as String;
//            
//            self.setVal()
//            
//            //  println(json.description)
//            
//            if var details = json["Status"]["Details"].string{
//                
//                // println("thedets: \(details)")
//                
//                var ttttttt: NSData = details.dataUsingEncoding(NSUTF8StringEncoding)!
//                var error: NSError?
//                
//                var ddddddd = NSJSONSerialization.JSONObjectWithData(ttttttt, options: .MutableLeaves, error:&err) as? NSDictionary
//                
//                
//                if ddddddd != nil
//                {
//                    
//                    if let runs = ddddddd!.valueForKey("Runs") as? NSArray {
//                        
//                        
//                        if let sam = runs[0].valueForKey("Steps") as? NSArray
//                        {
//                            self.ArrayRealPlate.removeAll(keepCapacity: false)
//                            
//                            for well in sam
//                            {
//                                let lab = well["WellId"]! as! String
//                                
//                                let name = well["WellId"]! as! String
//                                
//                                let status = well["SampleStatus"] as! Int
//                                
//                                //let diceRoll = Int(arc4random_uniform(7))
//                                
//                                self.ArrayRealPlate.append(PlateItemModel(Lable: lab, Name: lab, Status: status))
//                            }
//                        }
//                        
//                        
//                        if self.ArrayRealPlate.count < 96
//                        {
//                            dispatch_sync(dispatch_get_main_queue()) {
//                                self.theCollection.hidden = true
//                            }
//                        }
//                        else
//                        {
//                            
//                            dispatch_sync(dispatch_get_main_queue()) {
//                                self.theCollection.hidden = false
//                                
//                            }
//                            dispatch_sync(dispatch_get_main_queue()) {
//                                
//                                self.theCollection.reloadData()
//                            }
//                        }
//                        
//                        
//                        
//                        
//                        
//                        
//                    }
//                }
//                // var thingggg = ddddddd[Steps]
//                
//                //                let jsonRunList = JSON(ddddddd!)
//                //
//                //                if let runlist = jsonRunList["Runs"]["Steps"].array{
//                //                    println("thedets: \(runlist)")
//                //                }
//                //
//                //                var Wast_1  = ddddddd!.valueForKey("Wast_1") as! Float
//                //                var Wast_2 =  ddddddd!.valueForKey("Wast_2") as! Float
//                //                var DI_1 = ddddddd!.valueForKey("DI_1") as! Float
//                //                var DI_2 = ddddddd!.valueForKey("DI_2") as! Float
//                //
//                //                var Additive = ddddddd!.valueForKey("Additive") as! Float
//                //                var Cleaner = ddddddd!.valueForKey("Cleaner") as! Float
//                //                var Time = String(stringInterpolationSegment:ddddddd!.valueForKey("time"))
//                //
//                //
//                //                // println("JSON: \(Wast_1,Wast_2,DI_1,DI_2,Additive,Cleaner,Time)")
//                //                // println("JSON: \(Wast_1,Wast_2)")
//                //
//                //                // let bob = Wast_2!
//                //                // var floatValue : Float = NSString(string: Wast_2!).floatValue
//                //
//                //
//                //
//                //                dispatch_async(dispatch_get_main_queue()) {
//                //
//                //                    self.wast1.setProgress( Wast_1, animated: true)
//                //
//                //                    self.wast2.setProgress( Wast_2, animated: true)
//                //
//                //                    self.DI1.setProgress( DI_1, animated: true)
//                //
//                //                    self.DI2.setProgress( DI_2, animated: true)
//                //                }
//                
//                
//                
//                
//                
//                //              if let thing = Wast_2 as? NSString
//                //              {
//                //
//                //                var thinggggg : Float =  thing.floatValue
//                //
//                //                                            }
//                
//                
//            }
//            
//            //            if let parseJSON = myJSON {
//            //                // Now we can access value of First Name by its key
//            //                var firstNameValue = parseJSON["Status"] as? String
//            //                //println("XXXXXXXXX: \(firstNameValue)")
//            //
//            //                self.temp = responseString! as String;
//            //
//            //                self.setVal()
//            //            }
//        }
//        
//        task.resume()
//    }
//    
//    
//    
//    
//    
//    @IBAction func StartUp(sender: AnyObject) {
//        
//        var urlToMod = "http://" + IPAdd + ":9001/api/processstart/"
//        
//        var myUrl = NSURL(string: urlToMod);
//        
//        //  myUrl +=  "api/processstatus/" + proccessID
//        
//        let request = NSMutableURLRequest(URL:myUrl!);
//        request.HTTPMethod = "POST";
//        
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        
//        
//        var thingTosay = ProcessArg(ProcessId: "G9YmHcihFUukolpuxi0lFw", Options: "")
//        
//        
//        
//        // Compose a query string
//        let postString = thingTosay.toJsonString()
//        
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil
//            {
//                println("error=\(error)")
//                self.temp = "error=\(error)"
//                self.setVal()
//                return
//            }
//            
//            // You can print out response object
//            println("response = \(response)")
//            
//            self.temp = "response=\(response)"
//            self.setVal()
//            
//            
//            // Print out response body
//            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("responseString = \(responseString)")
//            
//            //Let's convert response sent from a server side script to a NSDictionary object:
//            
//            var err: NSError?
//            var myJSON = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error:&err) as? NSDictionary
//            
//            if let parseJSON = myJSON {
//                // Now we can access value of First Name by its key
//                var firstNameValue = parseJSON["name"] as? String
//                println("XXXXXXXXX: \(firstNameValue)")
//                
//                self.temp = responseString! as String;
//                
//                self.setVal()
//            }
//            
//            
//            
//        }
//        
//        task.resume()
//        
//        
//        
//    }
//    
//    @IBAction func ShutDown(sender: AnyObject) {
//        
//        
//        
//        
//        var urlToMod = "http://" + IPAdd + ":9001/api/processstart/"
//        
//        var myUrl = NSURL(string: urlToMod);
//        
//        //  myUrl +=  "api/processstatus/" + proccessID
//        
//        let request = NSMutableURLRequest(URL:myUrl!);
//        request.HTTPMethod = "POST";
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        
//        
//        
//        var thingTosay = ProcessArg(ProcessId: "k/KSYJQyqES3V61WiTz/zA", Options: "")
//        
//        
//        
//        // Compose a query string
//        let postString = thingTosay.toJsonString()
//        
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil
//            {
//                println("error=\(error)")
//                self.temp = "error=\(error)"
//                self.setVal()
//                return
//            }
//            
//            // You can print out response object
//            println("response = \(response)")
//            
//            self.temp = "response=\(response)"
//            self.setVal()
//            
//            
//            // Print out response body
//            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("responseString = \(responseString)")
//            
//            //Let's convert response sent from a server side script to a NSDictionary object:
//            
//            var err: NSError?
//            var myJSON = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error:&err) as? NSDictionary
//            
//            if let parseJSON = myJSON {
//                // Now we can access value of First Name by its key
//                var firstNameValue = parseJSON["name"] as? String
//                println("XXXXXXXXX: \(firstNameValue)")
//                
//                self.temp = responseString! as String;
//                
//                self.setVal()
//            }
//            
//            
//            
//        }
//        
//        task.resume()
//        
//        
//        
//        
//    }
//    
//    
//    
//    
//    
//    @IBAction func SystemStatus(sender: AnyObject) {
//        
//        ProcessStatusAPICall("swXmCQkfMUy8GXc7Uvo1qw")
//        
//        
//        
//    }
//    @IBAction func View(sender: AnyObject) {
//        
//    }
//    
//    func setVal()
//    {
//        
//        dispatch_async(dispatch_get_main_queue(), {
//            self.dataout1.text = self.temp
//        })
//        
//    }
//    
//    
//    
//    func StatusAPICall()
//    {
//        var proccessID = "swXmCQkfMUy8GXc7Uvo1qw"
//        
//        var urlToMod = "http://" + IPAdd + ":9001/api/processstatus/" + proccessID
//        
//        var myUrl = NSURL(string: urlToMod);
//        
//        //  myUrl +=  "api/processstatus/" + proccessID
//        
//        let request = NSMutableURLRequest(URL:myUrl!);
//        request.HTTPMethod = "GET";
//        
//        // Compose a query string
//        let postString = "";
//        
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil
//            {
//                println("error=\(error)")
//                self.temp = "error=\(error)"
//                self.setVal()
//                return
//            }
//            
//            // You can print out response object
//            println("response = \(response)")
//            
//            
//            // Print out response body
//            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("responseString = \(responseString)")
//            
//            //Let's convert response sent from a server side script to a NSDictionary object:
//            
//            var err: NSError?
//            var myJSON = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error:&err) as? NSDictionary
//            
//            
//            let json = JSON(myJSON!)
//            
//            //  println(json.description)
//            
//            if var status = json["Status"]["StatusType"].string{
//                println("STATSSSS: \(status)")
//                
//            }
//            
//            if var details = json["Status"]["Details"].string{
//                
//                println("thedets: \(details)")
//                
//                var ttttttt: NSData = details.dataUsingEncoding(NSUTF8StringEncoding)!
//                var error: NSError?
//                
//                var ddddddd = NSJSONSerialization.JSONObjectWithData(ttttttt, options: nil, error:&err) as? NSDictionary
//                
//                var Name  = ddddddd!.valueForKey("InstrumentName") as! String
//                var Status =  ddddddd!.valueForKey("SystemStatus") as! Int
//                
//                
//                // println("JSON: \(Wast_1,Wast_2,DI_1,DI_2,Additive,Cleaner,Time)")
//                // println("JSON: \(Wast_1,Wast_2)")
//                
//                // let bob = Wast_2!
//                // var floatValue : Float = NSString(string: Wast_2!).floatValue
//                
//                var displayStatusText = ""
//                
//                if Status == 1
//                {
//                    displayStatusText = "Unknown"
//                }
//                else if Status == 2
//                {
//                    displayStatusText = "Disconnected"
//                }
//                else if Status == 3
//                {
//                    displayStatusText = "Off"
//                }
//                else if Status == 4
//                {
//                    displayStatusText = "Starting..."
//                }
//                else if Status == 5
//                {
//                    displayStatusText = "Calibration Required"
//                }
//                else if Status == 6
//                {
//                    displayStatusText = "Ready"
//                }
//                else if Status == 7
//                {
//                    displayStatusText = "Acquiring"
//                }
//                else if Status == 8
//                {
//                    displayStatusText = "Shutting Down..."
//                }
//                else if Status == 9
//                {
//                    displayStatusText = "Error"
//                }
//                
//                
//                dispatch_async(dispatch_get_main_queue()) {
//                    
//                    self.StatusOut.text = displayStatusText
//                    self.NameOut.text = Name
//                    
//                }
//                
//                
//                
//                
//                
//                //              if let thing = Wast_2 as? NSString
//                //              {
//                //
//                //                var thinggggg : Float =  thing.floatValue
//                //
//                //                                            }
//                
//                
//            }
//            
//            if let parseJSON = myJSON {
//                // Now we can access value of First Name by its key
//                var firstNameValue = parseJSON["Status"] as? String
//                println("XXXXXXXXX: \(firstNameValue)")
//                
//                self.temp = responseString! as String;
//                
//                self.setVal()
//            }
//        }
//        
//        task.resume()
//    }
//    
//    
//    
//    
//    
//    
//    func FluidStatusAPICall()
//    {
//        var proccessID = "apqdWisIzE+r8z+hRqr4Ew"
//        
//        var urlToMod = "http://" + IPAdd + ":9001/api/processstatus/" + proccessID
//        
//        var myUrl = NSURL(string: urlToMod);
//        
//        //  myUrl +=  "api/processstatus/" + proccessID
//        
//        let request = NSMutableURLRequest(URL:myUrl!);
//        request.HTTPMethod = "GET";
//        
//        // Compose a query string
//        let postString = "";
//        
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil
//            {
//                println("error=\(error)")
//                self.temp = "error=\(error)"
//                self.setVal()
//                return
//            }
//            
//            // You can print out response object
//            println("response = \(response)")
//            
//            
//            // Print out response body
//            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("responseString = \(responseString)")
//            
//            //Let's convert response sent from a server side script to a NSDictionary object:
//            
//            var err: NSError?
//            var myJSON = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error:&err) as? NSDictionary
//            
//            
//            let json = JSON(myJSON!)
//            
//            //  println(json.description)
//            
//            if var details = json["Status"]["Details"].string{
//                
//                println("thedets: \(details)")
//                
//                var ttttttt: NSData = details.dataUsingEncoding(NSUTF8StringEncoding)!
//                var error: NSError?
//                
//                var ddddddd = NSJSONSerialization.JSONObjectWithData(ttttttt, options: nil, error:&err) as? NSDictionary
//                
//                var Wast_1  = ddddddd!.valueForKey("Wast_1") as! Float
//                var Wast_2 =  ddddddd!.valueForKey("Wast_2") as! Float
//                var DI_1 = ddddddd!.valueForKey("DI_1") as! Float
//                var DI_2 = ddddddd!.valueForKey("DI_2") as! Float
//                
//                var Additive = ddddddd!.valueForKey("Additive") as! Float
//                var Cleaner = ddddddd!.valueForKey("Cleaner") as! Float
//                var Time = String(stringInterpolationSegment:ddddddd!.valueForKey("time"))
//                
//                
//                // println("JSON: \(Wast_1,Wast_2,DI_1,DI_2,Additive,Cleaner,Time)")
//                // println("JSON: \(Wast_1,Wast_2)")
//                
//                // let bob = Wast_2!
//                // var floatValue : Float = NSString(string: Wast_2!).floatValue
//                
//                
//                
//                dispatch_async(dispatch_get_main_queue()) {
//                    
//                    self.wast1.setProgress( Wast_1, animated: true)
//                    
//                    self.wast2.setProgress( Wast_2, animated: true)
//                    
//                    self.DI1.setProgress( DI_1, animated: true)
//                    
//                    self.DI2.setProgress( DI_2, animated: true)
//                }
//                
//                
//                
//                
//                
//                //              if let thing = Wast_2 as? NSString
//                //              {
//                //
//                //                var thinggggg : Float =  thing.floatValue
//                //
//                //                                            }
//                
//                
//            }
//            
//            if let parseJSON = myJSON {
//                // Now we can access value of First Name by its key
//                var firstNameValue = parseJSON["Status"] as? String
//                println("XXXXXXXXX: \(firstNameValue)")
//                
//                self.temp = responseString! as String;
//                
//                self.setVal()
//            }
//        }
//        
//        task.resume()
//    }
//    
//    
//    
//    
//    
//    
//    func ProcessStatusAPICall( proccessID:String )
//    {
//        
//        
//        var urlToMod = "http://" + IPAdd + ":9001/api/processstatus/" + proccessID
//        
//        var myUrl = NSURL(string: urlToMod);
//        
//        //  myUrl +=  "api/processstatus/" + proccessID
//        
//        let request = NSMutableURLRequest(URL:myUrl!);
//        request.HTTPMethod = "GET";
//        
//        // Compose a query string
//        let postString = "";
//        
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil
//            {
//                println("error=\(error)")
//                self.temp = "error=\(error)"
//                self.setVal()
//                return
//            }
//            
//            // You can print out response object
//            //            println("response = \(response)")
//            //
//            //            self.temp = "response=\(response)"
//            //            self.setVal()
//            
//            
//            //let json = JSON(myJSON!)
//            
//            // Print out response body
//            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("responseString = \(responseString)")
//            
//            //Let's convert response sent from a server side script to a NSDictionary object:
//            
//            var err: NSError?
//            var myJSON = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error:&err) as? NSDictionary
//            
//            
//            let json = JSON(myJSON!)
//            
//            
//            
//            
//            self.temp = "response=\(json.description)"
//            self.setVal()
//            //
//            //          //  println(json.description)
//            //
//            //            if var details = json["Status"]["Details"].string{
//            //
//            //                println("thedets: \(details)")
//            //
//            //                var ttttttt: NSData = details.dataUsingEncoding(NSUTF8StringEncoding)!
//            //                var error: NSError?
//            //
//            //                var ddddddd = NSJSONSerialization.JSONObjectWithData(ttttttt, options: nil, error:&err) as? NSDictionary
//            //
//            //                var Wast_1  = ddddddd!.valueForKey("Wast_1") as! Float
//            //                 var Wast_2 =  ddddddd!.valueForKey("Wast_2") as! Float
//            //                 var DI_1 = ddddddd!.valueForKey("DI_1") as! Float
//            //                 var DI_2 = ddddddd!.valueForKey("DI_2") as! Float
//            //
//            //                var Additive = ddddddd!.valueForKey("Additive") as! Float
//            //                var Cleaner = ddddddd!.valueForKey("Cleaner") as! Float
//            //                var Time = String(stringInterpolationSegment:ddddddd!.valueForKey("time"))
//            //
//            //
//            //            // println("JSON: \(Wast_1,Wast_2,DI_1,DI_2,Additive,Cleaner,Time)")
//            //                // println("JSON: \(Wast_1,Wast_2)")
//            //
//            //               // let bob = Wast_2!
//            //               // var floatValue : Float = NSString(string: Wast_2!).floatValue
//            //
//            //
//            //
//            //                dispatch_async(dispatch_get_main_queue()) {
//            //
//            //                    self.wast1.setProgress( Wast_1, animated: true)
//            //
//            //                    self.wast2.setProgress( Wast_2, animated: true)
//            //
//            //                    self.DI1.setProgress( DI_1, animated: true)
//            //
//            //                    self.DI2.setProgress( DI_2, animated: true)
//            //                }
//            
//            
//            
//            
//            
//            //              if let thing = Wast_2 as? NSString
//            //              {
//            //
//            //                var thinggggg : Float =  thing.floatValue
//            //
//            //                                            }
//            
//            
//            //   }
//            //
//            //            if let parseJSON = myJSON {
//            //                // Now we can access value of First Name by its key
//            //                var firstNameValue = parseJSON["Status"] as? String
//            //                println("XXXXXXXXX: \(firstNameValue)")
//            //
//            //                self.temp = responseString! as String;
//            //
//            //                self.setVal()
//            //            }
//        }
//        
//        task.resume()
//    }
//    
//    
//    func ProcessStartAPICall( proccessID: String)
//    {
//        
//        
//        var urlToMod = IPAdd + "api/processstart/" + proccessID
//        
//        var myUrl = NSURL(string: urlToMod);
//        
//        //  myUrl +=  "api/processstatus/" + proccessID
//        
//        let request = NSMutableURLRequest(URL:myUrl!);
//        request.HTTPMethod = "GET";
//        
//        // Compose a query string
//        let postString = "";
//        
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil
//            {
//                println("error=\(error)")
//                self.temp = "error=\(error)"
//                self.setVal()
//                return
//            }
//            
//            // You can print out response object
//            println("response = \(response)")
//            
//            // Print out response body
//            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("responseString = \(responseString)")
//            
//            println("Res=\(responseString)")
//            self.temp = "Res=\(responseString)"
//            self.setVal()
//            
//            //Let's convert response sent from a server side script to a NSDictionary object:
//            
//            var err: NSError?
//            var myJSON = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error:&err) as? NSDictionary
//            
//            
//            
//            if let parseJSON = myJSON {
//                // Now we can access value of First Name by its key
//                var firstNameValue = parseJSON["Name"] as? String
//                println("XXXXXXXXX: \(firstNameValue)")
//                
//                self.temp = responseString! as String;
//                
//                self.setVal()
//            }
//            
//            
//            
//        }
//        
//        task.resume()
//        
//        
//        
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    
//}




//@IBAction func RunListLoop(sender: AnyObject) {
//    
//    var helloWorldTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("RunListStatus"), userInfo: nil, repeats: true)
//    
//    
//}
//
//@IBAction func loopFluid(sender: AnyObject) {
//    
//    var fluid = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: Selector("FluidStatusAPICall"), userInfo: nil, repeats: true)
//    
//}
//
//@IBAction func FluidStatus(sender: AnyObject) {
//    FluidStatusAPICall()
//}
//
//@IBAction func RunListStatus(sender: AnyObject) {
//    RunListStatus()
//}



//
//                        let calendar = NSCalendar.currentCalendar()
//                        let comp = calendar.components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: generatedDate)
//                        let hour = comp.hour
//                        let minute = comp.minute
//
//                         println(hour )
//                         println(minute)
//                        let formatter = NSDateFormatter()
//                       // formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//                        formatter.timeStyle = .MediumStyle
//                        formatter.dateFormat = "HH:mm:ss.SS"
//
//                        if let parsedDateTimeString = formatter.dateFromString(timeLeft as! String) {
//                            formatter.stringFromDate(parsedDateTimeString)
//                            println("TimeStuff=\(parsedDateTimeString)")
//                        } else {
//                            println("Could not parse date")
//                        }














