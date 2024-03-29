'From Squeak5.1 of 5 September 2016 [latest update: #16549] on 20 December 2017 at 7:58:40 pm'!
Object subclass: #MyObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OOP3'!
!MyObject commentStamp: 'LP 12/2/2017 12:14' prior: 0!
IMPORTANT: 1. Every Interface must inherit from MyObject directly!!    2. Don't add any additional fields!!!


!MyObject methodsFor: 'class membership' stamp: 'AS 12/18/2017 11:12'!
isKindOf: aClassOrInterface
	"New isKindOf method for testing interfaces as well."

	| behaviourSet resClass resInterface |
	resClass := false.
	resClass := false.

	behaviourSet := self class behavesLike.
	resInterface := behaviourSet includes: aClassOrInterface.
	resClass := self class inheritsFrom: aClassOrInterface.
	^(resInterface or: resClass or: (self class = aClassOrInterface))
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MyObject class
	instanceVariableNames: 'behavesLike isInterface'!

!MyObject class methodsFor: 'interfaces support' stamp: 'AS 12/18/2017 11:10'!
allDefaultMethods: aCollection
	"
		Returns a collection (Set) of all method strings in aCollection for compiling.	
	"

	| defaultMethods |
	defaultMethods := Set new.
	aCollection do: [ :interface |
		defaultMethods addAll: (interface allDefaultMethodsOneLevel) ].
	^defaultMethods! !

!MyObject class methodsFor: 'interfaces support' stamp: 'AS 12/18/2017 11:06'!
ambiguities
	"Returns a set of all ambiguities caused by implementing not-mutually-excluded interfaces."
	
	| bag myInterfaces |
	
	bag := Bag new.
	myInterfaces := self behavesLike.

	"Note, that we take only method names: 'methodDict keys' "	
	myInterfaces do: [ :interface | bag addAll: (interface methodDict keys) ].

	"Convertion to set will eliminate duplicates, and conversion to SortedCollection will sort methods by name"
	^ (bag select: [ :method | (bag occurrencesOf: method) > 1 ]) asSet asSortedCollection.! !

!MyObject class methodsFor: 'interfaces support' stamp: 'AS 12/18/2017 11:07'!
behavesLike
	"Returns a collection of all interfaces that this class/interface behaves like."

	| result |
	
	result := Set new.
		
	"Go recursively through superclasses up to  (not including) MyObject"
	"and add their behavesLike interfaces to result"
	result addAll: (self superclassesBehaveLike).
	
	"Go recursively through behavesLike interfaces up to  (not including) MyObject"
	"and add their behavesLike interfaces to result"
	result addAll: (self interfacesBehaveLike).
	
	^result.
	! !

!MyObject class methodsFor: 'interfaces support' stamp: 'AS 12/18/2017 11:16'!
isImplemented
	"Checks if the current interface is implemented in some class that is supposed to implement it."
	| nonInterfaceSubclasses implementors |
	
	self isInterface ifFalse: [ AssertionFailure signal: (self name , ' is not an interface!!') ].

	"Go over all MyObject subclasses (except for interfaces) and look for a subclass, which implements 'self' interface "
	nonInterfaceSubclasses := MyObject allSubclasses reject: [ :aSubClass | aSubClass isInterface ].
	implementors := nonInterfaceSubclasses select: [ :aSubClass | aSubClass implements: self ].

	^(implementors isEmpty) not.
	! !

!MyObject class methodsFor: 'interfaces support' stamp: 'LP 12/11/2017 17:36'!
isInterface
	
	^isInterface.
	! !

!MyObject class methodsFor: 'interfaces support' stamp: 'AS 12/18/2017 11:21'!
new
	"Creates a new object, while aalso checking that this is not an interface or an abstract class."
	
	self isInterface ifTrue: [ AssertionFailure signal: 'Interfaces can not be instantiated!!' ].
	(self implementsInterfaces)
		ifFalse: [ AssertionFailure signal: 'Can not instantiate an Abstract class!!' ].
	^super new.
	! !


!MyObject class methodsFor: 'private' stamp: 'AS 12/18/2017 11:10'!
addAllDefaultMethods: aCollection
	"Adds all default methods from aCollection to the current class/interface."

	| defaultMethodStrings |
	
	defaultMethodStrings := self allDefaultMethods: aCollection.
	defaultMethodStrings do: [ :methodSource |
		self compile: methodSource.
	].! !

!MyObject class methodsFor: 'private' stamp: 'AS 12/18/2017 11:10'!
argumentsInMethod: aSourceCode

	^ (Parser new parse: aSourceCode class: MyObject) arguments collect: [ :each | each name ]! !

!MyObject class methodsFor: 'private' stamp: 'AS 12/18/2017 11:10'!
codeHasLocals: aSourceCode
	"Checks if the message has any local variables."
	| methodLines |
	
	methodLines := aSourceCode findTokens: String cr.
	
	^ (((methodLines size) > 1) and: [ ((methodLines at: 2) findString: '|') > 0 ]).
	
	 ! !

!MyObject class methodsFor: 'private' stamp: 'AS 12/18/2017 11:13'!
getTypeCheckStringForArg: aArgIndex name: aArgName type: aTypeName
	"Returns a string with source code for type check of argument"
	"Note: no new line at the end"
	| errorMessage |
	
	(aTypeName isKindOf: UndefinedObject) 
	ifTrue: [ ^'' ]
	ifFalse: [
		errorMessage := '''Type mismatch!! Argument ' , (aArgIndex asString) , ' should be ' , aTypeName , ''''.
		^ '(' , aArgName , ' isKindOf: ' , aTypeName , ') ifFalse: [ AssertionFailure signal: ' , errorMessage , ' ].'.
	].

	
	 ! !

!MyObject class methodsFor: 'private' stamp: 'LP 12/11/2017 17:35'!
hasOverridenMethod: aSelector
	
	"Stop recursion at MyObject"	
	(self = MyObject) ifTrue: [ ^false ].

	"Go recursively through superclasses up to MyObject, and check if method was overriden"	
	^(self methodDictionary includesKey: aSelector) or: [ self superclass hasOverridenMethod: aSelector ].

	
	 ! !

!MyObject class methodsFor: 'private' stamp: 'AS 12/18/2017 11:14'!
implements: aInterface
	"Checks if the specific class/interface behaves like anInterface"
	| interfaceNonDefaultMethods notOverridenByMe  | 
	
	(self behavesLike includes: aInterface) ifFalse: [ ^false ].
	
	"Go through all non-default methods of aInterface (and all interfaces it behaves like)"
	"and check if 'self' or some of it's superclasses had overriden them"
	interfaceNonDefaultMethods := Set new. 
	aInterface behavesLike do: [ :interface |
		interfaceNonDefaultMethods addAll: (interface methodDictionary keys reject: [ :selector | MyObject methodSelectorIsDefault: selector ]).
	].
	notOverridenByMe := interfaceNonDefaultMethods reject: [ :selector |  self hasOverridenMethod: selector ].
	
	^notOverridenByMe isEmpty.
				
			! !

!MyObject class methodsFor: 'private' stamp: 'AS 12/18/2017 11:14'!
implementsInterfaces
	"Checks if the current class implements all its interfaces."

	| behaviourDict res |
	behaviourDict := self behavesLike.
	res := true.
	behaviourDict do: [ :behaves |
		(behaves isInterface) ifTrue: [
			(self implements: behaves) ifFalse: [ res := false ].
		].
	].
	^res! !

!MyObject class methodsFor: 'private' stamp: 'AS 12/18/2017 11:15'!
interfacesBehaveLike
	"Returns all the interfaces which the current class/interface behaves like."
	| result |
	
	result := Set new. 
	
	(self class = MyObject) ifTrue: [ ^result ].

	"An interface behaves like itself"
	(self isInterface) ifTrue: [ result add: self ]. 
	
	"Transitively, a class behaves like interfaces, which it's interfaces behave like"
	behavesLike do: [ :interface | result addAll: (interface interfacesBehaveLike) ].
	
	^result	 
	
	
	 ! !

!MyObject class methodsFor: 'private' stamp: 'AS 12/18/2017 11:23'!
legalInterfaceMethod: aSourceCode
	"Checks if a given interface method source is legal (i.e. it is empty or default)."
	
	^((MyObject methodIsEmpty: aSourceCode) or: [ MyObject methodIsDefault: aSourceCode ]).
	
	
	
	 ! !

!MyObject class methodsFor: 'private' stamp: 'AS 12/18/2017 11:17'!
methodIsDefault: aSourceCode
	"Checks if the given source is of a default method."
	| linesOfCode selector |
		
	linesOfCode := aSourceCode findTokens: String cr.
	linesOfCode isEmpty ifTrue: [ ^false ].
	selector := linesOfCode at: 1. 
		
	^self methodSelectorIsDefault: selector.
	
	
	
	 ! !

!MyObject class methodsFor: 'private' stamp: 'AS 12/18/2017 11:18'!
methodIsEmpty: aSourceCode
	"Checks if the given method is empty or not."
	| linesOfCode |

	linesOfCode := aSourceCode findTokens: String cr.

	^ linesOfCode size = 1.

	
	 ! !

!MyObject class methodsFor: 'private' stamp: 'AS 12/18/2017 11:18'!
methodSelectorIsDefault: aSelector
	"Checks if the selector describes a default method."
	| prefix |
	
	prefix := 'default'.
	
	^(aSelector size >= prefix size) and: [ (aSelector copyFrom: 1 to: (prefix size)) = prefix ].
	
	
	
	 ! !

!MyObject class methodsFor: 'private' stamp: 'AS 12/18/2017 11:23'!
superclassesBehaveLike
	"Returns a collection of all thee classes this class behaves like."
	| result |
	
	result := Set new. 
	
	self = MyObject ifTrue: [ ^result ].

	"Note, that behavesLike runs on superclass recursively"
	result addAll: (self superclass behavesLike). 

	^result	 

	
	
	 ! !


!MyObject class methodsFor: 'subclass creation' stamp: 'LP 12/10/2017 17:17'!
subclass: aSubclassName instanceVariableNames: instVarNames
classVariableNames: classVarNames poolDictionaries: poolDictionaries
category: aCategoryName
	| newClass | 
	
	"Errors:"
	(self isInterface) ifTrue: [
		AssertionFailure signal: 'Classes can not derive from an interface!!'.
	].
	
	"It's important to create subclass using 'super', otherwise it will cause infinite loop"
	newClass := super subclass: aSubclassName instanceVariableNames: instVarNames
classVariableNames: classVarNames poolDictionaries: poolDictionaries
category: aCategoryName.
	
	newClass instVarNamed: 'isInterface' put: false.
	newClass instVarNamed: 'behavesLike' put: (OrderedCollection new).
		
	^newClass
	! !

!MyObject class methodsFor: 'subclass creation' stamp: 'AS 12/18/2017 11:22'!
subclass: aSubclassName isInterface: isInterface behavesLike:
aCollection instanceVariableNames: instVarNames classVariableNames:
classVarNames poolDictionaries: poolDictionaries category:
aCategoryName
	| newClass | 
	
	"Errors:"
	(isInterface and: [ (self isMemberOf: MyObject class) not ]) ifTrue: [
		AssertionFailure signal: 'Interfaces must derive from MyObject!!'.
	].
	(isInterface and: [ instVarNames isEmpty not ]) ifTrue: [
		AssertionFailure signal: 'Interfaces can not have state!!'.
	].
	(self isInterface) ifTrue: [
		AssertionFailure signal: 'Classes can not derive from an interface!!'.
	].
	"Check if there's any element x in aCollection s.t. x isn't an interface"
	((aCollection reject:  [ :x | x isInterface ]) isEmpty) ifFalse: [
		AssertionFailure signal: 'Can not behave like a non-interface!!'.
	].
	
	newClass := self subclass: aSubclassName instanceVariableNames: instVarNames
		classVariableNames: classVarNames poolDictionaries: poolDictionaries
		category: aCategoryName.
	
	newClass instVarNamed: 'isInterface' put: isInterface.
	newClass instVarNamed: 'behavesLike' put: aCollection.

	"Add all the default methods this class/interface should include."
	newClass addAllDefaultMethods: aCollection.
	
	 ^newClass
	! !


!MyObject class methodsFor: 'compiling' stamp: 'LP 12/11/2017 17:37'!
compile: aSourceCode 
	
	(self isInterface and: [(MyObject legalInterfaceMethod: aSourceCode) not ]) ifTrue: [
		AssertionFailure signal: 'Interfaces are not allowed to have non default methods that define behavior!!'
	].
		
	^super compile: aSourceCode.



	
! !

!MyObject class methodsFor: 'compiling' stamp: 'AS 12/18/2017 11:11'!
compile: aSourceCode where: anOrderedCollection
	"Ordered collection contains type constraints, which arguments must satisfy (isKindOf), or nil's - no constraint"
	"If aSourceCode doesn't receive any arg - anOrderedCollection will be empty"
	
	"
		Method logic:
		Split source code into lines, take first one/two into new list.
		Go over arguments, add a check line into new list for each param.
		Take the rest of the method source lines, and compile.
	"
	| methodLines methodArgs injectStart typesIndex checkString checkedLines numLines outputSource |
	
	methodLines := aSourceCode findTokens: String cr.
	
	checkedLines := OrderedCollection new.
	"Put selector and args:"
	checkedLines addLast: (methodLines at: 1). 
	 "Put locals:"
	(MyObject codeHasLocals: aSourceCode) ifTrue: [ checkedLines addLast: (methodLines at: 2) ].
	
	methodArgs := MyObject argumentsInMethod: aSourceCode.
	(methodArgs size = anOrderedCollection size)
		ifFalse: [ AssertionFailure signal: 'Can not compile method, number of arguments is not equal to the number of constraints!!' ].
		
	"Add type-check strings to list of source code."
	typesIndex := 1.
	methodArgs do: [ :methodArg | 
	checkString := MyObject getTypeCheckStringForArg: typesIndex name: methodArg type: (anOrderedCollection at: typesIndex).
		checkedLines addLast: (checkString).
		typesIndex := typesIndex + 1.
	].

	"Add the rest of the lines to the list of all lines."
	(MyObject codeHasLocals: aSourceCode) ifTrue: [injectStart:=3] ifFalse: [injectStart:=2].
	numLines := methodLines size.
	injectStart to: numLines do:
		[ :index | checkedLines addLast: (methodLines at: index) ].
	
	"Create final string:"
	outputSource := ''.
	checkedLines do:  [ :line | outputSource := outputSource , line, String cr. ].
	
	"Add new method to receiver class:"
	^self compile: outputSource.


	
! !


!MyObject class methodsFor: 'as yet unclassified' stamp: 'AS 12/18/2017 11:10'!
allDefaultMethodsOneLevel
	"Gets all default method string from the specific interface only."

	| defaultMethods |
	defaultMethods := Set new.
	(self isInterface) ifTrue: [
		self methodDict do: [ :method |
			(self methodIsDefault: (method getSource asString)) ifTrue: [ defaultMethods add: (method getSource asString). ]. 
		].
	].
	^defaultMethods! !
