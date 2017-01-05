//
//  ProccessArgs.swift
//  EVORemote_0.01
//
//  Created by Reed Miller on 6/12/15.
//  Copyright (c) 2015 com.RMTEK. All rights reserved.
//

import Foundation


open class ProcessArg {
    var ProcessId: String = ""
    var Options: String = ""
    
    init(ProcessId: String, Options: String) {
        self.ProcessId = ProcessId
        self.Options = Options
    }
    
  
}
