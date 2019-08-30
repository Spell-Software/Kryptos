//
//  SSKryptosText.swift
//  Kryptos
//
//  Created by Craig Spell on 12/28/16.
//  Copyright © 2016 Spell Software Inc. All rights reserved.
//

import Foundation

/// A class representing a numerical / alphabetical / symbolic map whose main purpose is to allow easy calling of an addable/subtractable representation of any string in relation to an SSKryptosEncryptionAlphabet.
class SSKryptosText {

    ///The Kryptos vigenere style alphabet used to get and set values of text based on letter positions within the alphabet.
    var alphabet : SSKryptosEncryptionAlphabet

    /// If we try to keep the unused characters it will alter the cryption process
    /// for instance "between subtle" would be encrypted as "betweensubtle" as in with the scupture
    /// thus with "palimpsest" the s in subtle will encode with 's' instead of 'e' in palimpsest.
    /// Set this property to true to try and save spacing or dis-allowed characters.
    var attemptToKeepUnusableCharacters : Bool = true


    //If we are going to try reinserting unused characters we need to keep track of the character and the placement
    //we do so by finding it's location and setting that as the key the value is of course the character

    ///A variable used to keep track of disallowed characters and their positions in the given text.
    ///The placement in the text is used as the key and the character is stored as the value.
    ///Thus if a space is not allowed, in the text "hello world" the dictionary would contain [6 : " "].
    ///These values must be reinstered in order otherwise the results can be undefined and may cause a fatal exception.
    internal var unusableCharacters = [Int : String]()


    /// The unused character return block allows a user to set a block of code to attempt recovery of the characters not included in the origin alphabet.
    ///We can do interesting things just by setting up a block to call upon completion where we can insert the character or do something else with them
    ///* * * * *
    ///
    /**
     - unusableCharacters: A dictionary containing the characters as values and the placement of those characters as the key

     - placementOrder: The unusableCharacters.keys sorted from least to greatest. If you insert the characters out of order the results are undefined and may crash
     */
    /// * * * * *
    /**
     An example of a simple recovery block that just reinserts characters that werent used

     self.unusedCharacterReturnBlock = ({(characters, place) in

     var text = self.text.characters.map({return String( $0 )})

     for idx in place{

     text.insert(characters[idx]!, at: idx)
     }

     self.text = text.joined()
     })
     */
    var unusedCharacterReturnBlock : ((_ unusableCharacters : [Int : String], _ placementOrder: [Int] ) -> Void)?

    var text : String{

        get{
            //simply getting or setting our text from strings
            //if we build a text converter using the value array we set text to nil and process a new text string when we request it through our getter
            if _text == nil {
                _text = self.decodeValueForText()
            }
            return _text
        }

        set{
            // if we change the value of text we set the value array to nil
            // now if we try to access it we will lazily instantiate a new value for the value array
            _value = nil
            _text = newValue
        }
    }
    //private property used for storage of self.text
    //we use a backing object in order to perform lazy instantiation
    private var _text : String!

    var value : [Int] {

        get{
            //simply getting or seting the value based on alphabet values
            //if we build a text converter using text we set value to nil and process a new value when we request it through our getter
            if (_value == nil){
                _value = self.createValueForText()
            }
            return _value
        }

        set{
            // if we change the value array we set the text string to nil
            // now if we try to access it we will lazily instantiate a new string for the text property
            _text = nil
            _value = newValue
        }
    }
    //private property used for storage of self.value
    //we use a backing object in order to perform lazy instantiation
    private var _value : [Int]!

    ///
    /// - Parameters:
    ///   - withText: A String that can be evaluated and converted to produce a numerical value representating the characters included.
    ///   - andAlphabet: An SSKryptosEncryptionAlphabet that will be used for value conversion between numerical and string representations.

    /// - Returns: A newly initialized SSKryptosText object.

    init(withText: String, forAlphabet: SSKryptosEncryptionAlphabet) {

        self.alphabet = forAlphabet //simple set for our alphabet address
        self.text = withText //calling the setter in case we make changes later we could simply set the storage object directly but we may want to add something to the setter one day..
        //        _value = self.createTextValue() //this doesn't need to happen unless we call the getter
    }

    ///
    /// - Parameters:
    ///   - withValue: An array of Int that can be evaluated as a numerical value and converted to a string representation.
    ///   - andAlphabet: An SSKryptosEncryptionAlphabet that will be used for value conversion between numerical and string representations.

    /// - Returns: A newly initialized SSKryptosText object.

    init(withValue: [Int], andAlphabet: SSKryptosEncryptionAlphabet) {

        self.alphabet = andAlphabet //simple set for our alphabet address
        self.value = withValue //calling the setter in case we make changes later we could simply set the storage object directly but we may want to add something to the setter one day..
        //        _text = self.decodeTextForValue() //this doesn't need to happen unless we call the getter
    }

    ///Returns an array of integers each of which represents the value of one letter from the text as designated by the alphabets order.
    private func createValueForText() -> [Int] {

        // start by mapping the contents of the string self.text into an [String]
        let letters = self.text.letterArray()
        //build a new local var to keep track of the values of each letter
        var values = [Int]()
//        var idx = 0

        // idx is used to track character placement for re-insertion in case we try to keep unusable characters.
        for atIndex in 0 ..< letters.count {//enumerate our array of letter strings

            if (alphabet.unique).contains( letters[ atIndex ]) { //make sure our letter is a valid character
                //if our alphabetCharacters don't include letter we don't want to use it for encryption or decryption because it is an illegal character for our encryptionary

                //if it is in our list of usable characters we add it to our values by finding its value in our alphabet dictionary of letter values
                values.append(self.alphabet.alphabetValue.valueForLetter[ letters[ atIndex ] ]!)

            }else{

                //if the character is not usable by our encryption system and if we want to keep unusable characters we add it to our dictionary using it's index in letters array as the key
                if self.attemptToKeepUnusableCharacters {

                    //To get a text value we just map the String and return each letters value as found in the alphabet dictionary in an Array of Int
                    //We can also record the whiteSpace and illegal characters before we discard it for processing
                    self.unusableCharacters[ atIndex ] = letters[ atIndex ]
                }
            }//climb to the next index

        }
        //now that we have all our values in order and packed in array we can just return it.
        return values
    }


    ///simple function to return our letter values into a human readable text
    private func decodeValueForText() -> String {

        //to return our value to a string we just map each value and pass it to our alphabet dictionary which uses the value as a key and a string as a valueForKey
        var text = self.value.map({ return self.alphabet.alphabetValue.letterForValue[ $0 ]! })

        //if we want to re-insert our white space or unusable characters now is the time to do so
        if self.attemptToKeepUnusableCharacters {

            //we need to sort the order otherwise results get a little unpredictable
            let order = self.unusableCharacters.keys.sorted {return $0 < $1}

            //also we need to check for special instructions
            if let block = self.unusedCharacterReturnBlock {

                block(self.unusableCharacters, order)
            } else {
                //else we just re-insert
                for idx in order{

                    text.insert(self.unusableCharacters[idx]!, at: idx)
                }
                self.unusableCharacters = [Int : String]()
            }
        }
        
        return text.joined() // now that we have an array of string we can just join it for our text string
    }
}






















