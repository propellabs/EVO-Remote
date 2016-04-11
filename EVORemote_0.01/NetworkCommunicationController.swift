//
//  NetworkCommunicationController.swift
//  EVO
//
//  Created by Reed Miller on 3/31/16.
//  Copyright © 2016 com.RMTEK. All rights reserved.
//

import Foundation


public class NetworkCommunicationController
{

    var IP = "";
    var HTTPErrorText = ""
    
    
    init(IP: String) {
        self.IP = IP
      
    }
   
    
    
    func ProcessStartOptions(processId:String, options:String )
    {
        let urlToMod = "http://" + IP + ":9001/api/processstart/"
        
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
                  //  self.setVal()
                    return
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                
                //            var err: NSError?
                //            var myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            }
            //            catch
            //            {}
        }
        task.resume()
    }
    
    
    
    
    
    func StopProcess(processID:String)
    {
        
        let urlToMod = "http://" + IP + ":9001/api/processstop/"
        
        let myUrl = NSURL(string: urlToMod);
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let processArgs = ProcessArg(ProcessId: processID, Options: "")
        let postString = processArgs.toJsonString()
        
        request.HTTPBody = postString!.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            
            
            
            
            data, response, error in
            do
            {
                
                if error != nil
                {
                    self.HTTPErrorText = "error=\(error)"
                    //self.setVal()
                    return
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                
                //            var err: NSError?
                //            var myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                //
                
            }
            //            catch
            //        {}
        }
        task.resume()
    }
    
    
    
}