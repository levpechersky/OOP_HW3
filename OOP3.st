Object subclass: #MyObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OOP3'!
!MyObject commentStamp: 'LP 12/2/2017 12:14' prior: 0!
IMPORTANT: 1. Every Interface must inherit from MyObject directly!!    2. Don't add any additional fields!!!


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MyObject class
	instanceVariableNames: 'behavesLike isInterface'!

!MyObject class methodsFor: 'interfaces support' stamp: 'LP 12/2/2017 12:30'!
ambiguities
	! !

!MyObject class methodsFor: 'interfaces support' stamp: 'LP 12/2/2017 12:29'!
behavesLike
	! !

!MyObject class methodsFor: 'interfaces support' stamp: 'LP 12/2/2017 12:39'!
isImplemented
	"Error messages:"
	AssertionFailure signal: '#CLASS is not an interface!!'.
	! !

!MyObject class methodsFor: 'interfaces support' stamp: 'LP 12/2/2017 12:29'!
isInterface
	! !


!MyObject class methodsFor: 'subclass creation' stamp: 'LP 12/2/2017 12:28'!
subclass: aSubclassName instanceVariableNames: instVarNames
classVariableNames: classVarNames poolDictionaries: poolDictionaries
category: aCategoryName

	"create regular object, which isn't an interface or doesn't implement some interface directly"! !

!MyObject class methodsFor: 'subclass creation' stamp: 'LP 12/2/2017 12:38'!
subclass: aSubclassName isInterface: isInterface behavesLike:
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


!MyObject class methodsFor: 'compiling' stamp: 'LP 12/2/2017 12:00'!
compile: aSourceCode where: anOrderedCollection
	"Ordered collection contains type constraints, which arguments must satisfy (isKindOf), or nil's - no constraint"
	"If aSourceCode doesn't receive any arg - anOrderedCollection will be empty"
	
	"Should use ' aSourceCode: argumentsInMethod ' to get args from  aSourceCode"
	
	
	
	"Error messages:"
		"number of constraints !!= number of aSourceCode args:"
		AssertionFailure signal: 'Can not compile method, number of arguments is not equal to the number of constraints!!'
	
		"argument does not satisfy constraint (throw from compiled code):"
		" 'Type mismatch!! Argument #NUMBER should be #CLASS' "
	
	
	
! !


MyObject subclass: #SampleInterface
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OOP3'!
!SampleInterface commentStamp: 'LP 12/2/2017 12:07' prior: 0!
IMPORTANT: Interface can't have any instance vars!


!SampleInterface methodsFor: 'interface-methods' stamp: 'LP 12/2/2017 12:09'!
emptyMethod
	"Empty methods are also legal (they will be overriden)"

! !


!SampleInterface methodsFor: 'default-methods' stamp: 'LP 12/2/2017 12:05'!
defaultMultByTwo: x
	"One integer arg is also legal"
	^ (2*x)! !

!SampleInterface methodsFor: 'default-methods' stamp: 'LP 12/2/2017 12:05'!
defaultRandom
	" 0 args is legal "
	^42
! !
