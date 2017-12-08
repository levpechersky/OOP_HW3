'From Squeak5.1 of 5 September 2016 [latest update: #16549] on 8 December 2017 at 10:47:05 pm'!
	! !
	! !
	"Error messages:"
	AssertionFailure signal: '#CLASS is not an interface!!'.
	! !
	! !
classVariableNames: classVarNames poolDictionaries: poolDictionaries
category: aCategoryName

	"create regular object, which isn't an interface or doesn't implement some interface directly"! !
aCollection instanceVariableNames: instVarNames classVariableNames:
classVarNames poolDictionaries: poolDictionaries category:
aCategoryName

	" like 'Class' class 'subclass' method "
	" Can use instVarNamed:put: for initialization of variables "
	
	"Error messages (must be defined in that order):"
	AssertionFailure signal: 'Interfaces must derive from MyObject!!'.
	AssertionFailure signal: 'Interfaces can not have state!!'.
	AssertionFailure signal: 'Classes can not derive from an interface!!'.
	AssertionFailure signal: 'Can not behave like a non-interface!!'.! !
	"Ordered collection contains type constraints, which arguments must satisfy (isKindOf), or nil's - no constraint"
	"If aSourceCode doesn't receive any arg - anOrderedCollection will be empty"
	
	"Should use ' aSourceCode: argumentsInMethod ' to get args from  aSourceCode"
	
	
	
	"Error messages:"
		"number of constraints !!= number of aSourceCode args:"
		AssertionFailure signal: 'Can not compile method, number of arguments is not equal to the number of constraints!!'
	
		"argument does not satisfy constraint (throw from compiled code):"
		" 'Type mismatch!! Argument #NUMBER should be #CLASS' "
	
	
	
! !