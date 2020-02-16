//
//  Location+CoreDataClass.swift
//  Locations App
//
//  Created by Kevin Li on 1/28/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Visit)
public class Visit: NSManagedObject {
    // MARK: - Class Functions
    class func count() -> Int {
        let fetchRequest: NSFetchRequest<Visit> = Visit.fetchRequest()
        
        do {
            let count = try CoreData.stack.context.count(for: fetchRequest)
            return count
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    class func newVisit() -> Visit {
        Visit(context: CoreData.stack.context)
    }
    
    class func create(arrivalDate: Date, departureDate: Date) -> Visit {
        let visit = newVisit()
        visit.arrivalDate = arrivalDate
        visit.departureDate = departureDate
        CoreData.stack.save()
        
        return visit
    }
    
    // MARK: - Local Functions
    func addNotes(_ notes: String) {
        self.notes = notes
        CoreData.stack.save()
    }

    @discardableResult
    func favorite() -> Bool{
        self.isFavorite.toggle()
        CoreData.stack.save()
        return self.isFavorite
    }
    
    func delete() -> Visit {
        let visit = self
        CoreData.stack.context.delete(self)
        return visit
    }
    
    // MARK: - Computed Properties
    var visitDuration: String {
        self.arrivalDate.timeOnlyWithPadding + " ➝ " + self.departureDate.timeOnlyWithPadding
    }

    var tagColor: UIColor {
        self.location.tag.uiColor
    }
}

extension Visit {
    // MARK: - Preview
    class var preview: Visit {
        let visit = newVisit()
        visit.location.latitude = 12.9716
        visit.location.longitude = 77.5946
        visit.arrivalDate = Date.random(range: 1000)
        visit.departureDate = Date().addingTimeInterval(.random(in: 100...2000))
        visit.location.address = "1 Infinite Loop, Cupertino, California"
        visit.notes = "Had a great time visiting my friend, who works here. The food is amazing and the pay seems great."
        visit.location.name = "Apple INC"
        visit.isFavorite = true
        visit.location.tag = Tag.create(name: "Visit", color: .charcoal)
        CoreData.stack.save()
        return visit
    }
    
    class var previewVisits: [Visit] {
        var visits = [Visit]()
        for _ in 0..<10 {
            let date = Date.random(range: 100)
            for _ in 0..<10 {
                let visit = preview
                visit.arrivalDate = date
                visits.append(visit)
            }
        }
        return visits
    }
    
    class var previewVisitDetails: [Visit] {
        var visits = [Visit]()
        let date = Date.random(range: 100)
        for _ in 0..<5 {
            let visit = preview
            visit.arrivalDate = date
            visits.append(visit)
        }
        return visits
    }
}
