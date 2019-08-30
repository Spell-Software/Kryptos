//
//  SSKryptosDescrambler.swift
//  Kryptos
//
//  Created by Craig Spell on 1/2/17.
//  Copyright © 2017 Spell Software Inc. All rights reserved.
//

import Foundation


class SSKryptosDescambler {

    //MARK: Constants
    let wordBase = SSKryptosWordDataBase.init().englishWordSetsByLength
    let wordSet = SSKryptosWordDataBase.init().englishWordsSet

    //MARK: Variables
    var textConverter : SSKryptosText
    var lettersEvaluated : Int
    var maxWordLength = 0
    var wordsFound = 0.0
    var totalWordLengths = 0.0
    
    //MARK: Calculated Properties
    var averageWordLength : Double {
        return totalWordLengths / wordsFound
    }

    //MARK: Initializers
    init(withTextConverter txtconverter: SSKryptosText) {

        self.textConverter = txtconverter
        self.lettersEvaluated = 0

        for word in wordBase.keys {
            if word > maxWordLength {
                maxWordLength = word
            }
        }
    }

    //MARK: Instance Functions
    func findWords() -> String {

        var textToEval = NSString.init(string: textConverter.text)
        var evaluatedText = ""
        var longestWord : NSString?
        self.wordsFound = 0
        self.totalWordLengths = 0

        while textToEval.length > 0 {

            for word in wordSet {


                if (textToEval.length >= word.length) && (textToEval.substring(to: word.length ).isEqual( word )) {

                    longestWord = word

                    for longerWord in wordSet {

                        if (longerWord.length > word.length) && (longerWord.contains(word as String)) && (textToEval.length >= longerWord.length){

                            if textToEval.substring(to: longerWord.length).isEqual(longerWord) {
                                longestWord = longerWord
                            }
                        }
                    }
                }
            }

            if let longerWord = longestWord {
                evaluatedText.append("\(longerWord) ")
                textToEval = textToEval.substring(from: longerWord.length) as NSString
                longestWord = nil

            }else{

                let unresolvedLetter = textToEval.substring(to: 1) as NSString
                evaluatedText.append("\(unresolvedLetter)")
                textToEval = textToEval.substring(from: 1) as NSString
            }

        }
        print(evaluatedText)
        return evaluatedText
    }

    func findWordsSeparatedWithSpaces() -> String {

        var textToEvaluate = NSString.init(string: textConverter.text)
        var evaluatedText = ""
        let reverseOrder = self.wordBase.keys.sorted { return $0 > $1 }
        self.wordsFound = 0.0
        self.totalWordLengths = 0.0

        while textToEvaluate.length > 1 {

            var stop = (maxWordLength < textToEvaluate.length) ? textToEvaluate.length : maxWordLength

            var foundText : String? = nil

            for idx in reverseOrder {

                if (foundText == nil) && (idx <= stop) && (textToEvaluate.length >= idx) {

                    let word = textToEvaluate.substring(to: idx)

                    if (self.wordBase[idx]?.contains(word as NSString))! {

                        foundText = " \(word)"
                        self.wordsFound += 1
                        self.totalWordLengths += Double(idx)
                        print(self.averageWordLength)
                    }
                }
                
                if let newText = foundText {

                    evaluatedText.append(newText)
                    textToEvaluate = textToEvaluate.substring(from: idx) as NSString
                }else{

                    if stop != 1 {

                        if textToEvaluate.length > 0 {

                            let unrecognizedLetter = textToEvaluate.substring(to: 1) as NSString

                            evaluatedText.append(" \(unrecognizedLetter)")
                            textToEvaluate = textToEvaluate.substring(from: 1) as NSString
                        }
                    }else{
                        stop -= 1
                    }
                }
            }
        }
        return evaluatedText
    }
}
