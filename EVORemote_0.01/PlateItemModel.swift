//
//  PlateItemModel.swift
//  collectionsTest
//
//  Created by Reed Miller on 6/11/15.
//  Copyright (c) 2015 com.RMTEK. All rights reserved.
//

import Foundation

open class PlateItemModel{
    
    var Lable:String = ""
    var Name:String = ""
    var Status:Int = 0
    var HitTest:Double = 0.0
    
    
    
    public init (Lable: String, Name: String, Status: Int) {
        self.Lable = Lable
        self.Name = Name
        self.Status = Status
    }
    
    }
