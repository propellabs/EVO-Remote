//
//  ViewController.swift
//  EVORemote_0.01
//
//  Created by Reed Miller on 5/25/15.
//  Copyright (c) 2015 com.RMTEK. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var HTTPErrorText = ""
    var IPAdd = ""
    var Array = [PlateItemModel]()
    var isHotorCold = false
    var watchForTempChange = false
    var pingTime: Double = 1.0;
    var index = 0.0;
    var ArrayRealPlate = [PlateItemModel]()
    var rows = 8
    var Colum = 12
    var CurrentName = ""
    var CurrentWell = ""
    var A2Z: [String] = [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" ]
    var lastwellID = ""
    var lastWellStatus = 0
    
    @IBOutlet var QCButton: UIButton!
    @IBOutlet var labelTimeofDay: UILabel!
    @IBOutlet var timeOfDayDoneOut: UILabel!
    @IBOutlet var labelTotal: UILabel!
    @IBOutlet var labelRemaning: UILabel!
    @IBOutlet var FluidLevel: UILabel!
    @IBOutlet var CurrentWellOut: UILabel!
    @IBOutlet var coolImage: UIImageView!
    @IBOutlet var DetailsView: UIView!
    @IBOutlet var SoftwareVout: UILabel!
    @IBOutlet var FirmOut: UILabel!
    @IBOutlet var TimeRemaining: UILabel!
    @IBOutlet var TimeLeft: UILabel!
    @IBOutlet var TemReal: UILabel!
    @IBOutlet var ActivityInd: UIActivityIndicatorView!
    @IBOutlet var HeatUpButton: UIButton!
    @IBOutlet var TimeViewButton: UIButton!
    @IBOutlet var SampleNameOut: UILabel!
    @IBOutlet var CoolDownButton: UIButton!
    @IBOutlet var FireImage: UIImageView!
    @IBOutlet var PlateView: UIView!
    @IBOutlet var ButtBar: UIView!
    @IBOutlet var ConnectionIssueImage: UIImageView!
    @IBOutlet var PowerOnImage: UIImageView!
    @IBOutlet var TempControlView: UIView!
    @IBOutlet var Users: UILabel!
    @IBOutlet var IP: UITextField!
    @IBOutlet var dataout1: UITextView!
    @IBOutlet var ProgressBar: UIProgressView!
    @IBOutlet var wast1: UIProgressView!
    @IBOutlet var PercentDone: UILabel!
    @IBOutlet var DI1: UIProgressView!
    @IBOutlet var NameOut: UILabel!
    @IBOutlet var StatusOut: UILabel!
    @IBOutlet var TempTarget: UILabel!
    @IBOutlet var StartUpButton: UIButton!
    @IBOutlet var ShutDownButton: UIButton!
    @IBOutlet var StatTubeView: UIView!
    
    var isTempOn: Bool = false{
        willSet
        {
        }
        didSet
        {
            if isTempOn == false
            {
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.TempControlView.hidden = true
                }
                
                if watchForTempChange == true
                {
                    if isHotorCold == true
                    {
                        APICallTempToHot ()
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.FireImage.hidden = false
                            self.coolImage.hidden = true
                        }
                    }
                    else
                    {
                        APICallTempToCold ()
                        dispatch_async(dispatch_get_main_queue()) {
                            self.FireImage.hidden = true
                            self.coolImage.hidden = false
                        }
                    }
                }
            }
            if isTempOn == true
            {
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.TempControlView.hidden = false
                }
            }
        }
    }
    
    var connectTimeoutMax = 50
    var connectTimeoutCount = 0
    
    var ConnectionIssue: Bool = false {
        didSet
        {
            if ConnectionIssue == true
            {
                if connectTimeoutCount > 5
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.ConnectionIssueImage.hidden = false
                        self.PowerOnImage.hidden = true
                        self.StatusOut.text = ""
                        self.NameOut.text = ""
                        self.Users.text = ""
                        self.DI1.progress = 0.0
                       // self.wast1.progress = 0.0
                        self.ButtBar.hidden = true
                        self.QCButton.hidden = true
                        self.TempControlView.hidden = true
                        self.PlateView.hidden = true
                        self.connectTimeoutCount = 0
                        
                    }
                }
                else
                {
                    connectTimeoutCount++
                }
            }
            if ConnectionIssue == false
            {
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.ConnectionIssueImage.hidden = true
                    self.PowerOnImage.hidden = false
                    self.dataout1.text = ""
                    self.ButtBar.hidden = false
                    self.QCButton.hidden = false
                    self.PlateView.hidden = false
                }
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "THEIP")
        
        var results = (try! context.executeFetchRequest(request)) as! [THEIP]
        
        if( results.count > 0)
        {
            IPAdd = results[results.count - 1].ip
            IP.text = IPAdd;
        }
        else
        {
            // IPAdd = "10.0.1.15"
        }
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        DetailsView.hidden = true

        let diceRoll = Int(arc4random_uniform(7))
        let newthing = PlateItemModel(Lable: String(diceRoll), Name: String(diceRoll), Status: diceRoll)
        for index in 1...97{
            newthing.Lable = String(index)
            ArrayRealPlate.append(newthing)
        }
        
        ConnectionIssueImage.hidden = true
      //  wast1.transform = CGAffineTransformMakeRotation(CGFloat(M_PI + M_PI_2))
        DI1.transform = CGAffineTransformMakeRotation(CGFloat(M_PI + M_PI_2))
        IP.delegate = self
        TempControlView.hidden = true
        
        var MainTimer = NSTimer.scheduledTimerWithTimeInterval(pingTime, target: self, selector: Selector("RunAllHTTPGetAPICalls"), userInfo: nil, repeats: true)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.theCollection.hidden = true
            self.PercentDone.hidden = true
            self.TimeLeft.hidden = true
            self.TimeRemaining.hidden = false
            self.coolImage.hidden = true
            self.FireImage.hidden = true
            
      //self.StatTubeView.hidden = false;
                self.StatTubeView.hidden = true;
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Colum
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return rows
    }
    
    
    @IBOutlet var theCollection: UICollectionView!
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) 
        let ID = cell.viewWithTag(9898) as! UILabel
        index++
        
        var theArr = ArrayRealPlate
        
        if !theArr.isEmpty
    
        {
            let thingggg = indexPath.row + Colum * indexPath.section
            
            ID.text = theArr[thingggg].Lable
            
            cell.layer.cornerRadius = cell.frame.size.width/2
            cell.clipsToBounds = true

            
             if theArr[indexPath.row + Colum * indexPath.section].Status == 1
            {
                cell.layer.backgroundColor = UIColor.grayColor().CGColor
            }
            else if theArr[indexPath.row + Colum * indexPath.section].Status == 2
            {
                cell.layer.backgroundColor = UIColor.orangeColor().CGColor
                
                self.CurrentName = theArr[indexPath.row + Colum * indexPath.section].Name
                
                
                self.CurrentWell = theArr[indexPath.row + Colum * indexPath.section].Lable
                
                dispatch_async(dispatch_get_main_queue()) {
                    if self.StatTubeView.hidden == true
                    {
                    self.SampleNameOut.text = self.CurrentName
                    self.CurrentWellOut.text = self.CurrentWell
                    }
                }
            }
            else if theArr[indexPath.row + Colum * indexPath.section].Status == 3
            {
                cell.layer.backgroundColor =  UIColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 1).CGColor
            }
            else 
            {
                 cell.layer.backgroundColor = UIColor.grayColor().CGColor
            }
            
            
            
            if theArr[indexPath.row + Colum * indexPath.section].HitTest > 0.15
            {
                cell.layer.backgroundColor = UIColor.greenColor().CGColor
            }
            
            
       
        }
        return cell
    }
    
    @IBAction func DetailViewControl(sender: AnyObject) {
        
        DetailsButt.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                self.DetailsButt.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        
        DetailsView.hidden = !DetailsView.hidden
    }
    
    @IBAction func CloseDetails(sender: AnyObject) {
        
        DetailsView.hidden = true
    }
    
    var clockIndex = 0
    
    @IBAction func ClockSwitchView(sender: AnyObject) {
        
        TimeViewButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                self.TimeViewButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        
        if clockIndex == 0
        {
            dispatch_async(dispatch_get_main_queue()) {
                self.PercentDone.hidden = true
                self.TimeLeft.hidden = false
                self.TimeRemaining.hidden = true
                self.labelTotal.hidden = false
                self.labelRemaning.hidden = true
                self.timeOfDayDoneOut.hidden = true
                self.labelTimeofDay.hidden = true
            }
            clockIndex++
        }
        else if clockIndex == 1
        {
            dispatch_async(dispatch_get_main_queue()) {
                self.PercentDone.hidden = false
                self.TimeLeft.hidden = true
                self.TimeRemaining.hidden = true
                self.labelTotal.hidden = true
                self.labelRemaning.hidden = true
                self.timeOfDayDoneOut.hidden = true
                self.labelTimeofDay.hidden = true
            }
            clockIndex++
        }
        else if clockIndex == 2
        {
            dispatch_async(dispatch_get_main_queue()) {
                self.PercentDone.hidden = true
                self.TimeLeft.hidden = true
                self.TimeRemaining.hidden = false
                self.labelTotal.hidden = true
                self.labelRemaning.hidden = false
                self.timeOfDayDoneOut.hidden = true
                self.labelTimeofDay.hidden = true
            }
            clockIndex++
        }
        else if clockIndex == 3
        {
            dispatch_async(dispatch_get_main_queue()) {
                self.PercentDone.hidden = true
                self.TimeLeft.hidden = true
                self.TimeRemaining.hidden = true
                self.labelTotal.hidden = true
                self.labelRemaning.hidden = true
                self.timeOfDayDoneOut.hidden = false
                self.labelTimeofDay.hidden = false
            }
            clockIndex++
        }
        if clockIndex == 4
        {
            clockIndex = 0
        }
        
        
    }
    @IBOutlet var DetailsButt: UIButton!
    @IBOutlet var StopTempButt: UIButton!
    
    @IBAction func StopTempButt(sender: AnyObject) {

        StopTempButt.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                self.StopTempButt.transform = CGAffineTransformIdentity
            }, completion: nil)

        self.StopProcess("kcv8Nak7jEuKEJXpY32UCQ")
        
    }
    
    @IBAction func OpenDetails(sender: AnyObject) {
        
        DetailsView.hidden = false
    }
    
    func APICallTempToCold()
    {
        ProcessStartOptions("kcv8Nak7jEuKEJXpY32UCQ", options: "4")
        watchForTempChange = false
    }
    
    func APICallTempToHot()
    {
        ProcessStartOptions("kcv8Nak7jEuKEJXpY32UCQ", options: "37")
        watchForTempChange = false
    }
    
    
    func ProcessStartOptions(processId:String, options:String )
    {
        let urlToMod = "http://" + IPAdd + ":9001/api/processstart/"
        
        let myUrl = NSURL(string: urlToMod);
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        let thingTosay = ProcessArg(ProcessId: processId, Options: options)
        
        let postString = thingTosay.toJsonString()
        
        request.HTTPBody = postString!.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            do
            {
            
            if error != nil
            {
                //  println("error=\(error)")
                self.HTTPErrorText = "error=\(error)"
                self.setVal()
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            var err: NSError?
            var myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            }
            catch
            {}
        }
        task.resume()
    }
    
    
    func StopProcess(processID:String)
    {
        
        var urlToMod = "http://" + IPAdd + ":9001/api/processstop/"
        
        var myUrl = NSURL(string: urlToMod);
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        var thingTosay = ProcessArg(ProcessId: processID, Options: "")
        let postString = thingTosay.toJsonString()
        
        request.HTTPBody = postString!.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            do
            {
            
            if error != nil
            {
                self.HTTPErrorText = "error=\(error)"
                self.setVal()
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            var err: NSError?
            var myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
          
            
        }catch
        {}
        }
        task.resume()
    }
    
    
    
    @IBAction func TempToHot(sender: AnyObject) {
        
        HeatUpButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
 
        UIView.animateWithDuration(2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                self.HeatUpButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        if self.isTempOn == true {
            watchForTempChange = true
            isHotorCold = true
            self.StopProcess("kcv8Nak7jEuKEJXpY32UCQ")
        }
        else
        {
            APICallTempToHot()
        }

    }
    
    @IBAction func TempToCool(sender: AnyObject) {
        
        CoolDownButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                self.CoolDownButton.transform = CGAffineTransformIdentity
            }, completion: nil)

        if self.isTempOn == true {
            watchForTempChange = true
            isHotorCold = false
            self.StopProcess("kcv8Nak7jEuKEJXpY32UCQ")
        }
        else
        {
            APICallTempToCold()
        }
    }
    
    
    @IBOutlet var TempToCool: UIButton!
    
    
    @IBAction func IPChanged(sender: AnyObject) {

        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let newIP = NSEntityDescription.insertNewObjectForEntityForName("THEIP", inManagedObjectContext: context) as! THEIP
        
        newIP.setValue((sender as! UITextField).text, forKey: "ip")
        
        do {
            try context.save()
        } catch _ {
        }

        let request = NSFetchRequest(entityName: "THEIP")
        
        var results = (try! context.executeFetchRequest(request)) as! [THEIP]
        
        if( results.count > 0)
        {
            IPAdd = results[results.count - 1].ip
            
            for ip in results
            {
                print(ip.ip)
            }
            IP.text = IPAdd;
        }

        
        
        IPAdd = (sender as! UITextField).text!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func RunAllHTTPGetAPICalls()
    {
        StatusAPICall()
        FluidStatusAPICall()
        MakePlateFromAPIData()
       
    }

    
    func BuildPlateFromLoadProccess()
    {
        let proccessID = "HHiPO3Nkv0eaHnMJTqD6QQ"
        let urlToMod = "http://" + IPAdd + ":9001/api/processstatus/" + proccessID
        let myUrl = NSURL(string: urlToMod)

        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "GET";
        
        // Compose a query string
        let postString = "";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            do
            {
                
            
            
            if error != nil
            {
                // println("error=\(error)")
                self.HTTPErrorText = "error=\(error)"
                //   self.setVal()
                self.ConnectionIssue = true
                return
            }
            else
            {
                self.ConnectionIssue = false
            }
            
            //  println(response)
            
            self.ArrayRealPlate.removeAll(keepCapacity: false)
            
            // Print out response body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            var err: NSError?
            let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            
            let json = JSON(myJSON!)
            
            if let details = json["Status"]["Details"].string{
                
                let rawJSONData: NSData = details.dataUsingEncoding(NSUTF8StringEncoding)!
                var error: NSError?
                if let JSONResponseDictionary = try NSJSONSerialization.JSONObjectWithData(rawJSONData, options: .MutableLeaves) as? NSDictionary
                {
                    self.rows = 8
                    self.Colum = 12
                    self.ArrayRealPlate.removeAll(keepCapacity: false)
                    
                    for var i = 0; i < self.rows; i++
                    {
                        for var j = 0; j < self.Colum; j++
                        {
                            let lab = self.A2Z[i] + String((j + 1))
                            self.ArrayRealPlate.append(PlateItemModel(Lable: lab, Name: "", Status: 1))
                        }
                    }

                        if let plateDic = JSONResponseDictionary.valueForKey("Plate") as? NSDictionary
                        {
                            if let plateName = plateDic.valueForKey("PlateName") as? NSString
                            {
                                if plateName == "96"
                                {
                                    self.rows = 8
                                    self.Colum = 12
                                }
                                
                                if plateName == "40"
                                {
                                    self.rows = 5
                                    self.Colum = 8
                                }
                                
                                if plateName == "Stat" && self.StatusOut.text == "Acquiring"
                                {
                                    dispatch_sync(dispatch_get_main_queue()) {

                                        self.StatTubeView.hidden = false
                                        //self.CurrentWellOut.hidden = true
                                        
                                    }
                                }
                                else
                                {
                                    dispatch_sync(dispatch_get_main_queue()) {

                                    self.StatTubeView.hidden = true;
                                   // self.CurrentWellOut.hidden = false
                                    }
                                }
                                self.ArrayRealPlate.removeAll(keepCapacity: false)
                                for var i = 0; i < self.rows; i++
                                {
                                    for var j = 0; j < self.Colum; j++
                                    {
                                        let lab = self.A2Z[i] + String((j + 1))
                                        self.ArrayRealPlate.append(PlateItemModel(Lable: lab, Name: "", Status: 1))
                                    }
                                }
                            }
                        }
                }}
            
            }
            catch
            {}
            }
        task.resume()
    }


    
    func MakePlateFromAPIData()
    {

        self.BuildPlateFromLoadProccess()
        
        let proccessID = "sjlZnQDaPUqEbqEuOcektw"

        let urlToMod = "http://" + self.IPAdd + ":9001/api/processstatus/" + proccessID
        
        let myUrl = NSURL(string: urlToMod)
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "GET";
        
        // Compose a query string
        let postString = "";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            
            do
            {
                
            
            if error != nil
            {
                self.HTTPErrorText = "error=\(error)"
                self.setVal()
                self.ConnectionIssue = true
                return
            }
            else
            {
                self.ConnectionIssue = false
            }
            
            self.ArrayRealPlate.removeAll(keepCapacity: false)
            
            // Print out response body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            var err: NSError?
            let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            
            let json = JSON(myJSON!)
            
            if let details = json["Status"]["Details"].string{
                
                let rawJSONData: NSData = details.dataUsingEncoding(NSUTF8StringEncoding)!
                var error: NSError?
                if let jsonResponseDictionary = try NSJSONSerialization.JSONObjectWithData(rawJSONData, options: .MutableLeaves) as? NSDictionary
                {

                self.ArrayRealPlate.removeAll(keepCapacity: false)
                    
                for var i = 0; i < self.rows; i++
                {
                    for var j = 0; j < self.Colum; j++
                    {
                        let lab = self.A2Z[i] + String((j + 1))
                        self.ArrayRealPlate.append(PlateItemModel(Lable: lab, Name: "", Status: 1))
                    }
                }
                
                
                
                if let runstatus = jsonResponseDictionary.valueForKey("RunStatuses") as? NSDictionary
                {
                    var thing = runstatus.allKeys
                    
                    let dddddd =  String( thing[0] as! NSString)

                    if let runstatusLevel3 = runstatus.valueForKey(dddddd) as? NSDictionary
                    {
                        if let runstatusLevel4 = runstatusLevel3.valueForKey("StepStatuses") as? NSDictionary
                        {
                            for steps in runstatusLevel4
                            {
                                let wellstatus =  (steps.value as? NSDictionary)?.valueForKey("FileStatus") as! Int
                                let hitTest = (steps.value as? NSDictionary)?.valueForKey("HitTestValue") as! Double

                                for item in self.ArrayRealPlate
                                {
                                    if item.Lable == steps.key as! String
                                    {
                                        item.Status = wellstatus
                                        item.HitTest = hitTest
                                        //item.Name = sampleName
                                    }
                                }

                            }
                            
                            dispatch_sync(dispatch_get_main_queue()) {
                                
                                self.theCollection.reloadData()
                            }
                        }
                    }
                }

                    if let percentDone = jsonResponseDictionary.valueForKey("PercentComplete") as? Double
                    {
                        
                        let thingddddd = NSString(format: "%.0f", percentDone * 100)
                        let percent = "%"
                        
                        dispatch_sync(dispatch_get_main_queue()) {
                            
                            self.PercentDone.text = "\(thingddddd)\(percent)"
                        }
                    }
                    else{
                        dispatch_sync(dispatch_get_main_queue()) {
                            
                            self.PercentDone.text = ""
                        }
                    }
                    
                    if let timeLeft = jsonResponseDictionary.valueForKey("TimeElapsed") as? NSString
                    {
                        let formatter = NSDateFormatter()
                        formatter.locale = NSLocale(localeIdentifier: "en_US")
                        formatter.dateFormat = "HH:mm:ss.SS"
                        let etaString = timeLeft as String
                        if let generatedDate = formatter.dateFromString(etaString)
                        {
                            formatter.dateFormat = "HH:mm:ss"
                            let  fffffff = formatter.stringFromDate(generatedDate)

                            dispatch_sync(dispatch_get_main_queue()) {
                                
                                self.TimeLeft.text = fffffff
                            }
                        }
                    }
                    else
                    {
                        dispatch_sync(dispatch_get_main_queue()) {
                            
                            self.TimeLeft.text = ""
                        }
                    }
 
                    if let timeLeft = jsonResponseDictionary.valueForKey("TimeRemaining") as? NSString
                    {
                        let formatter = NSDateFormatter()
                        formatter.locale = NSLocale(localeIdentifier: "en_US")
                        formatter.dateFormat = "HH:mm:ss.SS"
                        let etaString = timeLeft as String
                        if let generatedDate = formatter.dateFromString(etaString)
                        {

                            formatter.dateFormat = "HH:mm:ss"
                            let  hourminsec = formatter.stringFromDate(generatedDate)
                            
                            formatter.dateFormat = "mm"
                            let  min = formatter.stringFromDate(generatedDate)
                            
                            dispatch_sync(dispatch_get_main_queue()) {
                                
                                self.TimeRemaining.text = hourminsec
                            }
                            
                            let thingtogo = (min as NSString).doubleValue
                            
                            let date = NSDate()
                            let calendar = NSCalendar.currentCalendar()
                            let components = calendar.components([.Hour, .Minute], fromDate: date)
                            let hour = components.hour
                            let minutes = components.minute
                            
                            let formatters = NSDateFormatter()
                            formatters.locale = NSLocale(localeIdentifier: "en_US")
                            formatters.dateFormat = "HH:mm a"
   
                            let time =  date.dateByAddingTimeInterval(thingtogo * 60.0)
                            let  formatedTime = formatters.stringFromDate(time)
                            
                      dispatch_sync(dispatch_get_main_queue()) {
                                
                                self.timeOfDayDoneOut.text = formatedTime
                            }
                        }
                    }
                    else
                    {
                        dispatch_sync(dispatch_get_main_queue()) {
                            
                            self.TimeRemaining.text = ""
                        }
                    }
                    
                    
                    if let runs = jsonResponseDictionary.valueForKey("Runs") as? NSArray {
                        
                        for runItem in runs
                        {

                            if let sam = runItem.valueForKey("Steps") as? NSArray
                            {
                                var sampleName = ""
                                
                                for well in sam
                                {
                                    let lab = well["WellId"]! as! String
                                    
                                    if let name = well["SampleName"]! as? String
                                    {
                                        sampleName = name
                                    }

                                    let status = well["SampleStatus"] as! Int
                                    
                                    for item in self.ArrayRealPlate
                                    {
                                        if item.Lable == lab
                                        {
                                            item.Status = status
                                            item.Name = sampleName
                                        }
                                    }
                                    
                                    //self.ArrayRealPlate.append(PlateItemModel(Lable: lab, Name: lab, Status: status))
                                }
                                
                            }
                        }
                        self.index = 0.0
                        if self.ArrayRealPlate.count < 40
                        {
                            dispatch_sync(dispatch_get_main_queue()) {
                                // self.theCollection.hidden = true
                                // self.PercentDone.hidden = true
                            }
                        }
                        else
                        {
                            dispatch_sync(dispatch_get_main_queue()) {
                                //  self.theCollection.hidden = false
                                // self.PercentDone.hidden = false
                                
                            }
                            dispatch_sync(dispatch_get_main_queue()) {
                                self.theCollection.reloadData()
                            }
                        }
                    }
                }
            }
            }
            catch
            {}
        }
        task.resume()
    }
    
    
    @IBAction func StartUp(sender: AnyObject) {
        
        
        StartUpButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                self.StartUpButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        let alert = UIAlertController(title: "Start", message: "Are you sure you want to start your Yeti?", preferredStyle: UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                self.ProcessStartOptions("G9YmHcihFUukolpuxi0lFw",options: "")
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: nil))
        
        //        dispatch_async(dispatch_get_main_queue()) {
        //         self.StartUpButton.hidden = true
        //        }
        
        
    }
    
    @IBAction func ShutDown(sender: AnyObject) {
        
        
        
        ShutDownButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                self.ShutDownButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        
        
        let alert = UIAlertController(title: "Shut Down", message: "Are you sure you want to shut down your Yeti?", preferredStyle: UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                self.ProcessStartOptions("Li-77xK4DESzHSLzwIMCGQ",options: "")
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: nil))
        //        dispatch_async(dispatch_get_main_queue()) {
        //            self.ShutDownButton.hidden = true
        //        }
        
        
    }
    
    //    @IBAction func SystemStatus(sender: AnyObject) {
    //
    //         ProcessStatusAPICall("swXmCQkfMUy8GXc7Uvo1qw")
    //    }
    //
    //    @IBAction func View(sender: AnyObject) {
    //
    //    }
    
    func setVal()
    {
        dispatch_sync(dispatch_get_main_queue(), {
            self.dataout1.text = self.HTTPErrorText
        })
    }
    
    
    @IBAction func RunQCAPICall(sender: AnyObject) {
        
        QCButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                self.QCButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        
       ProcessStartOptions("dzspBjyk40S5FuQgu4cDtw", options: "")
        
    }
    
    func StatusAPICall()
    {
        let proccessID = "swXmCQkfMUy8GXc7Uvo1qw"
        
        let urlToMod = "http://" + IPAdd + ":9001/api/processstatus/" + proccessID
        
        let myUrl = NSURL(string: urlToMod);
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "GET";
        
        // Compose a query string
        let postString = "";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            do
            {
            
            if error != nil
            {
                // println("error=\(error)")
                self.HTTPErrorText = "error=\(error)"
                self.setVal()
                return
            }
            
            
            var err: NSError?
            let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
   
            let json = JSON(myJSON!)
            if let status = json["Status"]["StatusType"].string{
                print("STATSSSS: \(status)")
            }
            
            if let details = json["Status"]["Details"].string{

                if let ttttttt: NSData = details.dataUsingEncoding(NSUTF8StringEncoding)
                {
                    var error: NSError?
                    
                    
                    
                    
                    if let ddddddd = try NSJSONSerialization.JSONObjectWithData(ttttttt, options: []) as? NSDictionary
                    {
                        if  let Name  = ddddddd.valueForKey("InstrumentName") as? String
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                self.NameOut.text = Name
                            }
                        }
                        
                        if let Status =  ddddddd.valueForKey("SystemStatus") as? Int
                        {
                            
                            var displayStatusText = ""
                            
                            if Status == 0
                            {
                                displayStatusText = "Unknown"
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    self.ActivityInd.stopAnimating()
                                }
                            }
                            else if Status == 2
                            {
                                displayStatusText = "Off"
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    self.ActivityInd.stopAnimating()
                                }
                            }
                            else if Status == 3
                            {
                                displayStatusText = "Starting Up"
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    self.ActivityInd.startAnimating()
                                }
                            }
                            else if Status == 4
                            {
                                displayStatusText = "Calibrating"
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    self.ActivityInd.startAnimating()
                                }
                                
                            }
                            else if Status == 5
                            {
                                displayStatusText = "Calibration Required"
                                self.ActivityInd.stopAnimating()
                            }
                            else if Status == 6
                            {
                                displayStatusText = "Ready"
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    self.ActivityInd.stopAnimating()
                                    self.theCollection.hidden = true
                                    
                                    
                                    self.PercentDone.text = ""
                                    self.TimeRemaining.text = ""
                                    self.TimeLeft.text = ""
                                    self.TimeViewButton.hidden = true
                                    self.CurrentWellOut.hidden = true
                                    self.SampleNameOut.hidden = true
                                    self.SampleNameOut.text = ""
                                    self.CurrentWellOut.text = ""
                                    self.labelTotal.hidden = true
                                    self.labelRemaning.hidden = true
                                    self.timeOfDayDoneOut.hidden = true
                                    self.labelTimeofDay.hidden = true
                                    
                                    
                                    self.StatTubeView.hidden = true;
                                    
                                    
                                }
                            }
                            else if Status == 7
                            {
                                displayStatusText = "Acquiring"
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    self.ActivityInd.startAnimating()
                                    self.PlateView.hidden = false
                                    self.StartUpButton.hidden = true;
                                    self.ShutDownButton.hidden = true;
                                    //self.QCButton.hidden = true
                                    self.TimeViewButton.hidden = false
                                    self.CurrentWellOut.hidden = false
                                    self.SampleNameOut.hidden = false
                                    self.theCollection.hidden = false
                                   
                                    
                                }
                            }
                            else if Status == 8
                            {
                                displayStatusText = "Shutting Down..."
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    self.ActivityInd.startAnimating()
                                }
                            }
                            else if Status == 9
                            {
                                displayStatusText = "Error"
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    self.ActivityInd.stopAnimating()
                                }
                            }
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.StatusOut.text = displayStatusText
                                
                            }
                            
                        }
                        else
                        {
                        }
                        
                        if let isTempOn  = ddddddd.valueForKey("IsTemperatureControlEnabled") as? Bool
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.isTempOn = isTempOn
                                
                            }
                        }
                        if let targetTemp  = ddddddd.valueForKey("TemperatureTarget_C") as? Double
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                if targetTemp > 15
                                    
                                {
                                    self.FireImage.hidden = false
                                    self.coolImage.hidden = true
                                }
                                else
                                {
                                    self.FireImage.hidden = true
                                    self.coolImage.hidden = false
                                }
                                self.TempTarget.text = String(stringInterpolationSegment: targetTemp)
                            }
                        }
                        
                        if  let tempReal  = ddddddd.valueForKey("TemperatureCurrent_C") as? Double
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                
                                let thing =  NSString(format: "%.0f", tempReal)
                                let sdddd = "°C"
                                
                                self.TemReal.text = (thing as String) + sdddd
                            }
                        }
                        
                        if let currentQuickActions = ddddddd.valueForKey("QuickActionProcessIds") as? [String]
                        {
                            
                            for quickActionItem in currentQuickActions
                            {
                                
                                //StartUp
                                if quickActionItem == "G9YmHcihFUukolpuxi0lFw"
                                {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.StartUpButton.hidden = false;
                                        self.ShutDownButton.hidden = true;
                                    }
                                }
                                
                                //Shutdown
                                if quickActionItem == "Li-77xK4DESzHSLzwIMCGQ"
                                {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.StartUpButton.hidden = true;
                                        self.ShutDownButton.hidden = false;
                                    }
                                }
                            }
                            
                        }
                        
                        
                        //var users = ddddddd!.valueForKey("Users") as! Array
                        
                        if let usersArray = ddddddd.valueForKey("Users") as? NSArray
                        {
                            let users = usersArray[0] as! String
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                self.Users.text = users
                            }
                        }
                        
                        if let firmV = ddddddd.valueForKey("FirmwareVersion") as? NSString
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.FirmOut.text = firmV as String
                            }
                        }
                        
                        if let softOut = ddddddd.valueForKey("SoftwareVersion") as? NSString
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.SoftwareVout.text = softOut as String
                                
                            }
                        }
                    }
                   
                }
            }
                }
                catch
                {}
        }
        task.resume()
    }
    
    
    func FluidStatusAPICall()
    {
        
            
        let proccessID = "hJlSw6fZ2kGptaB2eSvz4A"
        
        let urlToMod = "http://" + IPAdd + ":9001/api/processstatus/" + proccessID
        
        let myUrl = NSURL(string: urlToMod);
        
        //  myUrl +=  "api/processstatus/" + proccessID
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "GET";
        
        // Compose a query string
        let postString = "";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            
            do
            {
            
            if error != nil
            {
                // println("error=\(error)")
                self.HTTPErrorText = "error=\(error)"
                self.setVal()
                return
            }
            
            var err: NSError?
            
            
           
            
            let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
           
            let json = JSON(myJSON!)
            
            if let details = json["Status"]["Details"].string{
                
                if let ttttttt: NSData = details.dataUsingEncoding(NSUTF8StringEncoding)
                {
                    var error: NSError?
                    
                    if let ddddddd = try NSJSONSerialization.JSONObjectWithData(ttttttt, options: []) as? NSDictionary
                    {
                        var w1: Float = 0.0;
                        var w2: Float = 0.0;
                        var d1: Float = 0.0;
                        var d2: Float = 0.0;
                        
                        
                        if let Wast_1  = ddddddd.valueForKey("WastARatio") as? Float
                        {
                            w1 = Wast_1
                        }
                        if let Wast_2 =  ddddddd.valueForKey("WastBRatio") as? Float
                        {
                            w2 = Wast_2
                        }
                        if let DI_1 = ddddddd.valueForKey("DIARatio") as? Float
                        {
                            d1 = DI_1
                        }
                        if  let DI_2 = ddddddd.valueForKey("DIBRatio") as? Float
                        {
                            d2 = DI_2
                        }
                        if let timeLeft = ddddddd.valueForKey("TimeRemainingSeconds") as? Double
                        {
                            
                            let timeLeft4 = timeLeft / 60.0
                            
                            if timeLeft4 >= 60.0
                            {
                                
                                let timeHours = timeLeft4 / 60.0
                                
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    self.FluidLevel.text =   String(format:"%.f", timeHours) + "h"
                                }
                            }
                            else
                            {
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    self.FluidLevel.text =   String(format:"%.f", timeLeft4) + "min"
                                }
                            }
                        }
                        let realWast = (w1 + w2) / 2.0
                        let realDI = (d1 + d2) / 2.0
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                           // self.wast1.setProgress( realWast, animated: true)
                            self.DI1.setProgress( realDI, animated: true)
                        }
                    }
                    
                    
               
                }
            }
                
            }
            catch
            {}
        }
        task.resume()
            
     
    }
    
    @IBAction func findIP(sender: AnyObject) {
        
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            var indexme = 0
            var runing = true
            
            while runing
            {
                if self.ConnectionIssue == false
                {
                    runing = false
                    break
                }
                
                if indexme > 30
                {
                    break
                }
                
                self.IPAdd = "10.0.1." + String(indexme)
                
                indexme++
                
                sleep(1)
            }
            
        }
        
        
    }
    
    func ProcessStatusAPICall( proccessID:String )
    {
        let urlToMod = "http://" + IPAdd + ":9001/api/processstatus/" + proccessID
        
        let myUrl = NSURL(string: urlToMod);
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "GET";
        
        // Compose a query string
        let postString = "";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            
            do
            {
                
            
            if error != nil
            {
                //   println("error=\(error)")
                self.HTTPErrorText = "error=\(error)"
                self.setVal()
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            var err: NSError?
            let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            
            let json = JSON(myJSON!)
            }
            catch
            {}
        }
        task.resume()
    }
}
