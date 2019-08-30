    //
//  SSKryptosEncryptionSystem.swift
//  Kryptos
//
//  Created by Craig Spell on 12/16/16.
//  Copyright © 2016 Spell Software Inc. All rights reserved.
//

import Foundation


/// SSKryptosEncryptionSystem is the abstract base class for the encryption and decryption of the Kryptos puzzle located in Langely VA.
///
/// - Parameters:
///   - alphabet: The SSKryptosEncryption alphabet to process letter values against.
class SSKryptosEncryptionSystem : NSCoding {


    ///Only two process directions are possible encryption and decryption.
    internal enum ProcessDirection {
        case Encryption;
        case Decryption;
    }

    internal enum ProcessType {
        case KryptosVigenere;
//        case PolyAlphabetic;
//        case MonoAlphabetic;
        case Transposition;
    }
    ///Enum used to differenciate between text(message/secret) or if it's the keyword or just a generic unknown type.
    internal enum TextType{
        case Text;
        case Key;
        case Unknown;
    }

    /// Class method used internally during initialization to protect against an empty or nil keyword or text entry.
    ///
    /// - Parameters:
    ///   - string: The string optional to check for unusable conditions.
    ///   - position: Defined in TextType enum. Three cases exist .Text, .Key, or .Unknown. Thus allowing replacement by the proper constant if the string value is not useable.
    /// - Returns: Either the given text will be kept or it will be replaced by default constant values defined in the SSKryptosSculpture class. If the text is of an TextType.Unknown type this method will return an empty string.
    internal class func guaranteeTextIsValid(_ string: String?, position: TextType) -> String{

        if (string == nil) || (string == "") {

            switch position {

            case .Text:
                return defaultK1Text
            case .Key:
                return defaultK1Key
            case .Unknown:
                return "unusable string inserted in func guaranteeTextIsValid(_ string: String?, position: TextType) -> String{"
            }
        }
        
        return string!
    }

    //MARK: Multi-Threading Constants
    public static let kryptosWorkGroup1 = DispatchGroup.init()

    static let kryptosSerialWorkQueLabel = "com.spellsoftware.kryptos.SSKryptosEncryptionSystem.serialQue"
    static let kryptosConcurrentWorkQueLabel = "com.spellsoftware.kryptos.SSKryptosEncryptionSystem.concurrentQue"

    public static let kryptosSerialWorkQue = DispatchQueue.init(label: kryptosSerialWorkQueLabel,
                                                                qos: .userInitiated,
                                                          attributes: [],
                                                          autoreleaseFrequency: .workItem,
                                                          target: nil)

    public static let kryptosConcurrentWorkQue = DispatchQueue.init(label: kryptosConcurrentWorkQueLabel,
                                                                    qos: .userInteractive,
                                                              attributes: .concurrent,
                                                              autoreleaseFrequency: .workItem,
                                                              target: nil)
    
    //MARK: Instance Variables

    //we need our own unique alphabet for every encryptionary. This will simplify multi-threading later in the development cycle
    var alphabet : SSKryptosEncryptionAlphabet

    //TODO:Add details about this class..
    //MARK: Initializers
    /// Initializes and returns a new abstract instance of the SSEncryptionSystem class.
    ///
    /// - Parameters:
    ///   - alphabet: The SSKryptosEncryptionAlphabet to be used by subclasses for the purpose of finding letter values.
    /// - Returns: An abstract SSEncryptionSystem with only basic process methods and also stored SSKryptosEncryptionAlphabet to be used by subclasses.
    init(withAlphabet alphabet:SSKryptosEncryptionAlphabet) {

        // the only thing we actually need to set here is the alphabet variable, thus taking most of the heavy lifing and thinking away from our processing class
        self.alphabet = alphabet
    }

    //MARK: Delegates
    convenience required init?(coder aDecoder: NSCoder) {

        //the only thing we actually need for this class is the alphabet everything important is stored in the SSKryptosEncryptionAlphabet class
        self.init(withAlphabet: aDecoder.decodeObject(forKey: "alphabet") as! SSKryptosEncryptionAlphabet)
    }

    func encode(with aCoder: NSCoder) {
        //again all values needed are stored with the alphabet
        aCoder.encode(self.alphabet, forKey: "alphabet")
    }

    //MARK: Instance Methods
    /// This method produces the real workload of combining text values.
    ///
    /// - Parameters:
    ///   - text: Takes an array of lettervalues represented by integers which represent the value of the (Message/Secret) text.
    ///   - key: Takes an array of lettervalues represented by integers which represent the value of the keyword.
    ///   - process: Takes a ProcessDirection. Use .Encryption to subtract values or .Decryption to add them.
    /// - Returns: An integer array representing the letter value of the combined letter values of text and key.
    func combineValueOf(text: [Int], andKey key: [Int], forProcessDirection process: ProcessDirection) -> [Int] {

        var keyIdx = 0
        var newValue = [Int]()

        for idx in 0 ..< text.count {

            let textLetterValue = text[idx]
            let keyLetterValue = key[keyIdx]
            keyIdx += 1

            if keyIdx == key.count {
                keyIdx = 0
            }


//            SSKryptosEncryptionSystem.kryptosConcurrentWorkQue.async(execute: {

                let combinedLetterValue = self.processValues(value1: textLetterValue,
                                                             value2: keyLetterValue,
                                                             forProcessDirection: process)

//                SSKryptosEncryptionSystem.kryptosSerialWorkQue.async {
                    newValue.append(combinedLetterValue)
//                }
//            })
        }
        return newValue
    }

    ///This is the function where we determine our new values. We get the values by adding letters in order of first to last for encryption and subract letters for decryption. Notice: we have to make sure that our final value is valid. We cannot exceed the range of the original alphabet, for instance if our alphabet contains 26 letters from the English language we should not exceed that amount if we do, we must add or subtract an entire alphabet. We are adding the place value of one of 25 letter so our maximum out of range value is never more than 25 and never less than 0.
    /// - Note:
    /// This parameter changes with the alphabet length so that if we include symbols later no changes will be needed here to stay in range.
    ///
    /// - Parameters:
    ///   - value1: An integer representing the numerical value of a single letter of text.
    ///   - value2: An integer representing the numerical value of a single letter of the keyword.
    ///   - process: An enum telling us whether to add or subtract the two integers. ProcessDirection.Encryption will cause the numbers to be evaluated using subtraction and the ProcessDirection.Decryption will produce a result of the sum of the two integer values.
    /// - Returns: This method returns a result of evaluating the two integers given using the appropriate process direction. The returned integer represents the numerical value of a single return letter.(encrypted or decrypted letter..)
    private func processValues(value1: Int, value2: Int, forProcessDirection process:ProcessDirection) -> Int {

        var combinedLetterValue = 0

        if process == .Encryption {

            combinedLetterValue = value1 + value2

            if combinedLetterValue >= self.alphabet.length {

                combinedLetterValue -= self.alphabet.length
            }
        }else if process == .Decryption {

            combinedLetterValue = value1 - value2

            if combinedLetterValue < 0 {

                combinedLetterValue += self.alphabet.length
            }
        }
        return combinedLetterValue
    }
}










