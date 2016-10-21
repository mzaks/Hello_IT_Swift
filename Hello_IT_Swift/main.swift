//
//  main.swift
//  AsyncBT
//
//  Created by Maxim Zaks on 19.10.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//

import Foundation

extension String : DataType {}


let greeting = ??[GoodMorning(), GoodDay(), GoodEvening(), GoodNight()]

let firstEncounter = =>[Introduction(), AskingForUsersName(), greeting]

let smallTalk = ??[firstEncounter, ResponseToAnnonymousUser()]

let haveYoutriedToTurnItOffAndOn = =>[HaveYoutriedToTurnItOffAndOnAgain(), YesNoQuestion()]

let isItPlugedIn = =>[IsItPlugedIn(), YesNoQuestion()]
let isItPlugedInRepeatedCheck = RepeatOnSuccess(node: isItPlugedIn)

let bye = GoodBye()

let askingForTheProblem = ??[
    =>[WhatIsYoureEmergency(), haveYoutriedToTurnItOffAndOn, isItPlugedInRepeatedCheck
    ], bye]

let conversation = =>[smallTalk, askingForTheProblem]

conversation.execute(data: "") { (_, result) in
    print("Hang up the phone because \(result)")
}

/*
print(conversation.dotNotation)
*/
