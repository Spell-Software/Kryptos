//
//  LetterSubstitution.swift
//  Kryptos
//
//  Created by Craig Spell on 7/15/17.
//  Copyright © 2017 Spell Software Inc. All rights reserved.
//

import Foundation


let original = "dohnlsrheocpteoibidyshnaia"
let sub =      "ghijlmnquvwxzkryptosabcdef"

func buildSubDictFrom(stringOrigin str1: String, andSub str2: String) -> [String : String] {
    var retDict = [String : String]()

    let str2Array = str2.letterArray()

    var idx = 0

    for letter in str1.letterArray() {

        retDict[ letter ] = str2Array[ idx ]
        idx += 1
    }
    return retDict
}
let k4Theory = buildSubDictFrom(stringOrigin: original, andSub: sub)


func substituteLetterIn(string:String, usingDictionary dict: [String : String]) -> String {

    var returnString = ""

    let letterArray = string.letterArray()

    for letter in letterArray {
        returnString.append(letter.lowercased())
    }
    return returnString
}



