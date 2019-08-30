//
//  KryptosAlphabetUtilities.swift
//  Kryptos
//
//  Created by Craig Spell on 7/14/17.
//  Copyright © 2017 Spell Software Inc. All rights reserved.
//

import Foundation
import CoreData

let KryptosAlphabetEntityString = "KryptosAlphabet"

extension KryptosAlphabet {


    static func alphabetWith(_ sSAlphabet: SSKryptosEncryptionAlphabet, inManagedObjectContext context:NSManagedObjectContext)  -> KryptosAlphabet? {

        let request : NSFetchRequest = self.fetchRequest()
        request.predicate = NSPredicate.init(format: "uniqueOrder == %@", sSAlphabet.unique)

        if let existingAlphabet = ( try? context.fetch(request) ) {

            return existingAlphabet.first
        }else{

            if let newAlphabet = NSEntityDescription.insertNewObject(forEntityName: KryptosAlphabetEntityString, into: context) as? KryptosAlphabet {


                newAlphabet.name                 = sSAlphabet.name
                newAlphabet.origin               = sSAlphabet.alphabetOrigin.rawValue
                newAlphabet.characters           = sSAlphabet.unique
                newAlphabet.uniqueOrder          = sSAlphabet.unique
                newAlphabet.invertAlphabet       = sSAlphabet.invertAlphabet

                //alphabet values
                newAlphabet.letterValues         = sSAlphabet.internalAlphabetValues.alphabet as NSObject
                newAlphabet.letterReturn         = sSAlphabet.internalAlphabetValues.letterReturn as NSObject
                newAlphabet.invertedLetterValues = sSAlphabet.internalAlphabetValues.invertedAlphabet as NSObject
                newAlphabet.invertedLetterReturn = sSAlphabet.internalAlphabetValues.invertedLetterReturn as NSObject

                return newAlphabet
            }
        }
        return nil
    }
    
}
