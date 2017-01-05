//
//  NetworkCommunicationController.swift
//  EVO
//
//  Created by Reed Miller on 3/31/16.
//  Copyright © 2016 com.RMTEK. All rights reserved.
//

import Foundation


open class NetworkCommunicationController
{

    var IP = "";
    var HTTPErrorText = ""
    
    
    init(IP: String) {
        self.IP = IP
      
    }
   
    
    
    func ProcessStartOptions(_ processId:String, options:String )
    {
        let urlToMod = "http://" + IP + ":9001/api/processstart/"
        
        let myUrl = URL(string: urlToMod);
        
        var request = URLRequest(url:myUrl!);
        request.httpMethod = "POST";
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //This Will set the message
        
        
        let thingTosay = ProcessArg(ProcessId: processId, Options: options)
        
        
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(thingTosay.ProcessId, forKey: "ProcessId")
        para.setValue(thingTosay.Options, forKey: "Options")
    
        let jsonData = try! JSONSerialization.data(withJSONObject: para, options: [])
        let postString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
       // print(jsonString)
        
        
        //let postString = thingTosay.toJsonString()
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            do
            {
                
                if error != nil
                {
                    //  println("error=\(error)")
                    self.HTTPErrorText = "error=\(error)"
                  //  self.setVal()
                    return
                }
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString)")
                
                //            var err: NSError?
                //            var myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            }
            //            catch
            //            {}
        }) 
        task.resume()
    }
    
    
    
    
    
    func StopProcess(_ processID:String)
    {
        
        let urlToMod = "http://" + IP + ":9001/api/processstop/"
        
        let myUrl = URL(string: urlToMod);
        
        var request = URLRequest(url:myUrl!);
        request.httpMethod = "POST";
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let processArgs = ProcessArg(ProcessId: processID, Options: "")
       // let postString = processArgs.toJsonString()
        
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(processArgs.ProcessId, forKey: "ProcessId")
        para.setValue(processArgs.Options, forKey: "Options")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: para, options: [])
        let postString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
        
        
        request.httpBody = postString.data(using: String.Encoding.utf8);

        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {  data, response, error in
            do
            {
                
                if error != nil
                {
                    self.HTTPErrorText = "error=\(error)"
                    //self.setVal()
                    return
                }
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString)")
                
                //            var err: NSError?
                //            var myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                //
                
            }
            //            catch
            //        {}
        }) 
        task.resume()
    }
    
    
    
}
