+++
date = "2004-01-01T21:49:10+01:00"
draft = false
description = "Projects and homeworks, mostly kept just for historical reasons"
keywords = ["voice recognition"]
title = "Course related programs (pre 2005)"
type = "post"
+++

##### Mem game with voice recognition
 A game using speech recognition for my multimedia course project. You will need to download Microsoft Speech Recognition engine, not needed if you have Windows XP SP2 or above.
 [Link](Mem.zip)

##### Calculator
An advanced calculator, better say an advanced expression evaluator. It has a lexical analyzer, parser and symbol table in order to evaluate expressions and preserve the results. For example give it the following expressions and see the results:

[Link](Calc.zip)

    $ 100*(1/2+5)
    line 1 value: 550.000000

    $ 1+/2
    SHIFT 7
    REDUCTION 13
    REDUCTION 7
    REDUCTION 4
    SHIFT 11
    Parser: Parse error at line 1(no such transition).

    $ asd=120
    $ p2=98
    $ oo=asd*p2
    $ oo
    SHIFT 1
    SHIFT 10
    SHIFT 7
    REDUCTION 13
    REDUCTION 7
    .
    .
    .
    REDUCTION 7
    REDUCTION 4
    REDUCTION 1
    line 4 value: 11760.000000

    Symbol Table Contents:
    asd                  ID              120.000000
    p2                   ID              98.000000
    oo                   ID              11760.000000



##### Roman Calculator
 A roman calculator to calculate expressions of roman numbers.
[Link](RomanCalc.zip)


##### Registration in B
Registeration process designed using a formal method, in B specification langauage.
[Link](REGISTRATION.zip)
