//
//  SSKryptosEncryptionary.swift
//  Kryptos
//
//  Created by Craig Spell on 12/16/16.
//  Copyright © 2016 Spell Software Inc. All rights reserved.
//

import Foundation

class SSKryptosEncryptionary: SSKryptosEncryptionSystem {

    //MARK: Instance Variables
    var attemptToKeepUnusuableCharacters = true
    var encryptAndDecryptAroundUnusableCharacters = false
    var processIsCancelled = false
    var processProgress = Progress.init(totalUnitCount: -1)

    private var internalText : SSKryptosText
    private var internalKeyword : SSKryptosText

    //added a reversed alphabet for testing
    var invertAlphabet : Bool {

        get{
            return self.alphabet.invertAlphabet
        }
        set{
            self.alphabet.invertAlphabet = newValue
        }
    }

    //MARK: Superficial Variables

    //Here we simply pass string values to our internalStorage and let the SSKryptosTextValueConverter do the process work for us as far as determining letter values...
    //Originally this was done manually through our alphabet. Now however I have added a Class to handle values and strings together
    var text : String {

        get{
            return self.internalText.text
        }
        set{
            //notice we actually allow an empty string
            //we don't correct it for clearity to the end user 
            //however an empty string will return an empty string when encrypted or decrypted
            self.internalText = SSKryptosText.init(withText: newValue, forAlphabet: self.alphabet)
            self.internalText.attemptToKeepUnusableCharacters = self.attemptToKeepUnusuableCharacters
        }
    }

    //Here we simply pass string values to our internalStorage and let the SSKryptosTextValueConverter do the process work for us at far as determining letter values...
    //Originally this was done manually through our alphabet. Now however I have added a Class to handle values and strings together
    var keyword : String {

        get{
            return self.internalKeyword.text
        }
        set{
            //notice we actually allow an empty string
            //we don't correct it for clearity to the end user
            //however an empty string will not alter the text when encrypted or decrypted
            self.internalKeyword = SSKryptosText.init(withText: newValue, forAlphabet: self.alphabet)
        }
    }

    //MARK: Initializers
    convenience init(text txt: String?, keyword key: String?, withEnglishAlphabetNamed alphabetName: String?) {

        let alpha = SSKryptosEncryptionAlphabet.init(withEnglishAlphabetNamed: alphabetName)
        self.init(withText: txt, keyword: key, andAlphabet: alpha)
    }

    convenience init(withText txt: String?, keyword key: String?, andAlphabet alpha: SSKryptosEncryptionAlphabet) {

        //notice class method +guaranteeTextIsValid() is being called from super class
        //it could be called on the SSKryptosEncryptionary class but the method is actually written in the super class
        let initText = SSKryptosText.init(withText: SSKryptosEncryptionary.guaranteeTextIsValid(txt, position: .Text), forAlphabet: alpha)
        let initKey = SSKryptosText.init(withText: SSKryptosEncryptionary.guaranteeTextIsValid(key, position: .Key), forAlphabet: alpha)

        self.init(withKryptosText: initText, keyWord: initKey, andAlphabet: alpha)
    }

    init(withKryptosText txt: SSKryptosText, keyWord key:SSKryptosText, andAlphabet alpha: SSKryptosEncryptionAlphabet) {

        self.internalText = txt
        self.internalKeyword = key

        super.init(withAlphabet: alpha)

    }

    convenience required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Instance Methods
    //These two methods are for convenience we can encrypt or decrypt based on our current stored values
    func encrypt() -> String {
        
        return self.encryptMessage(self.internalText, withKeyword: self.internalKeyword)
    }

    //    func encrypt(completion: @escaping (_ text: String) -> Void) {
    //
    //        let txt = self.internalText
    //        let key = self.internalKeyword
    //
    //        self.processInformation(v1: txt, v2: key, v3: .Encryption, completion: completion)
    //    }

    func decrypt() -> String {
//        var key = self.keyword
//        while key.count < self.text.count {
//            key.append(self.keyword)
//        }
//        key = String(key.prefix(self.text.count))
//
//        print(String(key.suffix(97)))

        return self.decryptSecret(self.internalText, withKeyword: self.internalKeyword)
    }

    //    func decrypt(completion: @escaping (_ text: String) -> Void) {
    //
    //        let txt = self.internalText
    //        let key = self.internalKeyword
    //
    //        self.processInformation(v1: txt, v2: key, v3: .Decryption, completion: completion)
    //    }

    //end user encryption and decryption methods
    func encryptMessage(_ message: String) -> String {

        let txt = SSKryptosText.init(withText: message, forAlphabet: self.alphabet)
        return self.encryptMessage(txt, withKeyword: self.internalKeyword)
    }

    func decryptSecret(_ secret: String) -> String {
        
        let txt = SSKryptosText.init(withText: secret, forAlphabet: self.alphabet)
        return self.decryptSecret(txt, withKeyword: self.internalKeyword)
    }

    func encryptMessageUsingKeyword(_ keyword: String) -> String {
        
        let key = SSKryptosText.init(withText: keyword, forAlphabet: self.alphabet)
        return self.encryptMessage(self.internalText, withKeyword: key)
    }

    func decryptSecretUsingKeyword(_ keyword: String) -> String {
        
        let key = SSKryptosText.init(withText: keyword, forAlphabet: self.alphabet)
        return self.decryptSecret(self.internalText, withKeyword: key)
    }

    func encryptMessage(_ message: SSKryptosText, withKeyword keyword: SSKryptosText) -> String {
        return processInformation(v1: message, v2: keyword, v3: .Encryption)
    }

    func decryptSecret(_ secret: SSKryptosText, withKeyword keyword: SSKryptosText) -> String {
        return self.processInformation(v1: secret, v2: keyword, v3: .Decryption)
    }

    func decryptSecretUsingKeyWordGroupOnGPUs(keyWords:[String],
                                              updateProgressBlock: ((Progress) -> Void)? = nil,
                                              completion: @escaping ([String : String]) -> Void ) -> Void {
        // array to fill amd return
        var messages = [String : String]()
        // quick way of getting rid of any duplicates that may exist in the key word supply
        let nonRepeatingWords = Array(Set(keyWords))

        //FIXME:
        //getting bad access when calling self
        //making a local copy
        let textValue = self.internalText.value

        //group used for flow control to wait for all blocks to execute before completion of the method
        let bruteGroup = DispatchGroup.init()

        processProgress.totalUnitCount = 2
        processProgress.becomeCurrent(withPendingUnitCount: 2)

        let methodProgress = Progress.init(totalUnitCount: Int64( nonRepeatingWords.count * 2),
                                           parent: self.processProgress,
                                           pendingUnitCount: 2)

        //dispatch a semiphore to keep from over flowing available reasources such as the heap
        let cpuCoreCount = ProcessInfo.processInfo.processorCount
        let jobSemiphore = DispatchSemaphore.init(value: cpuCoreCount * 4)

        for key in nonRepeatingWords {

            jobSemiphore.wait()

            SSKryptosEncryptionSystem.kryptosConcurrentWorkQue.async(group: bruteGroup,
                                                                     execute:
                { 

                    var keyVal = key.letterArray().map({ return self.alphabet.alphabetValue.valueForLetter[ $0 ]! })

                    while textValue.count > keyVal.count {
                        keyVal.append(contentsOf: keyVal)
                    }

                    GPUMath.init(array1: textValue,
                                 array2: Array(keyVal.prefix(textValue.count)),
                                 alphabetSize: self.alphabet.length ).subtract(completion:
                                    { (results, _)  in

                                        methodProgress.completedUnitCount += 1

                                        SSKryptosEncryptionSystem.kryptosSerialWorkQue.async (group: bruteGroup,
                                                                                              execute:
                                            {

                                                messages[key] = results.map({ return self.alphabet.alphabetValue.letterForValue[ $0 ]! }).joined()

                                                methodProgress.completedUnitCount += 1
                                                updateProgressBlock?( self.processProgress )

                                                jobSemiphore.signal()
                                        })
                                 })
            })
        }

        bruteGroup.wait()

        SSKryptosEncryptionSystem.kryptosSerialWorkQue.sync { [unowned self] in

            methodProgress.completedUnitCount = methodProgress.totalUnitCount
            updateProgressBlock?( self.processProgress )
            completion(messages)
        }
    }




    func decryptSecretUsingKeyWordGroup(keyWords:[String],
                                        withProgressUpdates progress: (( _ progress: Progress ) -> Void)? = nil,
                                        completion: @escaping (_ results: [String : String]) -> Void ) -> Void {

        let bruteGroup = DispatchGroup.init()

        // quick way of getting rid of any duplicates that may exist in the key word supply
        let nonRepeatingWords = Array(Set(keyWords))

        processProgress.totalUnitCount = 2
        processProgress.becomeCurrent(withPendingUnitCount: 2)

        let methodProgress = Progress.init(totalUnitCount: Int64( nonRepeatingWords.count * 2),
                                           parent: self.processProgress,
                                           pendingUnitCount: 2)

        var messages = [String : String]()
        let text = self.internalText

        let cpuCoreCount = ProcessInfo.processInfo.processorCount
        let jobSemiphore = DispatchSemaphore.init(value: cpuCoreCount * 4)

        for key in keyWords {

            jobSemiphore.wait()

            SSKryptosEncryptionSystem.kryptosConcurrentWorkQue .async(execute:  DispatchWorkItem.init(block: {

                let textConverter = SSKryptosText.init(withText: key, forAlphabet: self.alphabet)
                let message = self.decryptSecret(text, withKeyword: textConverter)

                methodProgress.completedUnitCount += 1

                SSKryptosEncryptionSystem.kryptosSerialWorkQue.async {

                    methodProgress.completedUnitCount += 1
                    messages[key] = message
                    progress?(self.processProgress)

                    jobSemiphore.signal()
                }

            }))
        }

        bruteGroup.wait()

        methodProgress.resignCurrent()

        completion( messages )
        methodProgress.completedUnitCount = methodProgress.totalUnitCount
        progress?(methodProgress)
    }

    
    //MARK: WorkLoad
    private func processInformation(v1: SSKryptosText, v2: SSKryptosText, v3: ProcessDirection) -> String {

        let newValue = super.combineValueOf(text: v1.value,
                                            andKey: v2.value,
                                            forProcessDirection: v3)

        let newText = SSKryptosText.init(withValue: newValue,
                                         andAlphabet: self.alphabet)

        if  self.attemptToKeepUnusuableCharacters == true {
            newText.attemptToKeepUnusableCharacters = true
            newText.unusableCharacters = v1.unusableCharacters
        }


        return newText.text
    }

    private func processInformationOnGPU(v1: SSKryptosText, v2: SSKryptosText, v3: ProcessDirection) -> String {

        let gpu = GPUMath.init(array1: v1.value, array2: v2.value, alphabetSize: self.alphabet.length)

        var resultValue = [Int]()

        let block : (([Int], Bool) -> Void) = { (result, _) in
            resultValue = result
        }

        SSKryptosEncryptionSystem.kryptosSerialWorkQue.sync {

            switch v3 {

            case .Encryption:
                gpu.add(completion: block)
                break

            default:
                gpu.subtract(completion: block)
                break
            }
        }

        let newText = SSKryptosText.init(withValue: resultValue, andAlphabet: self.alphabet)

        return newText.text

    }
}
