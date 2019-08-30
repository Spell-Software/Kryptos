//
//  SSKryptosSculpture.swift
//  Kryptos
//
//  Created by Craig Spell on 12/16/16.
//  Copyright © 2016 Spell Software Inc. All rights reserved.
//

import Foundation

let defaultK1Text =  "between subtle shading and the absence of light lies the nuance of iqlusion"
let defaultK1TextNoSpaces =  "betweensubtleshadingandtheabsenceoflightliesthenuanceofiqlusion"

let defaultK1Key = "palimpsest"
let defaultK1Alphabet = "kryptos"




//    public static var sharedInstance = SSKryptosSculpture.init()

    let line1  = "EMUFPHZLRFAXYUSDJKZLDKRNSHGNFIVJ".lowercased()
    let line2  = "YQTQUXQBQVYUVLLTREVJYQTMKYRDMFD".lowercased()
    let line3  = "VFPJUDEEHZWETZYVGWHKKQETGFQJNCE".lowercased()
    let line4  = "GGWHKK?DQMCPFQZDQMMIAGPFXHQRLG".lowercased()
    let line5  = "TIMVMZJANQLVKQEDAGDVFRPJUNGEUNA".lowercased()
    let line6  = "QZGZLECGYUXUEENJTBJLBQCRTBJDFHRR".lowercased()
    let line7  = "YIZETKZEMVDUFKSJHKFWHKUWQLSZFTI".lowercased()
    let line8  = "HHDDDUVH?DWKBFUFPWNTDFIYCUQZERE".lowercased()
    let line9  = "EVLDKFEZMOQQJLTTUGSYQPFEUNLAVIDX".lowercased()
    let line10 = "FLGGTEZ?FKZBSFDQVGOGIPUFXHHDRKF".lowercased()
    let line11 = "FHQNTGPUAECNUVPDJMQCLQUMUNEDFQ".lowercased()
    let line12 = "ELZZVRRGKFFVOEEXBDMVPNFQXEZLGRE".lowercased()
    let line13 = "DNQFMPNZGLFLPMRJQYALMGNUVPDXVKP".lowercased()
    let line14 = "DQUMEBEDMHDAFMJGZNUPLGEWJLLAETG".lowercased()

    let line15 = "ENDYAHROHNLSRHEOCPTEOIBIDYSHNAIA".lowercased()
    let line16 = "CHTNREYULDSLLSLLNOHSNOSMRWXMNE".lowercased()
    let line17 = "TPRNGATIHNRARPESLNNELEBLPIIACAE".lowercased()
    let line18 = "WMTWNDITEENRAHCTENEUDRETNHAEOE".lowercased()
    let line19 = "TFOLSEDTIWENHAEIOYTEYQHEENCTAYCR".lowercased()
    let line20 = "EIFTBRSPAMHHEWENATAMATEGYEERLB".lowercased()
    let line21 = "TEEFOASFIOTUETUAEOTOARMAEERTNRTI".lowercased()
    let line22 = "BSEDDNIAAHTTMSTEWPIEROAGRIEWFEB".lowercased()
    let line23 = "AECTDDHILCEIHSITEGOEAOSDDRYDLORIT".lowercased()
    let line24 = "RKLMLEHAGTDHARDPNEOHMGFMFEUHE".lowercased()
    let line25 = "ECDMRIPFEIMEHNLSSTTRTVDOHW?OBKR".lowercased()
    let line26 = "UOXOGHULBSOLIFBBWFLRVQQPRNGKSSO".lowercased()
    let line27 = "TWTQSJQSSEKZZWATJKLUDIAWINFBNYP".lowercased()
    let line28 = "VTTMZFPKWGDKZXTJCDIGKUHUAUEKCAR".lowercased()

    /// Starting count of 0 ending at 28 and each number coresponds to a line of encrypted text in the sculpture.
    let transcriptDictionary = [0  : "EMUFPHZLRFAXYUSDJKZLDKRNSHGNFIVJ".lowercased(),
                                1  : "YQTQUXQBQVYUVLLTREVJYQTMKYRDMFD".lowercased(),
                                2  : "VFPJUDEEHZWETZYVGWHKKQETGFQJNCE".lowercased(),
                                3  : "GGWHKK?DQMCPFQZDQMMIAGPFXHQRLG".lowercased(),
                                4  : "TIMVMZJANQLVKQEDAGDVFRPJUNGEUNA".lowercased(),
                                5  : "QZGZLECGYUXUEENJTBJLBQCRTBJDFHRR".lowercased(),
                                6  : "YIZETKZEMVDUFKSJHKFWHKUWQLSZFTI".lowercased(),
                                7  : "HHDDDUVH?DWKBFUFPWNTDFIYCUQZERE".lowercased(),
                                8  : "EVLDKFEZMOQQJLTTUGSYQPFEUNLAVIDX".lowercased(),
                                9  : "FLGGTEZ?FKZBSFDQVGOGIPUFXHHDRKF".lowercased(),
                                10 : "FHQNTGPUAECNUVPDJMQCLQUMUNEDFQ".lowercased(),
                                11 : "ELZZVRRGKFFVOEEXBDMVPNFQXEZLGRE".lowercased(),
                                12 : "DNQFMPNZGLFLPMRJQYALMGNUVPDXVKP".lowercased(),
                                13 : "DQUMEBEDMHDAFMJGZNUPLGEWJLLAETG".lowercased(),

                                14 : "ENDYAHROHNLSRHEOCPTEOIBIDYSHNAIA".lowercased(),
                                15 : "CHTNREYULDSLLSLLNOHSNOSMRWXMNE".lowercased(),
                                16 : "TPRNGATIHNRARPESLNNELEBLPIIACAE".lowercased(),
                                17 : "WMTWNDITEENRAHCTENEUDRETNHAEOE".lowercased(),
                                18 : "TFOLSEDTIWENHAEIOYTEYQHEENCTAYCR".lowercased(),
                                19 : "EIFTBRSPAMHHEWENATAMATEGYEERLB".lowercased(),
                                20 : "TEEFOASFIOTUETUAEOTOARMAEERTNRTI".lowercased(),
                                21 : "BSEDDNIAAHTTMSTEWPIEROAGRIEWFEB".lowercased(),
                                22 : "AECTDDHILCEIHSITEGOEAOSDDRYDLORIT".lowercased(),
                                23 : "RKLMLEHAGTDHARDPNEOHMGFMFEUHE".lowercased(),
                                24 : "ECDMRIPFEIMEHNLSSTTRTVDOHW?OBKR".lowercased(),
                                25 : "UOXOGHULBSOLIFBBWFLRVQQPRNGKSSO".lowercased(),
                                26 : "TWTQSJQSSEKZZWATJKLUDIAWINFBNYP".lowercased(),
                                27 : "VTTMZFPKWGDKZXTJCDIGKUHUAUEKCAR".lowercased()]

    let transcriptDictionaryLetterArray : [Int : [String]] = [0  : "EMUFPHZLRFAXYUSDJKZLDKRNSHGNFIVJ".lowercased().components(separatedBy: ""),
                                                              1  : "YQTQUXQBQVYUVLLTREVJYQTMKYRDMFD".lowercased().components(separatedBy: ""),
                                                              2  : "VFPJUDEEHZWETZYVGWHKKQETGFQJNCE".lowercased().components(separatedBy: ""),
                                                              3  : "GGWHKK?DQMCPFQZDQMMIAGPFXHQRLG".lowercased().components(separatedBy: ""),
                                                              4  : "TIMVMZJANQLVKQEDAGDVFRPJUNGEUNA".lowercased().components(separatedBy: ""),
                                                              5  : "QZGZLECGYUXUEENJTBJLBQCRTBJDFHRR".lowercased().components(separatedBy: ""),
                                                              6  : "YIZETKZEMVDUFKSJHKFWHKUWQLSZFTI".lowercased().components(separatedBy: ""),
                                                              7  : "HHDDDUVH?DWKBFUFPWNTDFIYCUQZERE".lowercased().components(separatedBy: ""),
                                                              8  : "EVLDKFEZMOQQJLTTUGSYQPFEUNLAVIDX".lowercased().components(separatedBy: ""),
                                                              9 : "FLGGTEZ?FKZBSFDQVGOGIPUFXHHDRKF".lowercased().components(separatedBy: ""),
                                                              10 : "FHQNTGPUAECNUVPDJMQCLQUMUNEDFQ".lowercased().components(separatedBy: ""),
                                                              11 : "ELZZVRRGKFFVOEEXBDMVPNFQXEZLGRE".lowercased().components(separatedBy: ""),
                                                              12 : "DNQFMPNZGLFLPMRJQYALMGNUVPDXVKP".lowercased().components(separatedBy: ""),
                                                              13 : "DQUMEBEDMHDAFMJGZNUPLGEWJLLAETG".lowercased().components(separatedBy: ""),
                                                              14 : "ENDYAHROHNLSRHEOCPTEOIBIDYSHNAIA".lowercased().components(separatedBy: ""),
                                                              15 : "CHTNREYULDSLLSLLNOHSNOSMRWXMNE".lowercased().components(separatedBy: ""),
                                                              16 : "TPRNGATIHNRARPESLNNELEBLPIIACAE".lowercased().components(separatedBy: ""),
                                                              17 : "WMTWNDITEENRAHCTENEUDRETNHAEOE".lowercased().components(separatedBy: ""),
                                                              18 : "TFOLSEDTIWENHAEIOYTEYQHEENCTAYCR".lowercased().components(separatedBy: ""),
                                                              19 : "EIFTBRSPAMHHEWENATAMATEGYEERLB".lowercased().components(separatedBy: ""),
                                                              20 : "TEEFOASFIOTUETUAEOTOARMAEERTNRTI".lowercased().components(separatedBy: ""),
                                                              21 : "BSEDDNIAAHTTMSTEWPIEROAGRIEWFEB".lowercased().components(separatedBy: ""),
                                                              22 : "AECTDDHILCEIHSITEGOEAOSDDRYDLORIT".lowercased().components(separatedBy: ""),
                                                              23 : "RKLMLEHAGTDHARDPNEOHMGFMFEUHE".lowercased().components(separatedBy: ""),
                                                              24 : "ECDMRIPFEIMEHNLSSTTRTVDOHW?OBKR".lowercased().components(separatedBy: ""),
                                                              25 : "UOXOGHULBSOLIFBBWFLRVQQPRNGKSSO".lowercased().components(separatedBy: ""),
                                                              26 : "TWTQSJQSSEKZZWATJKLUDIAWINFBNYP".lowercased().components(separatedBy: ""),
                                                              27 : "VTTMZFPKWGDKZXTJCDIGKUHUAUEKCAR".lowercased().components(separatedBy: "")]

    let transcript = "EMUFPHZLRFAXYUSDJKZLDKRNSHGNFIVJYQTQUXQBQVYUVLLTREVJYQTMKYRDMFDVFPJUDEEHZWETZYVGWHKKQETGFQJNCEGGWHKK?DQMCPFQZDQMMIAGPFXHQRLGTIMVMZJANQLVKQEDAGDVFRPJUNGEUNAQZGZLECGYUXUEENJTBJLBQCRTBJDFHRRYIZETKZEMVDUFKSJHKFWHKUWQLSZFTIHHDDDUVH?DWKBFUFPWNTDFIYCUQZEREEVLDKFEZMOQQJLTTUGSYQPFEUNLAVIDXFLGGTEZ?FKZBSFDQVGOGIPUFXHHDRKFFHQNTGPUAECNUVPDJMQCLQUMUNEDFQELZZVRRGKFFVOEEXBDMVPNFQXEZLGREDNQFMPNZGLFLPMRJQYALMGNUVPDXVKPDQUMEBEDMHDAFMJGZNUPLGEWJLLAETGENDYAHROHNLSRHEOCPTEOIBIDYSHNAIACHTNREYULDSLLSLLNOHSNOSMRWXMNETPRNGATIHNRARPESLNNELEBLPIIACAEWMTWNDITEENRAHCTENEUDRETNHAEOETFOLSEDTIWENHAEIOYTEYQHEENCTAYCREIFTBRSPAMHHEWENATAMATEGYEERLBTEEFOASFIOTUETUAEOTOARMAEERTNRTIBSEDDNIAAHTTMSTEWPIEROAGRIEWFEBAECTDDHILCEIHSITEGOEAOSDDRYDLORITRKLMLEHAGTDHARDPNEOHMGFMFEUHEECDMRIPFEIMEHNLSSTTRTVDOHW?OBKRUOXOGHULBSOLIFBBWFLRVQQPRNGKSSOTWTQSJQSSEKZZWATJKLUDIAWINFBNYPVTTMZFPKWGDKZXTJCDIGKUHUAUEKCAR".lowercased()


    let k1Encryption = "emufphzlrfaxyusdjkzldkrnshgnfivjyqtquxqbqvyuvlltrevjyqtmkyrdmfd"
    let k2Encryption = "VFPJUDEEHZWETZYVGWHKKQETGFQJNCEGGWHKK?DQMCPFQZDQMMIAGPFXHQRLGTIMVMZJANQLVKQEDAGDVFRPJUNGEUNAQZGZLECGYUXUEENJTBJLBQCRTBJDFHRRYIZETKZEMVDUFKSJHKFWHKUWQLSZFTIHHDDDUVH?DWKBFUFPWNTDFIYCUQZEREEVLDKFEZMOQQJLTTUGSYQPFEUNLAVIDXFLGGTEZ?FKZBSFDQVGOGIPUFXHHDRKFFHQNTGPUAECNUVPDJMQCLQUMUNEDFQELZZVRRGKFFVOEEXBDMVPNFQXEZLGREDNQFMPNZGLFLPMRJQYALMGNUVPDXVKPDQUMEBEDMHDAFMJGZNUPLGEWJLLAETG".lowercased()
    let k3Encryption = "ENDYAHROHNLSRHEOCPTEOIBIDYSHNAIACHTNREYULDSLLSLLNOHSNOSMRWXMNETPRNGATIHNRARPESLNNELEBLPIIACAEWMTWNDITEENRAHCTENEUDRETNHAEOETFOLSEDTIWENHAEIOYTEYQHEENCTAYCREIFTBRSPAMHHEWENATAMATEGYEERLBTEEFOASFIOTUETUAEOTOARMAEERTNRTIBSEDDNIAAHTTMSTEWPIEROAGRIEWFEBAECTDDHILCEIHSITEGOEAOSDDRYDLORITRKLMLEHAGTDHARDPNEOHMGFMFEUHEECDMRIPFEIMEHNLSSTTRTVDOHW".lowercased()
    let k4Encryption = "?OBKRUOXOGHULBSOLIFBBWFLRVQQPRNGKSSOTWTQSJQSSEKZZWATJKLUDIAWINFBNYPVTTMZFPKWGDKZXTJCDIGKUHUAUEKCAR".lowercased()


//    func letterAtIndexPath(_ indexPath: IndexPath ) -> String {
//        let line = self.transcriptDictionaryLetterArray[ (indexPath.row )]!
//        return line[ indexPath.item ]
//    }
//
//    func buildTranscriptionDictionarySeparatingAtInterval(interval: Int) -> [Int : [String]]{
//
//        var transcriptDict = [Int : [String]]()
//
//        var key = 0
//        var idx = 0
//
//        for letter in self.transcript.characters.map({return String($0)}) {
//
//            transcriptDict[key]?.append(letter)
//            idx += 1
//            if (idx % interval == 0){
//                idx = 0
//                key += 1
//            }
//        }
//        return transcriptDict
//    }



