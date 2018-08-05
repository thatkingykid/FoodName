//
//  Meal.swift
//  FoodName
//
//  Created by james king on 15/06/2018.
//  Copyright © 2018 james king. All rights reserved.
//

import UIKit
import os.log
class Meal: NSObject, NSCoding {
    var mName: String
    var mImage: UIImage?
    var mRating: Int
    struct KeyStrings {
        static let NAME = "name"
        static let IMAGE = "image"
        static let RATING = "rating"
    }
    static let DIRECTORY = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ARCHIVE = DIRECTORY.appendingPathComponent("meals")
    
    init?(inName: String, inImage: UIImage?, inRating: Int){
        if(inName.isEmpty || inRating < 0 || inRating > 4){
            return nil
        }
        self.mName = inName
        self.mImage = inImage
        self.mRating = inRating
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: KeyStrings.NAME) as? String else{
            os_log("Name not a string")
            return nil
        }
        let image = aDecoder.decodeObject(forKey: KeyStrings.IMAGE) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: KeyStrings.RATING)
        self.init(inName: name, inImage: image, inRating: rating)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(mName, forKey: KeyStrings.NAME)
        aCoder.encode(mImage, forKey: KeyStrings.IMAGE)
        aCoder.encode(mRating, forKey: KeyStrings.RATING)
    }
}
