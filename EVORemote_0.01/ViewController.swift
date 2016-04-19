//
//  ViewController.swift
//  EVORemote_0.02
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
    var pingTime: Double = 2;
    var index = 0.0;
    var Plate = [PlateItemModel]()
    var rows = 8
    var Colum = 12
    var CurrentName = ""
    var CurrentWell = ""
    var A2Z: [String] = [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" ]
    var lastwellID = ""
    var lastWellStatus = 0
    let httpsting = "http://"
    let port = ":9001"
    let apiPath = "/api/processstatus/"
    var httpAPIPath = ""
    var EVONetworkCommunicationController = NetworkCommunicationController(IP: "");
    let AvailableProcessIds =  ProcessIds()
    var newRunlistRequired = true;
    var plateName = "";
    
    
    //UI Outlet
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
    @IBOutlet var ConnectionIssueImage: UIImageView!
    @IBOutlet var PowerOnImage: UIImageView!
    @IBOutlet var TempControlView: UIView!
    @IBOutlet var Users: UILabel!
    @IBOutlet var QuickActionBar: UIView!
    @IBOutlet var LightButton: UIButton!
    @IBOutlet var DoorButton: UIButton!
    @IBOutlet var Light: UIButton!
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
    @IBOutlet var DetailsButt: UIButton!
    @IBOutlet var StopTempButt: UIButton!
    
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
                        self.QuickActionBar.hidden = true
                        self.QCButton.hidden = true
                        self.TempControlView.hidden = true
                        self.PlateView.hidden = true
                        self.connectTimeoutCount = 0
                        
                    }
                }
                else
                {
                    connectTimeoutCount += 1
                }
            }
            if ConnectionIssue == false
            {
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.ConnectionIssueImage.hidden = true
                    self.PowerOnImage.hidden = false
                    self.dataout1.text = ""
                    self.QuickActionBar.hidden = false
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
            EVONetworkCommunicationController = NetworkCommunicationController(IP: IPAdd);
            httpAPIPath = httpsting + IPAdd + port + apiPath
        }
        else
        {
        }
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        DetailsView.hidden = true

        let diceRoll = Int(arc4random_uniform(7))
        let placeHolder = PlateItemModel(Lable: String(diceRoll), Name: String(diceRoll), Status: diceRoll)
        for index in 1...97{
            placeHolder.Lable = String(index)
            Plate.append(placeHolder)
        }
        
        ConnectionIssueImage.hidden = true
        DI1.transform = CGAffineTransformMakeRotation(CGFloat(M_PI + M_PI_2))
        IP.delegate = self
        TempControlView.hidden = true
        
        NSTimer.scheduledTimerWithTimeInterval(pingTime, target: self, selector: #selector(ViewController.RunAllHTTPGetAPICalls), userInfo: nil, repeats: true)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.SamplePlateUICollection.hidden = true
            self.PercentDone.hidden = true
            self.TimeLeft.hidden = true
            self.TimeRemaining.hidden = false
            self.coolImage.hidden = true
            self.FireImage.hidden = true
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
    
    
    @IBOutlet var SamplePlateUICollection: UICollectionView!
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) 
        let ID = cell.viewWithTag(9898) as! UILabel
        index += 1
        
        var plate = Plate
        
        if !plate.isEmpty
    
        {
            let wellIndex = indexPath.row + Colum * indexPath.section
            
            ID.text = plate[wellIndex].Lable
            
            cell.layer.cornerRadius = cell.frame.size.width/2
            cell.clipsToBounds = true

            
             if plate[indexPath.row + Colum * indexPath.section].Status == 1
            {
                cell.layer.backgroundColor = UIColor.grayColor().CGColor
            }
            else if plate[indexPath.row + Colum * indexPath.section].Status == 2
            {
                cell.layer.backgroundColor = UIColor.orangeColor().CGColor
                
                self.CurrentName = plate[indexPath.row + Colum * indexPath.section].Name
                self.CurrentWell = plate[indexPath.row + Colum * indexPath.section].Lable
                
                dispatch_async(dispatch_get_main_queue()) {
                    if self.StatTubeView.hidden == true
                    {
                    self.SampleNameOut.text = self.CurrentName
                    self.CurrentWellOut.text = self.CurrentWell
                    }
                }
            }
            else if plate[indexPath.row + Colum * indexPath.section].Status == 3
            {
                cell.layer.backgroundColor =  UIColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 1).CGColor
            }
            else 
            {
                 cell.layer.backgroundColor = UIColor.grayColor().CGColor
            }
            
            if plate[indexPath.row + Colum * indexPath.section].HitTest > 0.15
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
            clockIndex += 1
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
            clockIndex += 1
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
            clockIndex += 1
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
            clockIndex += 1
        }
        if clockIndex == 4
        {
            clockIndex = 0
        }
        
        
    }

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

        self.EVONetworkCommunicationController.StopProcess(AvailableProcessIds.Temperature)
        
    }
    
    @IBAction func OpenDetails(sender: AnyObject) {
        
        DetailsView.hidden = false
    }
    
    func APICallTempToCold()
    {
       EVONetworkCommunicationController.ProcessStartOptions(AvailableProcessIds.Temperature, options: "4")
        watchForTempChange = false
    }
    
    func APICallTempToHot()
    {
        EVONetworkCommunicationController.ProcessStartOptions(AvailableProcessIds.Temperature, options: "37")
        watchForTempChange = false
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
            self.EVONetworkCommunicationController.StopProcess(AvailableProcessIds.Temperature)
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
            self.EVONetworkCommunicationController.StopProcess(AvailableProcessIds.Temperature)
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
            
//            for ip in results
//            {
//                print(ip.ip)
//            }
            IP.text = IPAdd;
            
           httpAPIPath = httpsting + IPAdd + port + apiPath
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
        UpdatePlateAPICall()
    }

    
    func BuildPlateFromLoadProccess()
    {
        let url = httpAPIPath + AvailableProcessIds.RunListManager
        let requestUrl = NSURL(string: url)

        let request = NSMutableURLRequest(URL:requestUrl!);
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
                self.ConnectionIssue = true
                return
            }
            else
            {
                self.ConnectionIssue = false
            }
            
            self.Plate.removeAll(keepCapacity: false)
            let rawJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            
            let json = JSON(rawJSON!)
            
            if let details = json["Status"]["Details"].string{
                
                let rawJSONData: NSData = details.dataUsingEncoding(NSUTF8StringEncoding)!
                if let JSONResponseDictionary = try NSJSONSerialization.JSONObjectWithData(rawJSONData, options: .MutableLeaves) as? NSDictionary
                {
                    self.rows = 8
                    self.Colum = 12
                    self.Plate.removeAll(keepCapacity: false)
                    
                    for i in 0 ..< self.rows
                    {
                        for j in 0 ..< self.Colum
                        {
                            let lab = self.A2Z[i] + String((j + 1))
                            self.Plate.append(PlateItemModel(Lable: lab, Name: "", Status: 1))
                        }
                    }
                    
                    if let runlistdefinitionn = JSONResponseDictionary.valueForKey("RunListDefinition") as? NSDictionary
                    {
                        if let plateDictionary = runlistdefinitionn.valueForKey("Plate") as? NSDictionary
                        {
                            if let plateName = plateDictionary.valueForKey("PlateName") as? NSString
                            {
                                 self.plateName = plateName as String;
                                
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
                                        self.CurrentWellOut.hidden = true
                                    }
                                }
                                else
                                {
                                    dispatch_sync(dispatch_get_main_queue()) {
                                    self.StatTubeView.hidden = true;
                                    self.CurrentWellOut.hidden = false
                                    }
                                }
                                self.Plate.removeAll(keepCapacity: false)
                                for i in 0 ..< self.rows
                                {
                                    for j in 0 ..< self.Colum
                                    {
                                        let lab = self.A2Z[i] + String((j + 1))
                                        self.Plate.append(PlateItemModel(Lable: lab, Name: "", Status: 1))
                                    }
                                }
                            }
                        }
                }}
            
                }}
            catch
            {}
            }
        task.resume()
    }

 
    func UpdatePlateAPICall()
    {
        if  self.StatusOut.text == "Acquiring" && self.newRunlistRequired == true {
            
            self.BuildPlateFromLoadProccess()
            self.newRunlistRequired = false
        }
        
        let url = httpAPIPath + AvailableProcessIds.RunList
        let requestUrl = NSURL(string: url)
        let request = NSMutableURLRequest(URL:requestUrl!);
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
            
            self.Plate.removeAll(keepCapacity: false)
            

            let rawJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            
            let json = JSON(rawJSON!)
            
            if let details = json["Status"]["Details"].string{
                
                let rawJSONData: NSData = details.dataUsingEncoding(NSUTF8StringEncoding)!
                
                if let jsonResponseDictionary = try NSJSONSerialization.JSONObjectWithData(rawJSONData, options: .MutableLeaves) as? NSDictionary
                {

                self.Plate.removeAll(keepCapacity: false)
                    
                for i in 0 ..< self.rows
                {
                    for j in 0 ..< self.Colum
                    {
                        let lab = self.A2Z[i] + String((j + 1))
                        self.Plate.append(PlateItemModel(Lable: lab, Name: "", Status: 1))
                    }
                }
                
                if let runstatusDictionary = jsonResponseDictionary.valueForKey("RunStatuses") as? NSDictionary
                {
                    for stepID in runstatusDictionary
                    {
                    if let stepIDkey = runstatusDictionary.valueForKey(stepID.key as! String) as? NSDictionary
                    {
                        if let stepStatuses = stepIDkey.valueForKey("StepStatuses") as? NSDictionary
                        {
                            for steps in stepStatuses
                            {
                                let wellstatus =  (steps.value as? NSDictionary)?.valueForKey("SampleStatus") as! Int
                                let hitTest = (steps.value as? NSDictionary)?.valueForKey("HitTestValue") as! Double
                                  let sampleName = (steps.value as? NSDictionary)?.valueForKey("Name") as! String
                                
                                for item in self.Plate
                                {
                                    if item.Lable == steps.key as! String
                                    {
                                        item.Status = wellstatus
                                        item.HitTest = hitTest
                                        item.Name = sampleName
                                    }
                                }

                            }
                        }
                    }
                    }
                }
                    dispatch_sync(dispatch_get_main_queue()) {
                        
                        self.SamplePlateUICollection.reloadData()
                    }

                    if let percentDone = jsonResponseDictionary.valueForKey("PercentComplete") as? Double
                    {
                        
                        let percentScaled = NSString(format: "%.0f", percentDone * 100)
                        let percent = "%"
                        
                        dispatch_sync(dispatch_get_main_queue()) {
                            
                            self.PercentDone.text = "\(percentScaled)\(percent)"
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
                            let  formatedTime = formatter.stringFromDate(generatedDate)

                            dispatch_sync(dispatch_get_main_queue()) {
                                
                                self.TimeLeft.text = formatedTime
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
                            if let steps = runItem.valueForKey("Steps") as? NSArray
                            {
                                var sampleName = ""
                                
                                for well in steps
                                {
                                    let lab = well["WellId"]! as! String
                                    
                                    if let name = well["SampleName"]! as? String
                                    {
                                        sampleName = name
                                    }

                                    let status = well["SampleStatus"] as! Int
                                    
                                    for item in self.Plate
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
                        if self.Plate.count < 40
                        {
                            dispatch_sync(dispatch_get_main_queue()) {
                                 self.SamplePlateUICollection.hidden = true
                                 self.PercentDone.hidden = true
                            }
                        }
                        else
                        {
                            dispatch_sync(dispatch_get_main_queue()) {
                                  self.SamplePlateUICollection.hidden = false
                                 self.PercentDone.hidden = false
                                
                            }
                            dispatch_sync(dispatch_get_main_queue()) {
                                self.SamplePlateUICollection.reloadData()
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
        self.presentViewController(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                self.EVONetworkCommunicationController.ProcessStartOptions(self.AvailableProcessIds.Startup,options: "")
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: nil))
        
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
        self.presentViewController(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                self.EVONetworkCommunicationController.ProcessStartOptions("Li-77xK4DESzHSLzwIMCGQ",options: "")
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: nil))
    }
    
    
    func setVal()
    {
        dispatch_sync(dispatch_get_main_queue(), {
            self.dataout1.text = self.HTTPErrorText
        })
    }
    
    
    @IBAction func LightButtonAction(sender: AnyObject) {
        LightButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(2.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 6.0,
                                   options: UIViewAnimationOptions.AllowUserInteraction,
                                   animations: {
                                    self.LightButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        EVONetworkCommunicationController.ProcessStartOptions(AvailableProcessIds.LoaderLightToggle, options: "")
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
        
       EVONetworkCommunicationController.ProcessStartOptions(AvailableProcessIds.PmtQC, options: "")
        
    }
    
    func StatusAPICall()
    {
        
        let urlToMod = httpAPIPath + AvailableProcessIds.SystemStatus
        
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
                self.HTTPErrorText = "error=\(error)"
                self.setVal()
                return
            }
            
            let rawJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            let json = JSON(rawJSON!)

            if let details = json["Status"]["Details"].string{

                if let detailsData: NSData = details.dataUsingEncoding(NSUTF8StringEncoding)
                {
                    if let statusDictionary = try NSJSONSerialization.JSONObjectWithData(detailsData, options: []) as? NSDictionary
                    {
                        if  let Name  = statusDictionary.valueForKey("InstrumentName") as? String
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                self.NameOut.text = Name
                            }
                        }
                        
                        if let Status =  statusDictionary.valueForKey("SystemStatus") as? Int
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
                                    self.SamplePlateUICollection.hidden = true
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
                                    self.StatTubeView.hidden = true
                                    self.newRunlistRequired = true
                                    
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
                                  
                                   if self.plateName != "Stat"
                                   {
                                    self.CurrentWellOut.hidden = false
                                    }
                                    
                                    self.SampleNameOut.hidden = false
                                    self.SamplePlateUICollection.hidden = false
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
                        
                        if let isTempOn  = statusDictionary.valueForKey("IsTemperatureControlEnabled") as? Bool
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.isTempOn = isTempOn
                                
                            }
                        }
                        if let targetTemp  = statusDictionary.valueForKey("TemperatureTarget_C") as? Double
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
                        
                        if  let tempReal  = statusDictionary.valueForKey("TemperatureCurrent_C") as? Double
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                let formatedTemp =  NSString(format: "%.0f", tempReal)
                                let c = "°C"
                                
                                self.TemReal.text = (formatedTemp as String) + c
                            }
                        }
                        
                        if let currentQuickActions = statusDictionary.valueForKey("QuickActionProcessIds") as? [String]
                        {
                            
                            for quickActionItem in currentQuickActions
                            {
                                
                                //StartUp
                                if quickActionItem == self.AvailableProcessIds.Startup
                                {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.StartUpButton.hidden = false;
                                        self.ShutDownButton.hidden = true;
                                    }
                                }
                                
                                //Shutdown
                                if quickActionItem ==  self.AvailableProcessIds.Shutdown
                                {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.StartUpButton.hidden = true;
                                        self.ShutDownButton.hidden = false;
                                    }
                                }
                            }
                            
                        }

                        if let usersArray = statusDictionary.valueForKey("Users") as? NSArray
                        {
                            let users = usersArray[0] as! String
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                self.Users.text = users
                            }
                        }
                        
                        if let firmwareVersion = statusDictionary.valueForKey("FirmwareVersion") as? NSString
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.FirmOut.text = firmwareVersion as String
                            }
                        }
                        
                        if let softwareVersion = statusDictionary.valueForKey("SoftwareVersion") as? NSString
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.SoftwareVout.text = softwareVersion as String
                                
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
    @IBAction func DoorAction(sender: AnyObject) {
        
        DoorButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(2.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 6.0,
                                   options: UIViewAnimationOptions.AllowUserInteraction,
                                   animations: {
                                    self.DoorButton.transform = CGAffineTransformIdentity
            }, completion: nil)

        EVONetworkCommunicationController.ProcessStartOptions(AvailableProcessIds.LoaderDoorToggle, options: "")
    }
    
    func FluidStatusAPICall()
    {
        let url = httpAPIPath + AvailableProcessIds.BulkFluids
        let requestUrl = NSURL(string: url);
        let request = NSMutableURLRequest(URL:requestUrl!);
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
                return
            }
             
            let rawJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
           
            let json = JSON(rawJSON!)
            
            if let details = json["Status"]["Details"].string{
                
                if let statusDetails: NSData = details.dataUsingEncoding(NSUTF8StringEncoding)
                {
                    if let detailsDictionary = try NSJSONSerialization.JSONObjectWithData(statusDetails, options: []) as? NSDictionary
                    {
                        var d1: Float = 0.0;
                        var d2: Float = 0.0;
                        
                        if let DI_1 = detailsDictionary.valueForKey("DIARatio") as? Float
                        {
                            d1 = DI_1
                        }
                        if  let DI_2 = detailsDictionary.valueForKey("DIBRatio") as? Float
                        {
                            d2 = DI_2
                        }
                        if let timeLeft = detailsDictionary.valueForKey("TimeRemainingSeconds") as? Double
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
                       
                        let realDI = (d1 + d2) / 2.0
                        dispatch_async(dispatch_get_main_queue()) {
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
    

    
    func ProcessStatusAPICall( proccessID:String )
    {
        let url = httpAPIPath + proccessID
        let requestUrl = NSURL(string: url);
        
        let request = NSMutableURLRequest(URL:requestUrl!);
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
                return
            }
                
            }
        }
        task.resume()
    }
}
