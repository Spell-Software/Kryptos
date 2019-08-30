//
//  main.swift
//  Kryptos
//
//  Created by Craig Spell on 12/16/16.
//  Copyright © 2016 Spell Software Inc. All rights reserved.
//

import Foundation

var programShouldContinueRunning = true

let wordsDatabase = SSKryptosWordDataBase.init()
var englishWordSet = wordsDatabase.englishWordsSet

let words = Array(Set(SSKryptosWordDataBase.init().englishWordsArray))

var encryptionary : SSKryptosEncryptionary?

//MARK: Enums
enum UserCommands : String {
    case buildEncryptionary, encrypt, decrypt, exit, changeKeyword, changeText, k4Brute, runNumbers, tryAllKeys
}

enum SculptureParts : String {
    case k1, k2, k3, k4
}

func encryptionForSculptureParts(part: SculptureParts) -> String {

    switch part {
    case .k1:
        return k1Encryption

    case .k2:
        return k2Encryption

    case .k3:
        return k3Encryption

    default:
        return k4Encryption
    }
}


enum StringType {
    case text, keyword, alphabet
}

enum ProcessType {
    case encrypt, decrypt
}

//MARK: Program Functions
func makeCsvFileInDocumentsDirectory(name: String, contents: [String : String]){

    guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return
    }

    print(path)

    let fileName = path.appendingPathComponent( "\(name).csv" )

    var csvString = ""

    for string in contents.keys {
        csvString.append("\(string),\t \t \t, \( contents[ string ]!),\n")
    }

    do{
        try csvString.write(to: fileName, atomically: true, encoding: .utf8)
    }catch let error{
        print(error.localizedDescription)
    }
}

func buildEncryptionary(){



    let alphabetName = changeText(stringType: .alphabet)

    encryptionary = SSKryptosEncryptionary.init(text: changeText(stringType: .text),
                                                keyword: changeText(stringType: .keyword),
                                                withEnglishAlphabetNamed: alphabetName)

    print("Encryptionary built as \(encryptionary!)")
}

func changeText(stringType: StringType) -> String{
    
    var userInstruction = ""
    var userNote = ""

    if stringType == .text {
        
        userInstruction = "Enter the text you'd like to encrypt or decrypt\n"
        userNote = "Text set as "
    }else if stringType == .keyword {
        
        userInstruction = "Enter the keyword you'd like to use.\n"
        userNote = "Key set as "
    }else {

        userInstruction = "Enter an alphabet name or order: \nExample: \"kryptos\"\n"
        userNote = "Alphabet name set as "
    }
    
    return getUserInputWith(userInstruction: userInstruction, userNote: userNote)
}

func getUserInputWith(userInstruction: String, userNote: String) -> String {
    
    print(userInstruction)
    var response = "kryptos"
    if let userResponce = readLine(), userResponce != "" {

        response = userResponce

        if let part = SculptureParts.init(rawValue: userResponce) {

            response = encryptionForSculptureParts(part: part)
        }
    }else{
        print("ERROR: Input not recieved")
    }
    print(userNote + "\"\(response)\"\n")
    return response
}

func processEncryptionaryWith(processType: ProcessType ){
    
    if encryptionary == nil {
        print("ERROR: An encryptionary hasn't been built yet.")
        return
    }
    
    switch processType {
        
    case .encrypt:
        print("\(encryptionary!.encrypt())")
        break
    case .decrypt:
        print("\(encryptionary!.decrypt())")
        break
    }
}

func evaluateUserInput(_ input: String) {
    
    switch input.lowercased() {
        
    case UserCommands.buildEncryptionary.rawValue.lowercased(),  "build":
        buildEncryptionary()
        break
        
    case UserCommands.changeText.rawValue.lowercased():
        encryptionary?.text = changeText(stringType: .text)
        break
        
    case UserCommands.changeKeyword.rawValue.lowercased():
        encryptionary?.keyword = changeText(stringType: .keyword)
        break
        
    case UserCommands.encrypt.rawValue.lowercased():
        processEncryptionaryWith(processType: .encrypt)
        break
        
    case UserCommands.decrypt.rawValue.lowercased():
        processEncryptionaryWith(processType: .decrypt)
        break
        
    case UserCommands.exit.rawValue.lowercased():
        programShouldContinueRunning = false
        break
        
    case UserCommands.k4Brute.rawValue.lowercased():
        runAllAlphabetsAndKeysOnK4()
        break

    case UserCommands.tryAllKeys.rawValue.lowercased():
        decryptAllKeysAgainstSecret()
        break

    default:
        print("ERROR: Command \"\(input)\" not recognized.")
        print("Please try another command:\n")
        break
    }
}

func decryptAllKeysAgainst(string: String, alphabetName name: String ){

    NSLog("start time")

    let enc = SSKryptosEncryptionary.init(withText: string, keyword: nil, andAlphabet: SSKryptosEncryptionAlphabet.init(withEnglishAlphabetNamed: name))

    enc.decryptSecretUsingKeyWordGroupOnGPUs(keyWords: words,updateProgressBlock: nil )
    {
        ( results ) in
        makeCsvFileInDocumentsDirectory(name: string + name , contents: results)
        NSLog("end time")
    }
}

func decryptAllKeysAgainstSecret() {

    NSLog("start time")


    encryptionary?.decryptSecretUsingKeyWordGroupOnGPUs(keyWords: words,updateProgressBlock: nil )
    {
        ( results ) in
        makeCsvFileInDocumentsDirectory(name: encryptionary!.alphabet.name + encryptionary!.text , contents: results)
        NSLog("end time")
    }

}



//func runNumbers(){
//
//    let length = SSKryptosEncryptionAlphabet.AlphabetOrigin.english.rawValue.length
//    let numbers = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]
//
//    for idx in numbers {
//
//        let alphabetSequence = numbers
//
//    }
//}

func valueForCommand(_ command: UserCommands) -> String {
    return command.rawValue.lowercased()
}

func runAllAlphabetsAndKeysOnK4() {
    
    print("WARNING: This process will consume extreme system resources and will take some time to complete.\n It's recommended to only run this process on developmental machines and may cause other programs or tasks to become unresponsive. Currently it is estimated that this process can last over a year on some machines.")
    
    print("\n Are you sure you want to continue? Y/N:")
    
    if let userAck = readLine()?.lowercased(), ((userAck == "y") || (userAck == "yes")) {
        NSLog("start time")
        
        for alphabetName in englishWordSet {
            let enc = SSKryptosEncryptionary.init(withText: changeText(stringType: .text),
                                                            keyword: nil,
                                                            andAlphabet: SSKryptosEncryptionAlphabet.init(withAlphabetName: alphabetName as String,
                                                                andOrigin: .english))

            enc.decryptSecretUsingKeyWordGroupOnGPUs(keyWords: words, updateProgressBlock: nil )
            {
                ( results ) in
                makeCsvFileInDocumentsDirectory(name: enc.alphabet.name + enc.text , contents: results)

                NSLog("end time")
            }
        }
    }
    print("Enter a command to start. \n")
}


func breakEncryptionary(_ encryptionary: SSKryptosEncryptionary){

    var ans = [String]()
    
    for keyWord in englishWordSet {
        
        let message = encryptionary.decryptSecretUsingKeyword(keyWord as String)
        
        if message.contains("berlinclock") {
            print("found berlinclock using key \(keyWord) and alphabet \(encryptionary.alphabet.name)")
        }
        ans.append(message)
    }
    print(ans)

}


//MARK: Program Runtime

//TestFile().run()

print("Enter a command to start. \n")

while programShouldContinueRunning {
    
    if let userInput = readLine() {
        
        evaluateUserInput(userInput)
    }
}




////xOBKRUOXOGHULBSOLIFBBWFLRVQQPRNGKSSOTWTQSJQSSEKZZWATJKLUDIAWINFBNypvttmzfpk
////berlinclock utpwvztd























