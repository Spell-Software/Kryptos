//
//  SSKryptosWordDataBase.swift
//  Kryptos
//
//  Created by Craig Spell on 12/16/16.
//  Copyright © 2016 Spell Software Inc. All rights reserved.
//

import Foundation

final class SSKryptosWordDataBase {

    var applicationDocumentsDirectory : URL {

        get{

            return  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
    }

    var englishWordsArray : [String]
    var englishWordsSet : Set<NSString>
    var englishWordSetsByLength : [Int : Set<NSString>]
    

    // MARK: NSCoding and Initializers
//    func encode(with aCoder: NSCoder) {
//
//
//    }
//
//    required convenience init?(coder aDecoder: NSCoder) {
//
//        self.init()
//    }

    init() {

        englishWordsArray = SSKryptosWordDataBase.englishWords()
        englishWordsSet = Set.init(englishWordsArray.map({return NSString.init(string: $0)}))

        englishWordSetsByLength = SSKryptosWordDataBase.returnEnglishWordLengthsToSets(plistDictionary: SSKryptosWordDataBase.englishWordSetsSortedByLength() as NSDictionary)
    }

    private class func returnEnglishWordLengthsToSets(plistDictionary: NSDictionary) -> [Int : Set<NSString>]{

        var correctedValues = [Int : Set<NSString>]()

        let keys = plistDictionary.allKeys.map({ return $0 as! NSString })

        for idx in keys {

            let mutableArray : NSArray = plistDictionary[ idx ] as! NSArray
            let valueArray : [NSString] =  Array.init(mutableArray) as! [NSString]
            let actualValue = Int.init(idx as String)
            
            correctedValues[actualValue!] = Set.init(valueArray) as Set<NSString>?
        }

        return correctedValues
    }

    class func longestWordLength(inStringSet strSet: Set< NSString >) -> Int{
        
        var maxLength = 0
        
        for word in strSet{
            if word.length > maxLength{
                maxLength = word.length
            }
        }
        return maxLength
    }

    private class func englishWordSetsSortedByLength() -> [NSString : NSMutableArray] {

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let storedPlistURL = documentsDirectory.appendingPathComponent("englishWordSetsSortedBySize.plist")
//        var storedValues = [NSString : NSMutableArray]()

        if let storedValues = NSDictionary.init(contentsOf: storedPlistURL) as? [NSString : NSMutableArray]  {
            return storedValues
        }else{

            if let bunUrl = Bundle.main.url(forResource: "englishWordSetsSortedBySize", withExtension: ".plist"){

                try! FileManager.default.copyItem(at: bunUrl, to: storedPlistURL)

                return NSDictionary.init(contentsOf: storedPlistURL) as! [NSString : NSMutableArray]

            }
        }

        print(storedPlistURL)

        let englishWordsArray = SSKryptosWordDataBase.englishWords()
        let englishWordSet : Set< NSString > = Set.init(englishWordsArray.map({ return NSString.init(string: $0) }))
        let longestWordLength = SSKryptosWordDataBase.longestWordLength(inStringSet: englishWordSet)

        //the length is the key to index the words of that length
        var wordSetsSeparatedByLength = [NSString : NSMutableArray]()

        for length in 0..<longestWordLength {

            let stringRepresentation = "\(length + 1)" as NSString
            wordSetsSeparatedByLength[stringRepresentation] = NSMutableArray.init()

            for word in englishWordSet{
                
                if word.length == length + 1 {
                
                    if !(wordSetsSeparatedByLength[stringRepresentation]?.contains(word))! {

                        wordSetsSeparatedByLength[stringRepresentation]?.add(word)
                    }
                }
            }
        }

        NSDictionary.init(dictionary: wordSetsSeparatedByLength).write(to: storedPlistURL,
                                                                       atomically: true)
        return wordSetsSeparatedByLength
    }
    private class func englishWords() -> [String] {

        var results = NSMutableArray.init()

        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("kryptosWords")
        //        print(fileURL)

        if !FileManager.default.fileExists(atPath: fileURL.path){
            
            if let url = Bundle.main.url(forResource: "kryptosWords", withExtension: nil) {
                
               try! FileManager.default.copyItem(at: url, to: fileURL)
                if let file = NSMutableArray.init(contentsOf: fileURL) {
                    
                    results = file
                    results.write(to: fileURL, atomically: true)
                }
//            }else{
//
//                let url = Bundle.main.url(forResource: "allWords", withExtension: nil)!
//                let words = try! String.init(contentsOf: url, encoding: .utf8)
//
//                let scanner = Scanner.init(string: words)
//                var str : NSString?
//
//                while !scanner.isAtEnd {
//
//                    scanner.scanUpTo("\n", into:&str)
//
//                    if str != nil{
//
//                        let a = str! as String
//
//                        if !a.contains("-") {
//                            results.add(a.lowercased())
//                        }
//                    }
//                }
//                print(results.count)
//
//                results.write(to: fileURL, atomically: true)
            }
        }else{
            
            results = NSMutableArray.init(contentsOf: fileURL)!
        }
        
        print(fileURL)
        return results.copy() as! Array
    }
}
