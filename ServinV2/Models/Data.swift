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


class Data {
    
    static var me: User!
    static var arrayOfUsers: [User]!
    init() {
        Data.me = User.init(firstName: "Larry", lastName: "Page", profilePicture: #imageLiteral(resourceName: "larry_avatar"), institution: "University Of Calgary")
        Data.me._pinsOnMap.append(Pin.init(title: "Residential/Commercial/ New Construction/Repainting Services", description: "We are a well-established painting business specializing in both residential and commercial painting, new construction and repaints. We also run a shop with a spray booth. With over 3000 projects completed in Calgary in the last 17 years, we have the experience and manpower to complete any project in a timely manner at the highest standards. Feel free to contact us for a free quote. www.propaintingsolutions.com", price: 300, views: 32, location: CLLocationCoordinate2D.init(latitude: 51.078028, longitude: -114.075867), images: [#imageLiteral(resourceName: "painting1"), #imageLiteral(resourceName: "painting2"), #imageLiteral(resourceName: "painting3")], typeOfRequest: .offer))
        
        Data.me._pinsOnMap.append(Pin.init(title: "Looking to hire a math tutor!", description: "I am having trouble understanding MATH 30 and calculus, looking for someone that can help me with the squeeze theorem.", price: 90, views: 3, location: CLLocationCoordinate2D.init(latitude: 51.078028, longitude: -114.075867), images: [nil], typeOfRequest: .offer))
        
        let andrea = User.init(firstName: "Adrianna", lastName: "Bennet", profilePicture: #imageLiteral(resourceName: "adriana"), institution: "Universoty Of Calgary")
        
        andrea._pinsOnMap.append(
            Pin.init(title: "CPSC 313 - Introduction to the Theory of Computation", description: "Selling Introduction to the Theory of Computation by Michael Sipser for CPSC 313. Second Edition. I found that the readings and practice problems we're very helpful for the exams and assignment. Selling for $30.", price: 30, views: 2, location: CLLocationCoordinate2D.init(latitude: 50.940857, longitude: -114.05504), images: [#imageLiteral(resourceName: "cpsc_313")], typeOfRequest: .offer))
        
        
        andrea._pinsOnMap.append(
            Pin.init(title: "Chemistry 30 key book", description: "Was slightly more used. All writing has been erased. Really helped for the diploma. *sometimes the practices questions in the book is used on unit tests. Easy way to get a questions right*", price: 20, views: 3, location: CLLocationCoordinate2D.init(latitude: 51.024608, longitude: -114.178694), images: [#imageLiteral(resourceName: "chem_book")], typeOfRequest: .offer))
        
        andrea._pinsOnMap.append(Pin.init(title: "WHOLE HOUSE CARPET & FURNACE DUCT CLEANING!!", description: "Includes Carpet cleaning of 4 rooms or 3 rooms and 1 set of stairs and Furnace cleaning of 1 Furnace with up to 12 vents (extra vents $7 each) We also offer unlimited vents Furnace cleaning for $150. Pls. call ‪(403)612-0407‬ or visit www.vacuumthingy.ca", price: 200, views: 33, location: CLLocationCoordinate2D.init(latitude: 51.118197, longitude: -113.933827), images: [#imageLiteral(resourceName: "duct_cleaning")], typeOfRequest: .offer))
        
        
        
        let joshua = User.init(firstName: "Joshua", lastName: "Hickman", profilePicture: #imageLiteral(resourceName: "joshua"), institution: "University Of Alberta")
        
        joshua._pinsOnMap.append( Pin.init(title: "Pressure Washing Service", description: "Offering commercial and residential pressure washing services. Charged hourly at $50/hr", price: 50, views: 19, location: CLLocationCoordinate2D.init(latitude: 51.078028, longitude: -114.075867), images: [#imageLiteral(resourceName: "pressure_washing")], typeOfRequest: .offer))
        
        joshua._pinsOnMap.append( Pin.init(title: "Residential/Commercial/ New Construction/Repainting Services", description: "We are a well-established painting business specializing in both residential and commercial painting, new construction and repaints. We also run a shop with a spray booth. With over 3000 projects completed in Calgary in the last 17 years, we have the experience and manpower to complete any project in a timely manner at the highest standards. Feel free to contact us for a free quote. www.propaintingsolutions.com", price: 300, views: 32, location: CLLocationCoordinate2D.init(latitude: 51.078028, longitude: -114.075867), images: [#imageLiteral(resourceName: "painting1"), #imageLiteral(resourceName: "painting2"), #imageLiteral(resourceName: "painting3")], typeOfRequest: .offer))
    
        
    
    }
    
}
