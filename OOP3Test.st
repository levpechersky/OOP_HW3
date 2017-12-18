'From Squeak5.1 of 5 September 2016 [latest update: #16549] on 18 December 2017 at 11:35:53 am'!
TestCase subclass: #OOP3Test
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OOP3-Tests'!

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'LP 12/10/2017 19:08'!
expectErrorFrom: aBlock withErrMessage: aMessage
	self should: aBlock raise: AssertionFailure  withExceptionDo:  [:e | self assert: (e messageText = aMessage) ]. 
	
	
! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'AS 12/15/2017 23:14'!
setUp
MyObject instVarNamed: 'isInterface' put: false.
MyObject instVarNamed: 'behavesLike' put: {}.

"Add here any additional identifier, you are going to use for class/interface name:"
(Smalltalk hasClassNamed: #A) ifTrue: [Smalltalk removeClassNamed: #A].
(Smalltalk hasClassNamed: #B) ifTrue: [Smalltalk removeClassNamed: #B].
(Smalltalk hasClassNamed: #C) ifTrue: [Smalltalk removeClassNamed: #C].
(Smalltalk hasClassNamed: #D) ifTrue: [Smalltalk removeClassNamed: #D].
(Smalltalk hasClassNamed: #E) ifTrue: [Smalltalk removeClassNamed: #E].
(Smalltalk hasClassNamed: #CD) ifTrue: [Smalltalk removeClassNamed: #CD].
(Smalltalk hasClassNamed: #AA) ifTrue: [Smalltalk removeClassNamed: #AA].
(Smalltalk hasClassNamed: #AB) ifTrue: [Smalltalk removeClassNamed: #AB].
(Smalltalk hasClassNamed: #BAA) ifTrue: [Smalltalk removeClassNamed: #BAA].
(Smalltalk hasClassNamed: #BAB) ifTrue: [Smalltalk removeClassNamed: #BAB].
(Smalltalk hasClassNamed: #X) ifTrue: [Smalltalk removeClassNamed: #X].
(Smalltalk hasClassNamed: #Y) ifTrue: [Smalltalk removeClassNamed: #Y].
(Smalltalk hasClassNamed: #Z) ifTrue: [Smalltalk removeClassNamed: #Z].
(Smalltalk hasClassNamed: #W) ifTrue: [Smalltalk removeClassNamed: #W].
(Smalltalk hasClassNamed: #V) ifTrue: [Smalltalk removeClassNamed: #V].

(Smalltalk hasClassNamed: #IA) ifTrue: [Smalltalk removeClassNamed: #IA].
(Smalltalk hasClassNamed: #IB) ifTrue: [Smalltalk removeClassNamed: #IB].
(Smalltalk hasClassNamed: #IC) ifTrue: [Smalltalk removeClassNamed: #IC].
(Smalltalk hasClassNamed: #ID) ifTrue: [Smalltalk removeClassNamed: #ID].
(Smalltalk hasClassNamed: #IE) ifTrue: [Smalltalk removeClassNamed: #IE].
(Smalltalk hasClassNamed: #IF) ifTrue: [Smalltalk removeClassNamed: #IF].! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'AS 12/16/2017 15:27'!
testAbstractInstantiation
	"Tests that instantiaion of an Abstract class is not possible."

	| ba cd e f |
MyObject subclass: #IA isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IA compile: 'foo'.
IA compile: 'bar: arg'.
MyObject subclass: #B isInterface: false behavesLike: {IA} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	self should: [ ba := B new. ] raise: AssertionFailure.
B compile:
'foo
| local1 |
local1 := 4.
^local1' where: #().
	self should: [ ba := B new. ] raise: AssertionFailure.
B compile:
'bar: arg
^(arg + 3)' where: #(Number).
	self shouldnt: [ba := B new] raise: AssertionFailure.

MyObject subclass: #IC isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IC compile: 'foo: arg'.
IC compile: 'bar: arg'.

MyObject subclass: #ID isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
ID compile: 'foobar: a arg2: b'.

MyObject subclass: #CD isInterface: false behavesLike: {IC . ID} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.

	self should: [ cd := CD new. ] raise: AssertionFailure.
CD compile:
'foo: arg
^(arg+3)' where: #(Number).
CD compile:
'bar: arg
^(arg , ''World!!'')' where: #(String).
	self should: [ cd := CD new. ] raise: AssertionFailure.
CD compile:
'foobar: a arg2: b
^(a + b)' where: #(Integer Integer).
	self shouldnt: [ cd := CD new. ] raise: AssertionFailure.
	self assert: ((cd foo: 4) = 7).
	self assert: ((cd bar: 'Hello, ') = 'Hello, World!!').
	self assert: ((cd foobar: 5 arg2: 19) = 24).

MyObject subclass: #E isInterface: false behavesLike: {ID} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
E subclass: #F isInterface: false behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	
	self should: [ e := E new. ] raise: AssertionFailure.
	self should: [ f := F new. ] raise: AssertionFailure.

E compile:
'foobar: a arg2: b
	^(a + b)' where: #(Integer Integer).
	
	self shouldnt: [ e := E new. ] raise: AssertionFailure.
	self shouldnt: [ f := F new. ] raise: AssertionFailure.
! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'AS 12/15/2017 23:17'!
testAmbiguities
	"Tests ambiguities between methods inehrited across interfaces."

	| amb1 amb2 amb3 amb4 amb5 res |
		
MyObject subclass: #IA isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IA compile: 'foo0'.
IA compile: 'foo1'.
IA compile: 'foo2'.
	
MyObject subclass: #IB isInterface: true behavesLike: {IA} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IB compile: 'foo1'.
IB compile: 'foo1: a arg2: b arg3: c'.
IB compile: 'foo3'.

MyObject subclass: #IC isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IC compile: 'foo1: a arg2: b arg3: c'.
IC compile: 'foo3'.

MyObject subclass: #ID isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
ID compile: 'foo2'.
ID compile: 'foo2: arg'.
ID compile: 'foo4'.

MyObject subclass: #A isInterface: false behavesLike: {IA . IB} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	amb1 := A ambiguities.
	
	self assert: (A behavesLike = {IA . IB} asSet).
	self assert: (amb1 size = 1).

MyObject subclass: #B isInterface: false behavesLike: {IA . IB . IC} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.

	amb2 := B ambiguities.
	self assert: (B behavesLike = {IA . IB . IC} asSet).
	self assert: (amb2 size = 3).
	
B subclass: #C isInterface: false  behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	
	amb3 := C ambiguities.
	self assert: (C behavesLike = {IA . IB . IC} asSet).
	self assert: (amb2 size = amb3 size).

C subclass: #D isInterface: false  behavesLike: {ID} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	amb4 := D ambiguities.
	self assert: (D behavesLike = {IA . IB . IC . ID} asSet).
	self assert: (amb4 size = 4).
	
MyObject subclass: #IE isInterface: true behavesLike: {IB . IC . ID} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	res := {} asSet.
	IE behavesLike do: [:value | res add: value name].
	self assert: (IE behavesLike = {IA . IB . IC . ID . IE} asSet).

MyObject subclass: #IF isInterface: true behavesLike: {IE} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	self assert: (IF behavesLike = {IA . IB . IC . ID . IE . IF} asSet).
	IF compile: 'foo0: arg'.

D subclass: #E isInterface: false  behavesLike: {IF} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	amb5 := E ambiguities.
	self assert: (E behavesLike = IF behavesLike).
	self assert: (amb5 size = 4).
	IF compile: 'foo0'.
	amb5 := E ambiguities.
	self assert: (amb5 size = 5).



	

! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'LP 12/11/2017 19:04'!
testAmbiguitiesBasic
| tmp |

"1. Simple case: 2 interfaces, implemented directly, no default methods"

MyObject subclass: #IA isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IA compile: 'ambiguousFoo'.
IA compile: 'ambiguousBar'.
IA compile: 'ambiguousBaz'.
IA compile: 'foo'.
IA compile: 'bar'.

MyObject subclass: #IB isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IB compile: 'ambiguousFoo'.
IB compile: 'ambiguousBar'.
IB compile: 'ambiguousBaz'.
IB compile: 'baz'.
IB compile: 'example'.

MyObject subclass: #A isInterface: false behavesLike: {IA . IB} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
tmp := A ambiguities.	
self assert: (A ambiguities asOrderedCollection = (#(#ambiguousBar #ambiguousBaz #ambiguousFoo) asOrderedCollection)).


"TODO: add more tests"
	

! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'LP 12/11/2017 16:56'!
testBehavesLikeRecursive
| newClass tmp |

"1. Every interface behaves like itself:"
newClass := MyObject subclass: #IA isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
self assert: (IA behavesLike = {IA} asSet).


"2. Class behaves like an interface IX, if that class was defined with behavesLike {IX}"
newClass := MyObject subclass: #A isInterface: false behavesLike: {IA} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
self assert: (A behavesLike = {IA} asSet).


"3. Class behaves like IX, if it behaves like IY, which behaves like IX"
newClass := MyObject subclass: #IB isInterface: true behavesLike: {IA} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
newClass := MyObject subclass: #B isInterface: false behavesLike: {IB} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
tmp := B behavesLike.
self assert: (B behavesLike = {IA . IB} asSet).



"4. Class behaves like IX, if it is subclass of Y, which behaves like IX"

"Simple case: D is a child of A, which behaves like IA"
A subclass: #D isInterface: false behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
tmp := D behavesLike.
self assert: (D behavesLike = {IA} asSet).

"More compicated case: C is a child of B. B behaves like IB, which behaves like IA"
B subclass: #C isInterface: false behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
tmp := C behavesLike.
self assert: (C behavesLike = {IA . IB} asSet).



"5. Check return value:"
self assert: (IA behavesLike isKindOf: Set).
self assert: (A  behavesLike isKindOf: Set).
self assert: (C  behavesLike isKindOf: Set).


! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'LP 12/11/2017 20:02'!
testCompileInterfaceMethods
| defaultMethod emptyMethod nonEmptyMethod |

MyObject subclass: #IA isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.


nonEmptyMethod := 'illegalFoo: aArg
| localVar | 
^ localVar = aArg
'.
self expectErrorFrom: [ IA compile: nonEmptyMethod. ] 
withErrMessage: 'Interfaces are not allowed to have non default methods that define behavior!!'.




emptyMethod := 'emptyBar'. 
IA compile: emptyMethod.
self assert: (IA methodDict size = 1).

" Note a new line at the end of method. Should be OK, I think: "
emptyMethod := 'emptyFoo: arg0  bar: arg1
'. 
IA compile: emptyMethod.
self assert: (IA methodDict size = 2).




defaultMethod := 'defaultFoo: aNumber
| someLocalVar | 
someLocalVar := 300.
" a comment "
^aNumber + someLocalVar. '.

IA compile: defaultMethod. 
self assert: (IA methodDict size = 3).
" But we still can't check compiled method until part C is implemented :( "






! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'LP 12/10/2017 19:44'!
testCompileWhere
| a result message | 

MyObject subclass: #A instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.



"Initial state:"
self assert: (A methodDict isEmpty).
self assert: (A isInterface = false).
self assert: (A behavesLike isEmpty).



"compiling the new way: number of arguments !!= number of constraints"
message := 'Can not compile method, number of arguments is not equal to the number of constraints!!'.
self expectErrorFrom: [ A compile: 'foo: a' where: {} ] withErrMessage: message.
self expectErrorFrom: [ A compile: 'foo: a' where: #(Integer String nil) ] withErrMessage: message.
self expectErrorFrom: [ A compile: 'foo: a bar: b' where: #(nil) ] withErrMessage: message.
self assert: (A methodDict isEmpty).   "Error cases shouldn't add methods"


a := A new.


"compiling the old way"
A compile:
'mOldNoArgs
^42'.
self assert: (A methodDict size = 1).
result := a mOldNoArgs.
self assert: (result = 42).



"compiling the new way:"
A compile:
'mNewInteger: a
^a' where: #(Integer).
self assert: (A methodDict size = 2).

message := 'Type mismatch!! Argument 1 should be Integer'.
self expectErrorFrom: [ a mNewInteger: 'NaN' ] withErrMessage: message.
self expectErrorFrom: [ a mNewInteger: 0.5   ] withErrMessage: message.

result := a mNewInteger: 1.
self assert: (result = 1).



"compiling the new way: with locals, no args"
A compile:
'mNewNoArgs
| localVar |
localVar := 42.
^localVar' where: {}.

result := a mNewNoArgs.
self assert: (result = 42).



"compiling the new way: multiple args, with nil constraint"
A compile:
'mNewManyArgsWithNil: a arg1: b arg2: c
| localVar |
localVar := 2.
^localVar * a * b * c' where: #(Integer Number nil).

self expectErrorFrom: [ a mNewManyArgsWithNil: 0.1 arg1: 4.0    arg2: 5 ] withErrMessage: 'Type mismatch!! Argument 1 should be Integer'.
self expectErrorFrom: [ a mNewManyArgsWithNil: 3    arg1: 'NaN' arg2: 5 ] withErrMessage: 'Type mismatch!! Argument 2 should be Number'.

result := a mNewManyArgsWithNil: 3 arg1: 4.0 arg2: 5.      
self assert: (result = (2*3*4.0*5)).

result := a mNewManyArgsWithNil: 3 arg1: 4.0 arg2: 10.0.      
self assert: (result = (2*3*4.0*10.0)).

! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'AS 12/16/2017 19:07'!
testDefaultInterfaceMethods
	"comment stating purpose of message"

	| a b c d e f |

MyObject subclass: #IA isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IA compile:
'defaultFoo
	^42'.

MyObject subclass: #IB isInterface: true behavesLike: {IA} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IB compile:
'defaultBar
	^''Hello, '''.

MyObject subclass: #IC isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IC compile:
'defaultBaz
	^''World!!'''.


MyObject subclass: #A isInterface: false behavesLike: {IA} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #B isInterface: false behavesLike: {IB} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #C isInterface: false behavesLike: {IB . IC} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.

	a := A new.	
	b := B new.
	c := C new.
	
	self assert: (a isKindOf: IA).
	self assert: (a defaultFoo = 42).
	
	self assert: (b isKindOf: IA).
	self assert: (b isKindOf: IB).
	self assert: (b defaultFoo = 42).
	self assert: (b defaultBar = 'Hello, ').
	
	self assert: (c isKindOf: IA).
	self assert: (c isKindOf: IB).
	self assert: (c isKindOf: IC).
	self assert: (c defaultFoo = 42).
	self assert: (c defaultBar = 'Hello, ').
	self assert: (((c defaultBar) , (c defaultBaz)) = 'Hello, World!!').

MyObject subclass: #ID isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
ID compile:
'defaultDoD
	^67'.

MyObject subclass: #IE isInterface: true behavesLike: {ID} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IE compile:
'defaultDoE
	^''Doing E'''.
IE compile: 'fooBar: a'.

MyObject subclass: #IF isInterface: true behavesLike: {IE} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IF compile:
'defaultDoF
	^''I am doing F'''.
	
MyObject subclass: #D isInterface: false behavesLike: {IB . IC . IF} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
D compile:
'foo: a
	| local1 |
	local1 := self defaultDoD.
	^(a + local1)' where: #(Number).

D subclass: #E isInterface: false behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
E subclass: #F isInterface: false behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.

	self should: [ d := D new. ] raise: AssertionFailure.
	self should: [ e := E new. ] raise: AssertionFailure.
	self should: [ f := F new. ] raise: AssertionFailure.

D compile:
'fooBar: a
	^(a + 1)' where: #(Integer).
	
	self shouldnt: [ d := D new. ] raise: AssertionFailure.
	self shouldnt: [ e := E new. ] raise: AssertionFailure.
	self shouldnt: [ f := F new. ] raise: AssertionFailure.
	
	self assert: (d isKindOf: IA).
	self assert: (d isKindOf: IB).
	self assert: (d isKindOf: IC).
	self assert: (d isKindOf: ID).
	self assert: (d isKindOf: IE).
	self assert: (d isKindOf: IF).
	self assert: (d defaultFoo = 42).
	self assert: (d defaultBar = 'Hello, ').
	self assert: (((d defaultBar) , (d defaultBaz)) = 'Hello, World!!').
	self assert: (d defaultDoD = 67).
	self assert: (d defaultDoE = 'Doing E').
	self assert: (d defaultDoF = 'I am doing F').
	self assert: ((d fooBar: 5) = 6).
	self assert: ((d foo: 4) = 71).
	
	self assert: (e isKindOf: IA).
	self assert: (e isKindOf: IB).
	self assert: (e isKindOf: IC).
	self assert: (e isKindOf: ID).
	self assert: (e isKindOf: IE).
	self assert: (e isKindOf: IF).
	self assert: (e isKindOf: D).
	self assert: (e isKindOf: E).
	self assert: (e defaultFoo = 42).
	self assert: (e defaultBar = 'Hello, ').
	self assert: (((e defaultBar) , (e defaultBaz)) = 'Hello, World!!').
	self assert: (e defaultDoD = 67).
	self assert: (e defaultDoE = 'Doing E').
	self assert: (e defaultDoF = 'I am doing F').
	self assert: ((e fooBar: 5) = 6).
	self assert: ((e foo: 4) = 71).
	
	self assert: (f defaultFoo = 42).
	self assert: (f defaultBar = 'Hello, ').
	self assert: (((f defaultBar) , (f defaultBaz)) = 'Hello, World!!').
	self assert: (f defaultDoD = 67).
	self assert: (f defaultDoE = 'Doing E').
	self assert: (f defaultDoF = 'I am doing F').
	self assert: ((f fooBar: 5) = 6).
	self assert: ((f foo: 4) = 71).
	! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'AS 12/16/2017 20:11'!
testDefaultLongInheritance
	"comment stating purpose of message"

	| x y z |
MyObject subclass: #IA isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IA compile: 
'defaultA
	^''A'''.
IA compile: 'fooA: a'.

MyObject subclass: #IB isInterface: true behavesLike: {IA} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IB compile: 
'defaultB
	^''B'''.
IB compile: 'fooB'.
	
MyObject subclass: #IC isInterface: true behavesLike: {IB} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IC compile: 
'defaultC
	^42'.
	
MyObject subclass: #ID isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
ID compile: 'fooD'.
	
MyObject subclass: #IE isInterface: true behavesLike: {ID} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IE compile:
'defaultE
	^''EEE'''.
	
MyObject subclass: #IF isInterface: true behavesLike: {IE} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IF compile: 'flooF'.
IF compile:
'defaultF
	^420'.
	
MyObject subclass: #X isInterface: false behavesLike: {IC} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.

	self should: [ x := X new.] raise: AssertionFailure.
X compile: 
'fooA: a
	^(a + 3)' where: #(Number).
	self should: [ x := X new.] raise: AssertionFailure.
X compile:
'fooB
	^7' where: #().
	self shouldnt: [ x := X new.] raise: AssertionFailure.
	self assert: (x isKindOf: X).
	self assert: (x isKindOf: IA).
	self assert: (x isKindOf: IB).
	self assert: (x isKindOf: IC).
	self assert: ((x fooA: 2) = 5).
	self assert: (x defaultA = 'A').
	self assert: (x fooB = 7).
	self assert: (x defaultB = 'B').
	self assert: (x defaultC = 42).
	
MyObject subclass: #Y isInterface: false behavesLike: {IF} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	
	self should: [ y := Y new. ] raise: AssertionFailure.
Y compile:
'fooD
	^''Food'''.
	self should: [ y := Y new. ] raise: AssertionFailure.
Y compile:
'flooF
	^''floof'''.
	self shouldnt: [ y := Y new. ] raise: AssertionFailure.
	self assert: (y isKindOf: ID).
	self assert: (y isKindOf: IE).
	self assert: (y isKindOf: IF).
	self assert: (y isKindOf: Y).
	self assert: (y fooD = 'Food').
	self assert: (y defaultE = 'EEE').
	self assert: (y flooF = 'floof').
	
MyObject subclass: #Z isInterface: false behavesLike: {IC . IF} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	self should: [ z := Z new. ] raise: AssertionFailure.

Z compile:
'fooA: a
	^(a , ''A'')' where: #(String).
	self should: [ z := Z new. ] raise: AssertionFailure.

Z compile:
'fooB
	^''fooB'''.
	self should: [ z := Z new. ] raise: AssertionFailure.
	
Z compile:
'fooD
	^''FOOd'''.
	self should: [ z := Z new. ] raise: AssertionFailure.

Z compile:
'flooF
	^''FLOOF'''.
	self shouldnt: [ z := Z new. ] raise: AssertionFailure.
	
	self assert: (z isKindOf: Z).
	self assert: (z isKindOf: IA).
	self assert: (z isKindOf: IB).
	self assert: (z isKindOf: IC).
	self assert: (z isKindOf: ID).
	self assert: (z isKindOf: IE).
	self assert: (z isKindOf: IF).
	self assert: (z defaultA = 'A').
	self assert: ((z fooA: 'A') = 'AA').
	self assert: (z fooB = 'fooB').
	self assert: (z defaultC = 42).
	self assert: (z fooD = 'FOOd').
	self assert: (z defaultE = 'EEE').
	self assert: (z flooF = 'FLOOF').
	self assert: (z defaultF = 420).	! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'LP 12/11/2017 20:05'!
testInterfaceCantHaveInstance

MyObject subclass: #IA isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	
self expectErrorFrom: [ 	IA new ] withErrMessage: 'Interfaces can not be instantiated!!'.

! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'LP 12/11/2017 20:07'!
testIsImplementedNoMethods
| newClass |

" 2 interfaces: IB extends IA "
newClass := MyObject subclass: #IA isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
newClass := MyObject subclass: #IB isInterface: true behavesLike: {IA} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.


"If interface IB behaves like IA - IA still isn't implemented"
self assert: (IA isImplemented = false).


newClass := MyObject subclass: #A isInterface: false behavesLike: {IB} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
"IB implemented directly by A"
self assert: (IB isImplemented = true).
"IA is implemented by A through IB"
self assert: (IA isImplemented = true).


"You can't send 'isImplemented' to a regular class:"
self expectErrorFrom: [ A isImplemented ] withErrMessage: 'A is not an interface!!'.
! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'AS 12/15/2017 00:06'!
testIsImplementedWithMethods

	| a b cd1 res1 res2 e |

MyObject subclass: #IA isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #IB isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #IC isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #ID isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.

IA compile: 'fooA: arg'.
IB compile: 'fooB'.
IC compile: 'fooC: a arg2: b arg3: c'.
ID compile: 'fooD'.

MyObject subclass: #A isInterface: false behavesLike: {IA} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	self assert: (A behavesLike = {IA} asSet).
	
MyObject subclass: #B isInterface: false behavesLike: {IB} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	self assert: (B behavesLike = {IB} asSet).
	
MyObject subclass: #CD isInterface: false behavesLike: {IC . ID} instanceVariableNames: 'x' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	self assert: (CD behavesLike = {IC . ID} asSet).

A compile:
'fooA: arg
| |
^(arg*2)' where: #(Number).
	a := A new.
	self assert: (A methodDict size = 1).
	self assert: ((a fooA: 6) = 12).
	self assert: (IA isImplemented).

B compile:
'fooB
| |
^7' where: #().
	b := B new.
	self assert: (B methodDict size = 1).
	self assert: (b fooB = 7).
	self assert: (IB isImplemented).

CD compile:
'fooC: a arg2: b arg3: c
| local1 local2 |
local1 := 9.
local2 := 7.
^(a + (local1*b) + (local2*c))' where: #(Number Number Number).
CD compile:
'cdVar
| |
^x' where: #().
CD compile:
'cdVar: var
| |
x := var.' where: #(Number).
CD compile:
'fooD
| |
^''FOOD''' where: #().
	cd1 := CD new.
	cd1 cdVar: 5.
	self assert: (cd1 cdVar = 5).
	res1 := (cd1 fooC: 2 arg2: 4 arg3: 8).
	res2 := (2 + (4*9) + (8*7)).
	self assert: (res1 = res2).
	cd1 cdVar: 6.
	self assert: (CD methodDict size = 4).
	self assert: (cd1 fooD = 'FOOD').
	self assert: (IC isImplemented).
	self assert: (ID isImplemented).
	
MyObject subclass: #IE isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #IF isInterface: true behavesLike: {IE} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
IE compile: 'fooE'.
IF compile: 'fooF: arg1'.

MyObject subclass: #E isInterface: false behavesLike: {IF} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	self assert: (E behavesLike = {IE . IF} asSet).
	self assert: (IE isImplemented not).
	self assert: (IF isImplemented not).

E compile:
'fooE
| local1 |
local1 := 3.
local1 := local1*2.
^local1' where: #().
E compile:
'fooF: arg1
| local1 |
local1 := 4.
^(local1*arg1)' where: #(Integer).
	e := E new.
	self assert: (e fooE = 6).
	self assert: (IE isImplemented).
	self assert: (E methodDict size = 2).
	e := E new.
	self assert: (e fooE = 6).
	self assert: ((e fooF: 7) = 28).
	self assert: (IE isImplemented).
	self assert: (IF isImplemented).! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'AS 12/15/2017 23:13'!
testIsKindOfAdvanced
	"comment stating purpose of message"
	
	| x y z w v a b | 

MyObject subclass: #IA isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #IB isInterface: true behavesLike: {IA} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #IC isInterface: true behavesLike: {IB} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #ID isInterface: true behavesLike: {IC} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #IE isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #IF isInterface: true behavesLike: {IE} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.

MyObject subclass: #X isInterface: false behavesLike: {ID} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #Y isInterface: false behavesLike: {IC} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #Z isInterface: false behavesLike: {IF} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #W isInterface: false behavesLike: {IE . IC} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #V isInterface: false behavesLike: {ID . IF} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	
	x := X new.
	y := Y new.
	z := Z new.
	w := W new.
	v := V new.
	
	self assert: (x isKindOf: X).
	self assert: (x isKindOf: IA).
	self assert: (x isKindOf: IB).
	self assert: (x isKindOf: IC).
	self assert: (x isKindOf: ID).
	self assert: ((x isKindOf: IE) not).
	self assert: ((x isKindOf: IF) not).
	self assert: ((x isKindOf: Y) not).
	self assert: ((x isKindOf: Z) not).
	self assert: ((x isKindOf: W) not).
	self assert: ((x isKindOf: V) not).
	
	self assert: (y isKindOf: Y).
	self assert: (y isKindOf: Y).
	self assert: (y isKindOf: Y).
	self assert: (y isKindOf: Y).
	self assert: ((y isKindOf: X) not).
	self assert: ((y isKindOf: Z) not).
	self assert: ((y isKindOf: W) not).
	self assert: ((y isKindOf: V) not).
	self assert: ((y isKindOf: ID) not).
	self assert: ((y isKindOf: IE) not).
	self assert: ((y isKindOf: IF) not).
	
	self assert: (z isKindOf: Z).
	self assert: (z isKindOf: IE).
	self assert: (z isKindOf: IF).
	self assert: ((z isKindOf: IA) not).
	self assert: ((z isKindOf: IB) not).
	self assert: ((z isKindOf: IC) not).
	self assert: ((z isKindOf: ID) not).
	self assert: ((z isKindOf: X) not).
	self assert: ((z isKindOf: Y) not).
	self assert: ((z isKindOf: W) not).
	self assert: ((z isKindOf: V) not).
	
	self assert: (w isKindOf: W).
	self assert: (w isKindOf: IA).
	self assert: (w isKindOf: IB).
	self assert: (w isKindOf: IC).
	self assert: (w isKindOf: IE).
	self assert: ((w isKindOf: ID) not).
	self assert: ((w isKindOf: IF) not).
	self assert: ((w isKindOf: X) not).
	self assert: ((w isKindOf: Y) not).
	self assert: ((w isKindOf: Z) not).
	self assert: ((w isKindOf: V) not).
	
	self assert: (v isKindOf: V).
	self assert: (v isKindOf: IA).
	self assert: (v isKindOf: IB).
	self assert: (v isKindOf: IC).
	self assert: (v isKindOf: ID).
	self assert: (v isKindOf: IE).
	self assert: (v isKindOf: IF).
	self assert: ((v isKindOf: X) not).
	self assert: ((v isKindOf: Y) not).
	self assert: ((v isKindOf: Z) not).
	self assert: ((v isKindOf: W) not).

W subclass: #A isInterface: false behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
A subclass: #B isInterface: false behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	
	a := A new.
	b := B new.
	
	self assert: (a isKindOf: A).
	self assert: (a isKindOf: W).
	self assert: (a isKindOf: IA).
	self assert: (a isKindOf: IB).
	self assert: (a isKindOf: IC).
	self assert: (a isKindOf: IE).
	self assert: ((a isKindOf: ID) not).
	self assert: ((a isKindOf: IF) not).
	self assert: ((a isKindOf: X) not).
	self assert: ((a isKindOf: Y) not).
	self assert: ((a isKindOf: Z) not).
	self assert: ((a isKindOf: V) not).
	self assert: ((a isKindOf: B) not).
	
	self assert: (b isKindOf: B).
	self assert: (b isKindOf: A).
	self assert: (b isKindOf: W).
	self assert: (b isKindOf: IA).
	self assert: (b isKindOf: IB).
	self assert: (b isKindOf: IC).
	self assert: (b isKindOf: IE).
	self assert: ((b isKindOf: ID) not).
	self assert: ((b isKindOf: IF) not).
	self assert: ((b isKindOf: X) not).
	self assert: ((b isKindOf: Y) not).
	self assert: ((b isKindOf: Z) not).
	self assert: ((b isKindOf: V) not).
	! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'AS 12/15/2017 12:53'!
testIsKindOfBasic
	"comment stating purpose of message"

	| aa ab baa bab |

MyObject subclass: #AA isInterface: false behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
AA compile:
'foo: arg
| local1 |
local1 := 2.
^(local1*arg)' where: #(Integer).
AA compile:
'bar: a
| |
^a' where: #(nil).

MyObject subclass: #AB isInterface: false behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
AB compile:
'foo
^7' where: #().
AB compile:
'bar: arg
^(arg + 2)' where: #(Number).

AA subclass: #BAA isInterface: false behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
AB subclass: #BAB isInterface: false behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.

	aa := AA new.
	self assert: ((aa foo: 5) = 10).
	self assert: ((aa bar: 'Test') = 'Test').
	self assert: (aa isKindOf: AA).
	
	ab := AB new.
	self assert: (ab foo = 7).
	self assert: ((ab bar: 9) = 11).
	self assert: (ab isKindOf: AB).
	
	baa := BAA new.
	self assert: ((baa foo: 4) = (aa foo:4)).
	self assert: (baa isKindOf: BAA).
	self assert: (baa isKindOf: AA).
	
	bab := BAB new.
	self assert: ((bab bar: 7) = (ab bar: 7)).
	self assert: (bab isKindOf: BAB).
	self assert: (bab isKindOf: AB).! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'LP 12/11/2017 20:03'!
testMyObjectFields

self assert: (MyObject class instVarNames size = 2).
self assert: (MyObject class instVarNames includes: 'isInterface').
self assert: (MyObject class instVarNames includes: 'behavesLike').


	

! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'LP 12/11/2017 20:04'!
testSubclassCreationBadPath

MyObject subclass: #A instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
MyObject subclass: #IA isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
	

"error 2.1"
self expectErrorFrom: [
	A subclass: #IB isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'
] withErrMessage: 'Interfaces must derive from MyObject!!'.


"error 2.2"
self expectErrorFrom: [
	MyObject subclass: #IB isInterface: true behavesLike: {} instanceVariableNames: 'foo bar baz' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'
] withErrMessage: 'Interfaces can not have state!!'.


"error 2.3"
self expectErrorFrom: [
	IA subclass: #B isInterface: false behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'
] withErrMessage: 'Classes can not derive from an interface!!'.


"error 2.4"
self expectErrorFrom: [
	MyObject subclass: #B isInterface: false behavesLike: {A} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'
] withErrMessage: 'Can not behave like a non-interface!!'.




"Now we are testing errors precedence:"

"2.1 before 2.2"
self expectErrorFrom: [
	A subclass: #IB isInterface: true behavesLike: {} instanceVariableNames: 'more variables to the god of instanceVariables' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'
] withErrMessage: 'Interfaces must derive from MyObject!!'.


"2.2 before 2.4 (because 2.2 and 2.3 can't happen at the same time, and same for 2.1 and 2.3)"
self expectErrorFrom: [
	MyObject subclass: #IB isInterface: true behavesLike: {A} instanceVariableNames: 'foo bar baz' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'
] withErrMessage: 'Interfaces can not have state!!'.


"2.3 before 2.4"
self expectErrorFrom: [
	IA subclass: #B isInterface: false behavesLike: {A} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'
] withErrMessage: 'Classes can not derive from an interface!!'.


! !

!OOP3Test methodsFor: 'as yet unclassified' stamp: 'LP 12/11/2017 20:05'!
testSubclassCreationNoMethods
| newClass |

"Create old-style class:"
newClass := MyObject subclass: #A instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
"Check return value:"
self assert: (newClass isMemberOf: (A class)). 
"Check inheritance correctness:"
self assert: (newClass superclass = MyObject).
self assert: ((MyObject subclasses) includes: A).
"Check fields:"
self assert: (A isInterface = false).


"Create new-style class:"
newClass := MyObject subclass: #B isInterface: false behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
"Check return value:"
self assert: (newClass isMemberOf: (B class)). 
"Check inheritance correctness:"
self assert: (newClass superclass = MyObject).
self assert: ((MyObject subclasses) includes: B).
"Check fields:"
self assert: (B isInterface = false).


"Create an interface:"
newClass := MyObject subclass: #IA isInterface: true behavesLike: {} instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
"Check return value:"
self assert: (newClass isMemberOf: (IA class)). 
"Check inheritance correctness:"
self assert: (newClass superclass = MyObject).
self assert: ((MyObject subclasses) includes: IA).
"Check fields:"
self assert: (IA isInterface = true).


"Create new-style class, implementing an interface:"
MyObject subclass: #C isInterface: false behavesLike: {IA} instanceVariableNames: 'x y z' classVariableNames: '' poolDictionaries: ''	category: 'OOP3'.
"Check fields and instance variables:"
self assert: (C isInterface = false).
self assert: ((C instVarNames) includes: 'x').
self assert: ((C instVarNames) includes: 'y').
self assert: ((C instVarNames) includes: 'z').



! !
