//
//  InspectionFormCategory.swift
//  StoneBride Well Inspection
//
//  Created by Tyler Ipema on 11/22/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import Foundation

public class InspectionFormCategory: NSObject, NSCoding
{
    public var inspectionFormCategory: [inspectionSubView] = []
    
    enum Key:String
    {
        case inspectionFormCategory = "inspectionFormCategory"
    }
    
    init(inspectionFormCategories: [inspectionSubView])
    {
        self.inspectionFormCategory = inspectionFormCategories
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(inspectionFormCategory, forKey: Key.inspectionFormCategory.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder)
    {
        let myInspectionCategories = aDecoder.decodeObject(forKey: Key.inspectionFormCategory.rawValue) as! [inspectionSubView]
        
        self.init(inspectionFormCategories: myInspectionCategories)
    }
}

public class inspectionSubView: NSObject, NSCoding
{
    public var tag:Int = 0
    public var inspectionComment : String = ""
    public var inspectionYNField : String = ""
    public var hasPictures : Bool = false
    
    enum Key:String
    {
        case tag = "tag"
        case inspectionComment = "inspectionComment"
        case inspectionYNField = "inspectionYNField"
        case hasPictures = "hasPictures"
    }
    
    init(t:Int, inspectComm:String, inspectYN:String, hasPic:Bool)
    {
        self.tag = t
        self.inspectionComment = inspectComm
        self.inspectionYNField = inspectYN
        self.hasPictures = hasPic
    }
    
    public override init()
    {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(tag, forKey: Key.tag.rawValue)
        aCoder.encode(inspectionComment, forKey: Key.inspectionComment.rawValue)
        aCoder.encode(inspectionYNField, forKey: Key.inspectionYNField.rawValue)
        aCoder.encode(hasPictures, forKey: Key.hasPictures.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder)
    {
        let inspectTag = aDecoder.decodeObject(forKey: Key.tag.rawValue) as! Int
        let inspectionComment = aDecoder.decodeObject(forKey: Key.inspectionComment.rawValue) as! String
        let inspectionYN = aDecoder.decodeObject(forKey: Key.inspectionYNField.rawValue) as! String
        let hPics = aDecoder.decodeObject(forKey: Key.hasPictures.rawValue) as! Bool
        
        self.init(t: inspectTag, inspectComm: inspectionComment, inspectYN: inspectionYN, hasPic: hPics)
    }
}


