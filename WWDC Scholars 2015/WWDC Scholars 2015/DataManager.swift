//
//  DataManager.swift
//  WWDC Scholars 2015
//
//  Created by Matthijs Logemann on 21-05-15.
//  Copyright (c) 2015 WWDC-Scholars. All rights reserved.
//

import Parse
import Bolts

class DataManager: NSObject {
    
    var scholarArray : [Scholar] = []
    
    class var sharedInstance: DataManager {
        struct Static {
            static let instance: DataManager = DataManager()
        }
        return Static.instance
    }
    
    func loadStudents(){
        var query = PFQuery(className:"scholars")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.scholarArray.removeAll(keepCapacity: false)
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scholars.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        if (object.objectForKey("firstName")  == nil) || (object.objectForKey("lastName")  == nil)||(object.objectForKey("longtitude")  == nil)||(object.objectForKey("latitude")  == nil) {
                            continue
                        }
                        
                        
                        
                        let screenshots = NSMutableArray()
                        if let screenshotOne = object.objectForKey("screenshotOne") as? PFFile{
                            screenshots.addObject(screenshotOne.url!)
                        }
                        if let screenshotTwo = object.objectForKey("screenshotTwo") as? PFFile{
                            screenshots.addObject(screenshotTwo.url!)
                        }
                        if let screenshotThree = object.objectForKey("screenshotThree") as? PFFile{
                            screenshots.addObject(screenshotThree.url!)
                        }
                        if let screenshotFour = object.objectForKey("screenshotFour") as? PFFile{
                            screenshots.addObject(screenshotFour.url!)
                        }
                        
                       
                        //prevent crashes
                        let obj = object.objectForKey("user") as? PFUser
                        obj?.fetchIfNeededInBackground()
                        
                        var scholar = Scholar(
                            
                            name: NSString(format: "%@ %@", object.objectForKey("firstName") as! String, object.objectForKey("lastName") as! String) as String,
                            firstName: object.objectForKey("firstName") as? String,
                            age: object.objectForKey("age") as! Int,
                            birthdate: object.objectForKey("birthday") as? NSDate,
                            gender: object.objectForKey("gender") as? String,
                            latitude: (object.objectForKey("latitude") as? Double)!,
                            longitude: (object.objectForKey("longtitude") as? Double)!,
                            email: object.objectForKey("email") as? String,
                            picture: (object.objectForKey("profilePic") as! PFFile).url!,
                            appScreenshots:(screenshots as NSArray) as? [String],
                            shortBio: object.objectForKey("shortBio") as? String,
                            numberOfWWDCAttend: object.objectForKey("numberOfTimesWWDCScholar") as? Int,
                            appDemo: object.objectForKey("videoLink") as? String,
                            githubLinkToApp: object.objectForKey("githubLinkApp") as? String,
                            twitter: object.objectForKey("twitter") as? String,
                            facebook: object.objectForKey("facebook") as? String,
                            github: object.objectForKey("github") as? String,
                            linkedIn: object.objectForKey("linkedin") as? String,
                            website: object.objectForKey("website") as? String,
                            location:object.objectForKey("location") as? String,
                            user: obj,
                            itunes:object.objectForKey("itunes") as? String,
                            smallPicture:(object.objectForKey("smallPicture") as! PFFile).url)
                        
                        
                            self.scholarArray.append(scholar)
                            //println(scholar.smallPicture)
                    }
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("onScholarsLoadedNotification", object: self)
                    println("The length of ScholarArray is \(self.scholarArray.count).")
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
    }
    
    func scholarAtLocation(pos: Int) -> Scholar?{
        return scholarArray[pos]
    }
    
    func getScholarByName(name:String) ->Scholar?{
        
        let result = self.scholarArray.filter({
            $0.name == name
        })
        return result[0]
    }
    
}
