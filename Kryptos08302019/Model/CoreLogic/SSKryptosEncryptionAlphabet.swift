//
//  SSEncryptionAlphabet.swift
//  Kryptos
//
//  Created by cspell on 12/15/16.
//  Copyright © 2016 Spell Software Inc. All rights reserved.
//

import Foundation

class SSKryptosEncryptionAlphabet : Codable {

    //MARK: Internal Classes

    /// An internal structure replaced by an actual class to add the ability of NSCoding protocol. The internal values are useful for the purpose of code decomposition and really aren't needed outside the enclosing class.
    ///
    /// - Parameter:
    ///   - alphabet: A Dictionary containing the key of an alphabet character and a valueForKey: of the associated 'integer value' representing it.
    ///
    ///   - letterReturn: A dictionary containing the alphabet.value as a key and the value of alphabet.value. This is useful for returning the values back to a human readable form A good way to think of it is as "reverse lookup information."
    ///
    ///   - invertedAlphabet: A dictionary representing the alphabet except the alphabetcharacters are in reverse order.
    ///
    ///   - Example:
    ///   
    ///   If alphabet = abcd, invertedAlphabet = dcba. The values associated will be alphabet = [a:0,b:1,c:2,d:3] and\ invertedAlphabet = [d:0,c:1,b:2,a:3]\
    ///
    ///   - invertedLetterReturn: This is the same as the inverted alphabet but contains the "reverse lookup information" ie: is letterReturn = [0:a,1:b,2:c,3:d] invertedLetterReturn = [0:d,1:c,2:b,3:a]
    ///
    internal class InternalValues : Codable {

        //constants used for NSCoding methods
        private let alphabetKey             = "alphabetKey"
        private let letterReturnKey         = "letterReturnKey"
        private let invertedAlphabetKey     = "invertedAlphabetKey"
        private let invertedLetterReturnKey = "invertedLetterReturnKey"

        //packaging of the needed alphabet letter values

        /// A Dictionary containing the key of an alphabet character and a valueForKey: of the associated 'integer value' representing it. ie: for the alphabet kryptos you'd have [k:0, r:1, y:2, p:3, t:4, o:5, s:6, a:7, b:8, c:9, ...]
        let alphabet             : [String : Int]
        /// The reverse letter lookup information for the alphabet, for alphabet kryptos you'd have letterReturn = [0:k, 1:r, 2:y, 3:p, 4:t, 5:o, 6:s, 7:a, 8:b, 9:c, ...]
        let letterReturn         : [Int : String]
        let invertedAlphabet     : [String : Int]
        let invertedLetterReturn : [Int : String]

        init(alphabet a1: [String : Int], letterReturn a2: [Int : String], invertedAlphabet a3: [String : Int], invertedLetterReturn a4: [Int : String] ){
            self.alphabet             = a1
            self.letterReturn         = a2
            self.invertedAlphabet     = a3
            self.invertedLetterReturn = a4
        }
    }

    //MARK: Enums and Structs
    internal struct AlphabetValue : Codable {
        //a Struct containing the currently used alphabet values
        // these values can be swapped with the inverted values as needed
        let valueForLetter : [String : Int]
        let letterForValue : [Int : String]
    }

    //can be used to add other letters and languages at another time
    public enum AlphabetOrigin : String, Codable{

        case english = "abcdefghijklmnopqrstuvwxyz"
    }

    //MARK: Instance Variables
    //added a reversed alphabet for testing

    var unique : String
    internal var internalAlphabetValues : InternalValues

    var invertAlphabet = false {

        didSet{

            //Here we know our value will change but if set to nil the getter will handle the reset so we don't need to worry about that here
            _alphabetValue = nil
        }
    }

    var alphabetOrigin : AlphabetOrigin {

        didSet{

            //if we decide to change the alphabetOrigin we need to update our letter values
            self.internalAlphabetValues = SSKryptosEncryptionAlphabet.createAlphabetWithName(name: self.name,
                                                                                             basedOn: self.alphabetOrigin)
        }
    }

    var name : String{

        didSet{

            //anytime we change the alphabet name we need to update our letter values
            self.internalAlphabetValues = SSKryptosEncryptionAlphabet.createAlphabetWithName(name: self.name,
                                                                                             basedOn: self.alphabetOrigin)
        }
    }

    //MARK: Letter Values
    var alphabetValue : AlphabetValue {

        get{
            //if the memory space is nil we set our iVar and then return it
            //basically an old lazy getter setup from obj c
            if _alphabetValue == nil {

                if self.invertAlphabet {
                    //if the user wants to invert the alphabet we use inverted values from our AlphabetValues Struct
                    _alphabetValue = AlphabetValue.init(valueForLetter: internalAlphabetValues.invertedAlphabet,
                                                        letterForValue: internalAlphabetValues.invertedLetterReturn)
                }else{

                    //other wise we just set the normal value direction from our struct
                    _alphabetValue = AlphabetValue.init(valueForLetter: internalAlphabetValues.alphabet,
                                                        letterForValue: internalAlphabetValues.letterReturn)
                }
            }
            //now that we have guaranteed a non-nil value we can unwrap and return it
            return _alphabetValue!
        }
    }

    //This is our internal storage for the current alphabet value
    private var _alphabetValue : AlphabetValue?

    //MARK: Initializers
    convenience init(withEnglishAlphabetNamed name: String?) {
        //later we may want to add different alphabets or expand our alphabet to include things like question marks etc.
        //for now we'll just stick with letters

        // in this method we simply assume the English language as the language of origin
        self.init(withAlphabetName: name, andOrigin: .english)
    }

    init(withAlphabetName name: String?, andOrigin origin: AlphabetOrigin) {

        //The reason we used the letters contained in the originating language was so that we can just take the raw value and use it for our letters
        self.alphabetOrigin = origin

        if name != nil {

            self.internalAlphabetValues = SSKryptosEncryptionAlphabet.createAlphabetWithName(name: name!,
                                                                                             basedOn: origin)
            self.name = name!
        }else{

            // initializing an alphabet without a name or with an empty string in this case yeilds alphabet values in the origin order ie: a = 0 b = 1 c = 2 etc.
            self.internalAlphabetValues = SSKryptosEncryptionAlphabet.createAlphabetWithName(name: "",
                                                                                             basedOn: origin)
            self.name = "default alphabet"
        }

        self.unique = SSKryptosEncryptionAlphabet.correctAlphabetNameByStrippingCharactersIn(string: self.name , toSupportOrigin: origin )
    }

    /// Convenience init attempting to build an alphabet from a numbered sequence. Currently you are required to have an origin in order to initialize otherwise the return would be an undefined numerical value which may be useful later on.
    ///
    /// - Parameters:
    ///   - values: An array representing the mathematical equivalent of an alphabetic letter. This translates directly to the letter in the numerical position in the originating alphabet.
    ///   - origin: The origin of the alphabet theorectiically used during final translation.

    convenience init(withValues values: [Int], andOrigin origin: AlphabetOrigin) {

        var name = ""
        let availableCharacters = origin.rawValue.map() { return String($0) }

        for letter in values {
            name.append( availableCharacters[letter] )
        }
        self.init(withAlphabetName: name, andOrigin: origin)
    }

    ///Build a unique string to represent the alphabet.
    //    private class func createUniqueOrderIdentifier(withName name: String, andOrigin origin:AlphabetOrigin) -> String {
    //we may need to know the order of the alphabet this can keep us from making the same order twice
    // for instance one alphabet name may be "abs" another maybe "abstain" each will follow the same order
    //during multithreading later we may want to keep track of used orders to keep from repeating the processing of those alphabets
    //        var charactersArray = [String]()
    //
    //        for letter in (name + origin).letterArray() {
    //            if origin.contains(letter) {
    //
    //                if !charactersArray.contains(letter) {
    //                    charactersArray.append(letter)
    //                }
    //            }
    //        }
    //        return SSKryptosEncryptionAlphabet.correctAlphabetNameByStrippingCharactersIn(string:name , toSupportOrigin:origin )
    //    }

    //MARK: Class Methods
    /// Trims any characters not included in the origin alphabet.
    ///
    /// - Parameters:
    ///   - string: A string of characters that need to be stripped of any characters not defined whithin the origin alphabet.
    ///   - origin: A predefined Alphabet of origin containing all appropriate characters for the return text.
    /// - Returns: A new string using only the appropriate characters and appending the origin alphabet to the end.
    class func correctAlphabetNameByStrippingCharactersIn(string: String, toSupportOrigin origin: AlphabetOrigin) -> String {

        let characterSet = CharacterSet.init(charactersIn: origin.rawValue).inverted
        return (string.trimmingCharacters(in: characterSet) + origin.rawValue)
    }

    class func createAlphabetWithName(name:String, basedOn originAlphabet: AlphabetOrigin) -> InternalValues {

        //we need to make sure we start with empty dictionaries to add values in this method call
        //here we're using local variables so that we can set constant values in our InternalValues class.
        var alphabet             = [String : Int]()
        var letterReturn         = [Int : String]()
        var invertedAlphabet     = [String : Int]()
        var invertedLetterReturn = [Int : String]()

        //first we have to determine the order of the alphabet, we must have all letters in the English alphabet without any duplicates. We also change everything to lowercase in order to simplify things. we know the name of the alphabet goes first so we can just add the English alphabet and remove the duplicates when we determine the value later.

        let correcttedName = SSKryptosEncryptionAlphabet.correctAlphabetNameByStrippingCharactersIn(string: name,
                                                                                                    toSupportOrigin: originAlphabet)
        let letterOrder = correcttedName.letterArray()

        //added ability to reverse alphabet for testing
        let reversedLetterOrder = Array(correcttedName.letterArray().reversed())

        //the count will keep track of how many letters have already been ordered in the new alphabet
        var count = 0


        //now we just enumerate all the letters
        for letter in letterOrder {

            //make sure the character is a legal alphabet value as passed to us
            //WARNING: recently changed to allow alphabet alteration which may have unintended side effects further review needed
            if originAlphabet.rawValue.contains(letter) {

                //remove duplicates
                if !alphabet.keys.contains(letter) {

                    //add the letter with the value as tracked by the count variable
                    alphabet[letter] = count

                    //and for a reversed alphabet
                    invertedAlphabet[reversedLetterOrder[count]] = count

                    //we also update our letterReturn Dictionary so that we can reclaim our values later as letters so we are back in a human readable format
                    letterReturn[count] = letter

                    //and inverted values
                    invertedLetterReturn[count] = reversedLetterOrder[count]

                    //update the number of letters added
                    //notice we only update if a new letter is actually added
                    //we know we will always end up with the same number of letters
                    //any illegal values are not counted duplicates are removed and we added the entire alphabet onto the end of the chosen alphabet name
                    count += 1
                }
            }
        }
        //we now use a small class as a package for our values instead of a structure in fact this
        //was originally done by updating variables directly but was changed when adding nscoder protocal
        return InternalValues.init(alphabet:             alphabet,
                                   letterReturn:         letterReturn,
                                   invertedAlphabet:     invertedAlphabet,
                                   invertedLetterReturn: invertedLetterReturn)
    }
}



extension SSKryptosEncryptionAlphabet {
    var length : Int {
        get{
            return self.alphabetOrigin.rawValue.count
        }
    }
}


