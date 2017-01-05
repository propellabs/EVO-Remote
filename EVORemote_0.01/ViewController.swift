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
    
    var newone = ""
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
    var tempval = "";
    
    
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
                DispatchQueue.main.async {
                    
                    self.TempControlView.isHidden = true
                }
                
                if watchForTempChange == true
                {
                    if isHotorCold == true
                    {
                        APICallTempToHot ()
                        
                        DispatchQueue.main.async {
                            self.FireImage.isHidden = false
                            self.coolImage.isHidden = true
                        }
                    }
                    else
                    {
                        APICallTempToCold ()
                        DispatchQueue.main.async {
                            self.FireImage.isHidden = true
                            self.coolImage.isHidden = false
                        }
                    }
                }
            }
            if isTempOn == true
            {
                DispatchQueue.main.async {
                    
                    self.TempControlView.isHidden = false
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
                    DispatchQueue.main.async {
                        
                        self.ConnectionIssueImage.isHidden = false
                        self.PowerOnImage.isHidden = true
                        self.StatusOut.text = ""
                        self.NameOut.text = ""
                        self.Users.text = ""
                        self.DI1.progress = 0.0
                        self.QuickActionBar.isHidden = true
                        self.QCButton.isHidden = true
                        self.TempControlView.isHidden = true
                        self.PlateView.isHidden = true
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
                DispatchQueue.main.async {
                    
                    self.ConnectionIssueImage.isHidden = true
                    self.PowerOnImage.isHidden = false
                    self.dataout1.text = ""
                    self.QuickActionBar.isHidden = false
                    self.QCButton.isHidden = false
                    self.PlateView.isHidden = false
                }
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "THEIP")
        
        var results = (try! context.fetch(request)) as! [THEIP]
        
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
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        DetailsView.isHidden = true

        let diceRoll = Int(arc4random_uniform(7))
        let placeHolder = PlateItemModel(Lable: String(diceRoll), Name: String(diceRoll), Status: diceRoll)
        for index in 1...97{
            placeHolder.Lable = String(index)
            Plate.append(placeHolder)
        }
        
        ConnectionIssueImage.isHidden = true
        DI1.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI + M_PI_2))
        IP.delegate = self
        TempControlView.isHidden = true
        
        Timer.scheduledTimer(timeInterval: pingTime, target: self, selector: #selector(ViewController.RunAllHTTPGetAPICalls), userInfo: nil, repeats: true)
        
        DispatchQueue.main.async {
            self.SamplePlateUICollection.isHidden = true
            self.PercentDone.isHidden = true
            self.TimeLeft.isHidden = true
            self.TimeRemaining.isHidden = false
            self.coolImage.isHidden = true
            self.FireImage.isHidden = true
            self.StatTubeView.isHidden = true;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Colum
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rows
    }
    
    
    @IBOutlet var SamplePlateUICollection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) 
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
                cell.layer.backgroundColor = UIColor.gray.cgColor
            }
            else if plate[indexPath.row + Colum * indexPath.section].Status == 2
            {
                cell.layer.backgroundColor = UIColor.orange.cgColor
                
                self.CurrentName = plate[indexPath.row + Colum * indexPath.section].Name
                self.CurrentWell = plate[indexPath.row + Colum * indexPath.section].Lable
                
                DispatchQueue.main.async {
                    if self.StatTubeView.isHidden == true
                    {
                    self.SampleNameOut.text = self.CurrentName
                    self.CurrentWellOut.text = self.CurrentWell
                    }
                }
            }
            else if plate[indexPath.row + Colum * indexPath.section].Status == 3
            {
                cell.layer.backgroundColor =  UIColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 1).cgColor
            }
            else 
            {
                 cell.layer.backgroundColor = UIColor.gray.cgColor
            }
            
            if plate[indexPath.row + Colum * indexPath.section].HitTest > 0.15
            {
                cell.layer.backgroundColor = UIColor.green.cgColor
            }
       
        }
        return cell
    }
    
    @IBAction func DetailViewControl(_ sender: AnyObject) {
        
        DetailsButt.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.DetailsButt.transform = CGAffineTransform.identity
            }, completion: nil)
        
        
        DetailsView.isHidden = !DetailsView.isHidden
    }
    
    @IBAction func CloseDetails(_ sender: AnyObject) {
        
        DetailsView.isHidden = true
    }
    
    var clockIndex = 0
    
    @IBAction func ClockSwitchView(_ sender: AnyObject) {
        
        TimeViewButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.TimeViewButton.transform = CGAffineTransform.identity
            }, completion: nil)
        
        
        if clockIndex == 0
        {
            DispatchQueue.main.async {
                self.PercentDone.isHidden = true
                self.TimeLeft.isHidden = false
                self.TimeRemaining.isHidden = true
                self.labelTotal.isHidden = false
                self.labelRemaning.isHidden = true
                self.timeOfDayDoneOut.isHidden = true
                self.labelTimeofDay.isHidden = true
            }
            clockIndex += 1
        }
        else if clockIndex == 1
        {
            DispatchQueue.main.async {
                self.PercentDone.isHidden = false
                self.TimeLeft.isHidden = true
                self.TimeRemaining.isHidden = true
                self.labelTotal.isHidden = true
                self.labelRemaning.isHidden = true
                self.timeOfDayDoneOut.isHidden = true
                self.labelTimeofDay.isHidden = true
            }
            clockIndex += 1
        }
        else if clockIndex == 2
        {
            DispatchQueue.main.async {
                self.PercentDone.isHidden = true
                self.TimeLeft.isHidden = true
                self.TimeRemaining.isHidden = false
                self.labelTotal.isHidden = true
                self.labelRemaning.isHidden = false
                self.timeOfDayDoneOut.isHidden = true
                self.labelTimeofDay.isHidden = true
            }
            clockIndex += 1
        }
        else if clockIndex == 3
        {
            DispatchQueue.main.async {
                self.PercentDone.isHidden = true
                self.TimeLeft.isHidden = true
                self.TimeRemaining.isHidden = true
                self.labelTotal.isHidden = true
                self.labelRemaning.isHidden = true
                self.timeOfDayDoneOut.isHidden = false
                self.labelTimeofDay.isHidden = false
            }
            clockIndex += 1
        }
        if clockIndex == 4
        {
            clockIndex = 0
        }
        
        
    }

    @IBAction func StopTempButt(_ sender: AnyObject) {

        StopTempButt.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.StopTempButt.transform = CGAffineTransform.identity
            }, completion: nil)

        self.EVONetworkCommunicationController.StopProcess(AvailableProcessIds.Temperature)
        
    }
    
    @IBAction func OpenDetails(_ sender: AnyObject) {
        
        DetailsView.isHidden = false
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
    
    
    
    @IBAction func TempToHot(_ sender: AnyObject) {
        
        HeatUpButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
 
        UIView.animate(withDuration: 2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.HeatUpButton.transform = CGAffineTransform.identity
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
    
    @IBAction func TempToCool(_ sender: AnyObject) {
        
        CoolDownButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.CoolDownButton.transform = CGAffineTransform.identity
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
    
    
    @IBAction func IPChanged(_ sender: AnyObject) {

        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let newIP = NSEntityDescription.insertNewObject(forEntityName: "THEIP", into: context) as! THEIP
        
        newIP.setValue((sender as! UITextField).text, forKey: "ip")
        
        do {
            try context.save()
        } catch _ {
        }

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "THEIP")
        
        var results = (try! context.fetch(request)) as! [THEIP]
        
        if( results.count > 0)
        {
            IPAdd = results[results.count - 1].ip
            
//            for ip in results
//            {
//                print(ip.ip)
//            }
            IP.text = IPAdd;
            
           EVONetworkCommunicationController.IP = IPAdd
            
           httpAPIPath = httpsting + IPAdd + port + apiPath
        }
        IPAdd = (sender as! UITextField).text!
        EVONetworkCommunicationController.IP = IPAdd
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        let requestUrl = URL(string: url)

        var request = URLRequest(url:requestUrl!);
        request.httpMethod = "GET";
        
        // Compose a query string
        let postString = "";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
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
            
            self.Plate.removeAll(keepingCapacity: false)
            let rawJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
            
            let json = JSON(rawJSON!)
            
            if let details = json["Status"]["Details"].string{
                
                let rawJSONData: Data = details.data(using: String.Encoding.utf8)!
                if let JSONResponseDictionary = try JSONSerialization.jsonObject(with: rawJSONData, options: .mutableLeaves) as? NSDictionary
                {
                    self.rows = 8
                    self.Colum = 12
                    self.Plate.removeAll(keepingCapacity: false)
                    
                    for i in 0 ..< self.rows
                    {
                        for j in 0 ..< self.Colum
                        {
                            let lab = self.A2Z[i] + String((j + 1))
                            self.Plate.append(PlateItemModel(Lable: lab, Name: "", Status: 1))
                        }
                    }
                    
                    if let runlistdefinitionn = JSONResponseDictionary.value(forKey: "RunListDefinition") as? NSDictionary
                    {
                        if let plateDictionary = runlistdefinitionn.value(forKey: "Plate") as? NSDictionary
                        {
                            if let plateName = plateDictionary.value(forKey: "PlateName") as? NSString
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
                                    DispatchQueue.main.sync {

                                        self.StatTubeView.isHidden = false
                                        self.CurrentWellOut.isHidden = true
                                    }
                                }
                                else
                                {
                                    DispatchQueue.main.sync {
                                    self.StatTubeView.isHidden = true;
                                    self.CurrentWellOut.isHidden = false
                                    }
                                }
                                self.Plate.removeAll(keepingCapacity: false)
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
            }) 
        task.resume()
    }

 
    func UpdatePlateAPICall()
    {
        if  self.StatusOut.text == "Acquiring" && self.newRunlistRequired == true {
            
            self.BuildPlateFromLoadProccess()
            self.newRunlistRequired = false
        }
        
        let url = httpAPIPath + AvailableProcessIds.RunList
        let requestUrl = URL(string: url)
        var request = URLRequest(url:requestUrl!);
        request.httpMethod = "GET";
        
        // Compose a query string
        let postString = "";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
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
            
            self.Plate.removeAll(keepingCapacity: false)
            

            let rawJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
            
            let json = JSON(rawJSON!)
            
            if let details = json["Status"]["Details"].string{
                
                let rawJSONData: Data = details.data(using: String.Encoding.utf8)!
                
                if let jsonResponseDictionary = try JSONSerialization.jsonObject(with: rawJSONData, options: .mutableLeaves) as? NSDictionary
                {

                self.Plate.removeAll(keepingCapacity: false)
                    
                for i in 0 ..< self.rows
                {
                    for j in 0 ..< self.Colum
                    {
                        let lab = self.A2Z[i] + String((j + 1))
                        self.Plate.append(PlateItemModel(Lable: lab, Name: "", Status: 1))
                    }
                }
                
                if let runstatusDictionary = jsonResponseDictionary.value(forKey: "RunStatuses") as? NSDictionary
                {
                    for stepID in runstatusDictionary
                    {
                    if let stepIDkey = runstatusDictionary.value(forKey: stepID.key as! String) as? NSDictionary
                    {
                        if let stepStatuses = stepIDkey.value(forKey: "StepStatuses") as? NSDictionary
                        {
                            for steps in stepStatuses
                            {
                                let wellstatus =  (steps.value as? NSDictionary)?.value(forKey: "SampleStatus") as! Int
                                //let hitTest = (steps.value as? NSDictionary)?.valueForKey("HitTestValue") as! Double
                                  let sampleName = (steps.value as? NSDictionary)?.value(forKey: "Name") as! String
                                
                                for item in self.Plate
                                {
                                    if item.Lable == steps.key as! String
                                    {
                                        item.Status = wellstatus
                                      //  item.HitTest = hitTest
                                        //Push another beta
                                        item.Name = sampleName
                                    }
                                }

                            }
                        }
                    }
                    }
                }
                    DispatchQueue.main.sync {
                        
                        self.SamplePlateUICollection.reloadData()
                    }

                    if let percentDone = jsonResponseDictionary.value(forKey: "PercentComplete") as? Double
                    {
                        
                        let percentScaled = NSString(format: "%.0f", percentDone * 100)
                        let percent = "%"
                        
                        DispatchQueue.main.sync {
                            
                            self.PercentDone.text = "\(percentScaled)\(percent)"
                        }
                    }
                    else{
                        DispatchQueue.main.sync {
                            
                            self.PercentDone.text = ""
                        }
                    }
                    
                    if let timeLeft = jsonResponseDictionary.value(forKey: "TimeElapsed") as? NSString
                    {
                        let formatter = DateFormatter()
                        formatter.locale = Locale(identifier: "en_US")
                        formatter.dateFormat = "HH:mm:ss.SS"
                        let etaString = timeLeft as String
                        if let generatedDate = formatter.date(from: etaString)
                        {
                            formatter.dateFormat = "HH:mm:ss"
                            let  formatedTime = formatter.string(from: generatedDate)

                            DispatchQueue.main.sync {
                                
                                self.TimeLeft.text = formatedTime
                            }
                        }
                    }
                    else
                    {
                        DispatchQueue.main.sync {
                            
                            self.TimeLeft.text = ""
                        }
                    }
 
                    if let timeLeft = jsonResponseDictionary.value(forKey: "TimeRemaining") as? NSString
                    {
                        let formatter = DateFormatter()
                        formatter.locale = Locale(identifier: "en_US")
                        formatter.dateFormat = "HH:mm:ss.SS"
                        let etaString = timeLeft as String
                        if let generatedDate = formatter.date(from: etaString)
                        {

                            formatter.dateFormat = "HH:mm:ss"
                            let  hourminsec = formatter.string(from: generatedDate)
                            
                            formatter.dateFormat = "mm"
                            let  min = formatter.string(from: generatedDate)
                            
                            DispatchQueue.main.sync {
                                
                                self.TimeRemaining.text = hourminsec
                            }
                            
                            let thingtogo = (min as NSString).doubleValue
                            
                            let date = Date()
                   
                            let formatters = DateFormatter()
                            formatters.locale = Locale(identifier: "en_US")
                            formatters.dateFormat = "HH:mm a"
   
                            let time =  date.addingTimeInterval(thingtogo * 60.0)
                            let  formatedTime = formatters.string(from: time)
                            
                      DispatchQueue.main.sync {
                                
                                self.timeOfDayDoneOut.text = formatedTime
                            }
                        }
                    }
                    else
                    {
                        DispatchQueue.main.sync {
                            
                            self.TimeRemaining.text = ""
                        }
                    }
                    
                    
                    if let runs = jsonResponseDictionary.value(forKey: "Runs") as? NSArray {
                        
                        for runItem in runs
                        {
                            if let steps = (runItem as! Dictionary<String, AnyObject>)["Steps"] as? NSArray
                            {
                                var sampleName = ""
                                
                                for well  in steps
                                {
                                    
                                    var wellTemp = well  as! Dictionary<String, AnyObject>
                                    let lab = wellTemp["WellId"]! as! String
                                    
                                    if let name = wellTemp["SampleName"]! as? String
                                    {
                                        sampleName = name
                                    }

                                    let status = wellTemp["SampleStatus"] as! Int
                                    
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
                            DispatchQueue.main.sync {
                                 self.SamplePlateUICollection.isHidden = true
                                 self.PercentDone.isHidden = true
                            }
                        }
                        else
                        {
                            DispatchQueue.main.sync {
                                  self.SamplePlateUICollection.isHidden = false
                                 self.PercentDone.isHidden = false
                                
                            }
                            DispatchQueue.main.sync {
                                self.SamplePlateUICollection.reloadData()
                            }
                        }
                    }
                }
            }
            }
            catch
            {}
        }) 
        task.resume()
    }
    
    
    @IBAction func StartUp(_ sender: AnyObject) {
        
        StartUpButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.StartUpButton.transform = CGAffineTransform.identity
            }, completion: nil)
        
        let alert = UIAlertController(title: "Start", message: "Are you sure you want to start your Yeti?", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.EVONetworkCommunicationController.ProcessStartOptions(self.AvailableProcessIds.Startup,options: "")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default,handler: nil))
        
    }
    
    @IBAction func ShutDown(_ sender: AnyObject) {
        
        ShutDownButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.ShutDownButton.transform = CGAffineTransform.identity
            }, completion: nil)
        
        let alert = UIAlertController(title: "Shut Down", message: "Are you sure you want to shut down your Yeti?", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.EVONetworkCommunicationController.ProcessStartOptions("Li-77xK4DESzHSLzwIMCGQ",options: "")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default,handler: nil))
    }
    
    
    func setVal()
    {
        DispatchQueue.main.sync(execute: {
            self.dataout1.text = self.HTTPErrorText
        })
    }
    
    
    @IBAction func LightButtonAction(_ sender: AnyObject) {
        LightButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 2.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 6.0,
                                   options: UIViewAnimationOptions.allowUserInteraction,
                                   animations: {
                                    self.LightButton.transform = CGAffineTransform.identity
            }, completion: nil)
        
        EVONetworkCommunicationController.ProcessStartOptions(AvailableProcessIds.LoaderLightToggle, options: "")
    }

    
    
    @IBAction func RunQCAPICall(_ sender: AnyObject) {
        
        QCButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.QCButton.transform = CGAffineTransform.identity
            }, completion: nil)
        
       EVONetworkCommunicationController.ProcessStartOptions(AvailableProcessIds.PmtQC, options: "")
        
    }
    
    func StatusAPICall()
    {
        
        let urlToMod = httpAPIPath + AvailableProcessIds.SystemStatus
        
        let myUrl = URL(string: urlToMod);
        
        var request = URLRequest(url:myUrl!);
        request.httpMethod = "GET";
        
        // Compose a query string
        let postString = "";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            do
            {
            if error != nil
            {
                self.HTTPErrorText = "error=\(error)"
                self.setVal()
                return
            }
            
            let rawJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
            let json = JSON(rawJSON!)

            if let details = json["Status"]["Details"].string{

                if let detailsData: Data = details.data(using: String.Encoding.utf8)
                {
                    if let statusDictionary = try JSONSerialization.jsonObject(with: detailsData, options: []) as? NSDictionary
                    {
                        if  let Name  = statusDictionary.value(forKey: "InstrumentName") as? String
                        {
                            DispatchQueue.main.async {
                                
                                self.NameOut.text = Name
                            }
                        }
                        
                        if let Status =  statusDictionary.value(forKey: "SystemStatus") as? Int
                        {
                            
                            var displayStatusText = ""
                            
                            if Status == 0
                            {
                                displayStatusText = "Unknown"
                                DispatchQueue.main.async {
                                    
                                    self.ActivityInd.stopAnimating()
                                }
                            }
                            else if Status == 2
                            {
                                displayStatusText = "Off"
                                DispatchQueue.main.async {
                                    
                                    self.ActivityInd.stopAnimating()
                                }
                            }
                            else if Status == 3
                            {
                                displayStatusText = "Starting Up"
                                DispatchQueue.main.async {
                                    
                                    self.ActivityInd.startAnimating()
                                }
                            }
                            else if Status == 4
                            {
                                displayStatusText = "Calibrating"
                                DispatchQueue.main.async {
                                    
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
                                DispatchQueue.main.async {
                                    
                                    self.ActivityInd.stopAnimating()
                                    self.SamplePlateUICollection.isHidden = true
                                    self.PercentDone.text = ""
                                    self.TimeRemaining.text = ""
                                    self.TimeLeft.text = ""
                                    self.TimeViewButton.isHidden = true
                                    self.CurrentWellOut.isHidden = true
                                    self.SampleNameOut.isHidden = true
                                    self.SampleNameOut.text = ""
                                    self.CurrentWellOut.text = ""
                                    self.labelTotal.isHidden = true
                                    self.labelRemaning.isHidden = true
                                    self.timeOfDayDoneOut.isHidden = true
                                    self.labelTimeofDay.isHidden = true
                                    self.StatTubeView.isHidden = true
                                    self.newRunlistRequired = true
                                    
                                                                    }
                            }
                            else if Status == 7
                            {
                                displayStatusText = "Acquiring"
                                DispatchQueue.main.async {
                                    
                                    self.ActivityInd.startAnimating()
                                    self.PlateView.isHidden = false
                                    self.StartUpButton.isHidden = true;
                                    self.ShutDownButton.isHidden = true;
                                    //self.QCButton.hidden = true
                                    self.TimeViewButton.isHidden = false
                                  
                                   if self.plateName != "Stat"
                                   {
                                    self.CurrentWellOut.isHidden = false
                                    }
                                    
                                    self.SampleNameOut.isHidden = false
                                    self.SamplePlateUICollection.isHidden = false
                                }
                            }
                            else if Status == 8
                            {
                                displayStatusText = "Shutting Down..."
                                DispatchQueue.main.async {
                                    
                                    self.ActivityInd.startAnimating()
                                }
                            }
                            else if Status == 9
                            {
                                displayStatusText = "Error"
                                DispatchQueue.main.async {
                                    
                                    self.ActivityInd.stopAnimating()
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.StatusOut.text = displayStatusText
                                
                            }
                            
                        }
                        else
                        {
                        }
                        
                        if let isTempOn  = statusDictionary.value(forKey: "IsTemperatureControlEnabled") as? Bool
                        {
                            DispatchQueue.main.async {
                                self.isTempOn = isTempOn
                                
                            }
                        }
                        if let targetTemp  = statusDictionary.value(forKey: "TemperatureTarget_C") as? Double
                        {
                            DispatchQueue.main.async {
                                if targetTemp > 15
                                    
                                {
                                    self.FireImage.isHidden = false
                                    self.coolImage.isHidden = true
                                }
                                else
                                {
                                    self.FireImage.isHidden = true
                                    self.coolImage.isHidden = false
                                }
                                self.TempTarget.text = String(stringInterpolationSegment: targetTemp)
                            }
                        }
                        
                        if  let tempReal  = statusDictionary.value(forKey: "TemperatureCurrent_C") as? Double
                        {
                            DispatchQueue.main.async {
                                let formatedTemp =  NSString(format: "%.0f", tempReal)
                                let c = "°C"
                                
                                self.TemReal.text = (formatedTemp as String) + c
                            }
                        }
                        
                        if let currentQuickActions = statusDictionary.value(forKey: "QuickActionProcessIds") as? [String]
                        {
                            
                            for quickActionItem in currentQuickActions
                            {
                                
                                //StartUp
                                if quickActionItem == self.AvailableProcessIds.Startup
                                {
                                    DispatchQueue.main.async {
                                        self.StartUpButton.isHidden = false;
                                        self.ShutDownButton.isHidden = true;
                                    }
                                }
                                
                                //Shutdown
                                if quickActionItem ==  self.AvailableProcessIds.Shutdown
                                {
                                    DispatchQueue.main.async {
                                        self.StartUpButton.isHidden = true;
                                        self.ShutDownButton.isHidden = false;
                                    }
                                }
                            }
                            
                        }

                        if let usersArray = statusDictionary.value(forKey: "Users") as? NSArray
                        {
                            let users = usersArray[0] as! String
                            
                            DispatchQueue.main.async {
                                
                                self.Users.text = users
                            }
                        }
                        
                        if let firmwareVersion = statusDictionary.value(forKey: "FirmwareVersion") as? NSString
                        {
                            DispatchQueue.main.async {
                                self.FirmOut.text = firmwareVersion as String
                            }
                        }
                        
                        if let softwareVersion = statusDictionary.value(forKey: "SoftwareVersion") as? NSString
                        {
                            DispatchQueue.main.async {
                                self.SoftwareVout.text = softwareVersion as String
                                
                            }
                        }
                    }
                }
            }
                }
                catch
                {}
        }) 
        task.resume()
    }
    @IBAction func DoorAction(_ sender: AnyObject) {
        
        DoorButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 2.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 6.0,
                                   options: UIViewAnimationOptions.allowUserInteraction,
                                   animations: {
                                    self.DoorButton.transform = CGAffineTransform.identity
            }, completion: nil)

        EVONetworkCommunicationController.ProcessStartOptions(AvailableProcessIds.LoaderDoorToggle, options: "")
    }
    
    func FluidStatusAPICall()
    {
        let url = httpAPIPath + AvailableProcessIds.BulkFluids
        let requestUrl = URL(string: url);
        var request = URLRequest(url:requestUrl!);
        request.httpMethod = "GET";
        
        // Compose a query string
        let postString = "";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            do
            {
            if error != nil
            {
                self.HTTPErrorText = "error=\(error)"
                self.setVal()
                return
            }
             
            let rawJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
           
            let json = JSON(rawJSON!)
            
            if let details = json["Status"]["Details"].string{
                
                if let statusDetails: Data = details.data(using: String.Encoding.utf8)
                {
                    if let detailsDictionary = try JSONSerialization.jsonObject(with: statusDetails, options: []) as? NSDictionary
                    {
                        var d1: Float = 0.0;
                        var d2: Float = 0.0;
                        
                        if let DI_1 = detailsDictionary.value(forKey: "DIARatio") as? Float
                        {
                            d1 = DI_1
                        }
                        if  let DI_2 = detailsDictionary.value(forKey: "DIBRatio") as? Float
                        {
                            d2 = DI_2
                        }
                        if let timeLeft = detailsDictionary.value(forKey: "TimeRemainingSeconds") as? Double
                        {
                            
                            let timeLeft4 = timeLeft / 60.0
                            
                            if timeLeft4 >= 60.0
                            {
                                
                                let timeHours = timeLeft4 / 60.0
                                
                                DispatchQueue.main.async {
                                    
                                    self.FluidLevel.text =   String(format:"%.f", timeHours) + "h"
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    
                                    self.FluidLevel.text =   String(format:"%.f", timeLeft4) + "min"
                                }
                            }
                        }
                       
                        let realDI = (d1 + d2) / 2.0
                        DispatchQueue.main.async {
                            self.DI1.setProgress( realDI, animated: true)
                        }
                    }
                }
            }
                
            }
            catch
            {}
        }) 
        task.resume()
    }
    

    
    func ProcessStatusAPICall( _ proccessID:String )
    {
        let url = httpAPIPath + proccessID
        let requestUrl = URL(string: url);
        
        var request = URLRequest(url:requestUrl!);
        request.httpMethod = "GET";
        
        // Compose a query string
        let postString = "";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
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
        }) 
        task.resume()
    }
}
