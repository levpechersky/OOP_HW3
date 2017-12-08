'From Squeak5.1 of 5 September 2016 [latest update: #16549] on 8 December 2017 at 10:47:05 pm'!Object subclass: #MyObject	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: 'OOP3'!!MyObject commentStamp: 'LP 12/2/2017 12:14' prior: 0!IMPORTANT: 1. Every Interface must inherit from MyObject directly!!    2. Don't add any additional fields!!!!MyObject methodsFor: 'as yet unclassified' stamp: 'AS 12/8/2017 22:38'!compile: aSourceCode where: anOrderedCollection	"		Method logic:		Split source code into lines, take first one/two into new list.		Go over arguments, add a check line into new list for each param.		Take the rest of the method source lines, and compile.	"	| methodLines string1 string2 string3 methodArgs injectStart typesIndex checkString checkedLines numLines outputSource |	string1 := '( '.	string2 := ' isKindOf: '.	string3 := ' ) ifFalse [ AssertionFailure signal: ''Type Mismatch!!''. ]'.	methodLines := aSourceCode findTokens: String cr, String lf.	checkedLines := OrderedCollection new.	"First check if there are local variables or not."	(((methodLines at: 1) findString: $|) > 0)		ifTrue: [injectStart := 2]		ifFalse: [injectStart := 1].	checkedLines addLast: (methodLines at: 0).	(injectStart = 1) ifTrue: [checkedLines addLast: (methodLines at: 1)].	methodArgs := #(). "argumentsInMethod aSourceCode."	(methodArgs size == anOrderedCollection size)		ifFalse: [AssertionFailure signal: 'Num of args different.'].	typesIndex := 0.	"Add type-check strings to list of source code."	methodArgs do: [:methodArg | 		checkString := string1 		+ (methodArg asString) + string2		+ (anOrderedCollection at: typesIndex name) + string3.		checkedLines addLast: checkString.		typesIndex := typesIndex + 1.	].	"	Add the rest of the lines to the list of all lines.	Might seem a little unneeded, but we'd need 2 loops anyways.	"	numLines := anOrderedCollection size.	injectStart to: numLines do:		[: index | checkedLines addLast: (anOrderedCollection at: index)].	outputSource := ''.	"Finally, create final string with cr and lf."	checkedLines do:		[:line | outputSource = outputSource + line + String cr + String lf.].	^outputSource! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!MyObject class	instanceVariableNames: 'behavesLike isInterface'!!MyObject class methodsFor: 'interfaces support' stamp: 'LP 12/2/2017 12:30'!ambiguities
	! !!MyObject class methodsFor: 'interfaces support' stamp: 'LP 12/2/2017 12:29'!behavesLike
	! !!MyObject class methodsFor: 'interfaces support' stamp: 'LP 12/2/2017 12:39'!isImplemented
	"Error messages:"
	AssertionFailure signal: '#CLASS is not an interface!!'.
	! !!MyObject class methodsFor: 'interfaces support' stamp: 'LP 12/2/2017 12:29'!isInterface
	! !!MyObject class methodsFor: 'subclass creation' stamp: 'LP 12/2/2017 12:28'!subclass: aSubclassName instanceVariableNames: instVarNames
classVariableNames: classVarNames poolDictionaries: poolDictionaries
category: aCategoryName

	"create regular object, which isn't an interface or doesn't implement some interface directly"! !!MyObject class methodsFor: 'subclass creation' stamp: 'LP 12/2/2017 12:38'!subclass: aSubclassName isInterface: isInterface behavesLike:
aCollection instanceVariableNames: instVarNames classVariableNames:
classVarNames poolDictionaries: poolDictionaries category:
aCategoryName

	" like 'Class' class 'subclass' method "
	" Can use instVarNamed:put: for initialization of variables "
	
	"Error messages (must be defined in that order):"
	AssertionFailure signal: 'Interfaces must derive from MyObject!!'.
	AssertionFailure signal: 'Interfaces can not have state!!'.
	AssertionFailure signal: 'Classes can not derive from an interface!!'.
	AssertionFailure signal: 'Can not behave like a non-interface!!'.! !!MyObject class methodsFor: 'compiling' stamp: 'LP 12/2/2017 12:00'!compile: aSourceCode where: anOrderedCollection
	"Ordered collection contains type constraints, which arguments must satisfy (isKindOf), or nil's - no constraint"
	"If aSourceCode doesn't receive any arg - anOrderedCollection will be empty"
	
	"Should use ' aSourceCode: argumentsInMethod ' to get args from  aSourceCode"
	
	
	
	"Error messages:"
		"number of constraints !!= number of aSourceCode args:"
		AssertionFailure signal: 'Can not compile method, number of arguments is not equal to the number of constraints!!'
	
		"argument does not satisfy constraint (throw from compiled code):"
		" 'Type mismatch!! Argument #NUMBER should be #CLASS' "
	
	
	
! !