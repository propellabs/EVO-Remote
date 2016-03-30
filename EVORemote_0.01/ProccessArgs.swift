//
//  ProccessArgs.swift
//  EVORemote_0.01
//
//  Created by Reed Miller on 6/12/15.
//  Copyright (c) 2015 com.RMTEK. All rights reserved.
//

import Foundation


public class ProcessArg:Serializable {
    var ProcessId: String = ""
    var Options: String = ""
    
    init(ProcessId: String, Options: String) {
        self.ProcessId = ProcessId
        self.Options = Options
    }
    
  
}