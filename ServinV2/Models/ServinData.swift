//
//  Data.swift
//  ServinV2
//
//  Created by Developer on 2018-06-20.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class ServinData {
    
    static var me: ServinUser!
    static var arrayOfUsers: [ServinUser]!
    static var allPins = [Discovery]()
    
    init() {
        ServinData.me = ServinUser.init(firstName: "Larry", lastName: "Page", profilePicture: #imageLiteral(resourceName: "larry_avatar"), institution: "University Of Calgary", about: nil, cognitoId: nil)
        ServinData.me._pinsOnMap.append(Discovery.init(id: "dummyDiscovery", title: "Residential/Commercial/ New Construction/Repainting Services", description: "We are a well-established painting business specializing in both residential and commercial painting, new construction and repaints. We also run a shop with a spray booth. With over 3000 projects completed in Calgary in the last 17 years, we have the experience and manpower to complete any project in a timely manner at the highest standards. Feel free to contact us for a free quote. www.propaintingsolutions.com", price: 300, views: 32, location: CLLocationCoordinate2D.init(latitude: 51.078028, longitude: -114.075867), images: [#imageLiteral(resourceName: "painting1"), #imageLiteral(resourceName: "painting2"), #imageLiteral(resourceName: "painting3")], typeOfRequest: .offer, isSaved: false))
        
        ServinData.me._pinsOnMap.append(Discovery.init(id: "dummyDiscovery", title: "Looking to hire a math tutor!", description: "I am having trouble understanding MATH 30 and calculus, looking for someone that can help me with the squeeze theorem.", price: 90, views: 3, location: CLLocationCoordinate2D.init(latitude: 51.078028, longitude: -114.075867), images: [nil], typeOfRequest: .offer, isSaved: false))
        
        let andrea = ServinUser.init(firstName: "Adrianna", lastName: "Bennet", profilePicture: #imageLiteral(resourceName: "adriana"), institution: "University Of Calgary", about: nil, cognitoId: nil)
        
        andrea._pinsOnMap.append(
            Discovery.init(id: "dummyDiscovery", title: "CPSC 313 - Introduction to the Theory of Computation", description: "Selling Introduction to the Theory of Computation by Michael Sipser for CPSC 313. Second Edition. I found that the readings and practice problems we're very helpful for the exams and assignment. Selling for $30.", price: 30, views: 2, location: CLLocationCoordinate2D.init(latitude: 50.940857, longitude: -114.05504), images: [#imageLiteral(resourceName: "cpsc_313")], typeOfRequest: .offer, isSaved: false))
        
        
        andrea._pinsOnMap.append(
            Discovery.init(id: "dummyDiscovery", title: "Chemistry 30 key book", description: "Was slightly more used. All writing has been erased. Really helped for the diploma. *sometimes the practices questions in the book is used on unit tests. Easy way to get a questions right*", price: 20, views: 3, location: CLLocationCoordinate2D.init(latitude: 51.024608, longitude: -114.178694), images: [#imageLiteral(resourceName: "chem_book")], typeOfRequest: .offer, isSaved: true))
        
        andrea._pinsOnMap.append(Discovery.init(id: "dummyDiscovery", title: "WHOLE HOUSE CARPET & FURNACE DUCT CLEANING!!", description: "Includes Carpet cleaning of 4 rooms or 3 rooms and 1 set of stairs and Furnace cleaning of 1 Furnace with up to 12 vents (extra vents $7 each) We also offer unlimited vents Furnace cleaning for $150. Pls. call ‪(403)612-0407‬ or visit www.vacuumthingy.ca", price: 200, views: 33, location: CLLocationCoordinate2D.init(latitude: 51.118197, longitude: -113.933827), images: [#imageLiteral(resourceName: "duct_cleaning")], typeOfRequest: .offer, isSaved: true))
        
        
        let joshua = ServinUser.init(firstName: "Joshua", lastName: "Hickman", profilePicture: #imageLiteral(resourceName: "joshua"), institution: "University Of Alberta", about: nil, cognitoId: nil)
        
        joshua._pinsOnMap.append( Discovery.init(id: "dummyDiscovery", title: "Pressure Washing Service", description: "Offering commercial and residential pressure washing services. Charged hourly at $50/hr", price: 50, views: 19, location: CLLocationCoordinate2D.init(latitude: 51.078028, longitude: -114.075867), images: [#imageLiteral(resourceName: "pressure_washing")], typeOfRequest: .offer, isSaved: false))
        
        joshua._pinsOnMap.append( Discovery.init(id: "dummyDiscovery", title: "Residential/Commercial/ New Construction/Repainting Services", description: "We are a well-established painting business specializing in both residential and commercial painting, new construction and repaints. We also run a shop with a spray booth. With over 3000 projects completed in Calgary in the last 17 years, we have the experience and manpower to complete any project in a timely manner at the highest standards. Feel free to contact us for a free quote. www.propaintingsolutions.com", price: 300, views: 32, location: CLLocationCoordinate2D.init(latitude: 51.078028, longitude: -114.075867), images: [#imageLiteral(resourceName: "painting1"), #imageLiteral(resourceName: "painting2"), #imageLiteral(resourceName: "painting3")], typeOfRequest: .offer, isSaved: false))
        
        joshua._pinsOnMap.append( Discovery.init(id: "dummyDiscovery", title: "Looking for a proofreader!", description: "Hi I'm creating websites for some clients and I need someone who can double check the websites to make sure they don't have typos, grammar errors, or anything like that. I can pay you $25 per website cash. It'll be a quick job (a handful of clients right now) and I might need more done in the future maybe every week. Let me know if you can do it. Thank you", price: 300, views: 32, location: CLLocationCoordinate2D.init(latitude: 51.078028, longitude: -114.075867), images: [#imageLiteral(resourceName: "proofreader")], typeOfRequest: .request, isSaved: false))
        
        joshua._pinsOnMap.append( Discovery.init(id: "dummyDiscovery", title: "Need Someone Great At English", description: "Hi I need someone to do some writing for a project and I can pay you $100. Please contact me. Thanks.", price: 300, views: 32, location: CLLocationCoordinate2D.init(latitude: 51.078028, longitude: -114.075867), images: [], typeOfRequest: .request, isSaved: false))
        
        
        let erik = ServinUser.init(firstName: "Erik", lastName: "Kleinman", profilePicture: #imageLiteral(resourceName: "erik"), institution: "University Of Alberta", about: nil, cognitoId: nil)
        
        erik._pinsOnMap.append( Discovery.init(id: "dummyDiscovery", title: "University Students Wanted", description: "Looking for one or two University students to help this summer on light construction jobs throughout Calgary. Landscape construction or framing experience is a plus, reliability and flexibility are musts! Call Erik at 403-923-3745.", price: 50, views: 19, location: CLLocationCoordinate2D.init(latitude: 51.078028, longitude: -114.075867), images: [#imageLiteral(resourceName: "pressure_washing")], typeOfRequest: .request, isSaved: false))
        
        erik._pinsOnMap.append( Discovery.init(id: "dummyDiscovery", title: "Part Time Dance Instructor (Ballet)", description: "Ballet Classique Methusela is centrally located in Calgary, AB. We are currently seeking an R.A.D. certified teacher to begin teaching as of September 2018 for the 2018/19 season for grades 3 - Intermediate. Our season runs from September until June. Classes will be two or three nights a week. The position is a permanent part-time teaching opportunity. A two year ++ contract is preferable. Salary is negotiable and dependent upon experience. The students participate in 2 recitals/year. Preparation of recital choreography would be greatly appreciated. Our students have not yet participated in an RAD exams. However, we expect students to be fully prepared for examinations and to participate in exams when appropriate (hopefully this upcoming year!). Therefore, the Teacher must be qualified to enter the students into their exams, as well as do the administrative work to have them entered. The ability to teach any additional disciplines would be an asset. The ideal candidate is positive, responsible and enthusiastic with strong motivational and communication skills. Must be passionate about ballet and teaching. Experience is a must. If you are interested in this position please contact Sara-Lynne Dewar 403 245-4346 or email your resume to balletcalgary@telus.net. Do not reply to this ad. Please include your salary expectations. Thank you.. www.propaintingsolutions.com", price: 300, views: 32, location: CLLocationCoordinate2D.init(latitude: 51.078028, longitude: -114.075867), images: [#imageLiteral(resourceName: "ballet")], typeOfRequest: .offer, isSaved: false))
        
        
        ServinData.arrayOfUsers = [ServinUser]()
        ServinData.arrayOfUsers.append(andrea)
        ServinData.arrayOfUsers.append(joshua)
        ServinData.arrayOfUsers.append(erik)
        
        for user in ServinData.arrayOfUsers {
            for pin in user._pinsOnMap {
                if pin != nil {
                    ServinData.allPins.append(pin!)
                }
            }
        }
        
    
    }
    
}
