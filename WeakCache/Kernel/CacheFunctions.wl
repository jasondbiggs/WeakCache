(* Wolfram Language package *)

BeginPackage["JasonB`WeakCache`CacheFunctions`", {"JasonB`WeakCache`"}]


Begin["`Private`"]


(* *************************************************************************

            WeakHashTable - constructor

** ************************************************************************* *)

WeakHashTable::unsprtd = "Operation `1` is not supported."

weakHashTableQ[HoldPattern[_WeakHashTable?System`Private`HoldNoEntryQ]] := True
weakHashTableQ[HoldPattern[Language`ExpressionStore[_String]]] := True
weakHashTableQ[___] := False
getTable[HoldPattern[WeakHashTable[tab_]]] := tab

WeakHashTable[label_String] := Replace[
	Language`NewExpressionStore[label],
	{
		store_Language`ExpressionStore :> System`Private`ConstructNoEntry[WeakHashTable, store],
		_ -> $Failed
	}
]

wht:WeakHashTable[HoldPattern[Language`ExpressionStore[label_String]]] /; !weakHashTableQ[Unevaluated @ wht] := System`Private`ConstructNoEntry[
	WeakHashTable, Language`NewExpressionStore[label]
]


(* *************************************************************************

            WeakHashTable - up values

** ************************************************************************* *)


WeakHashTable /: MakeBoxes[HoldPattern[wht : WeakHashTable[_[s_String]]], fmt_] := BoxForm`ArrangeSummaryBox[
	WeakHashTable,
	wht, None,
	{BoxForm`SummaryItem @ {s}}, {BoxForm`SummaryItem @ {s}},
	fmt, "CompleteReplacement" -> True, "Interpretable" -> False
] /; weakHashTableQ[Unevaluated[wht]]


Language`SetMutationHandler[WeakHashTable, mutateWHT]

SetAttributes[mutateWHT, HoldAllComplete]

mutateWHT[HoldPattern[Set[table_Symbol[expr_, key_], val_]]] /; weakHashTableQ[table] := With[
	{store = getTable[table]},
	store @ put[expr, key, val]
]

mutateWHT[HoldPattern[Set[table_Symbol[expr_], val_]]] /; weakHashTableQ[table] := With[
	{store = getTable[table]},
	store @ put[expr, $singleton, val]
]

mutateWHT[HoldPattern[Unset[table_Symbol[expr_, key_]]]] /; weakHashTableQ[table] := With[
	{store = getTable[table]},
	store @ remove[expr, key];
]

mutateWHT[HoldPattern[Unset[table_Symbol[expr_]]]] /; weakHashTableQ[table] := With[
	{store = getTable[table]},
	store @ remove[expr];
]

(*reassignment*)
mutateWHT[HoldPattern[Set[table_Symbol, val_]]] := Language`MutationFallthrough

mutateWHT[args__] := (Message[WeakHashTable::unsprtd, HoldForm[args]]; Language`MutationFallthrough)


$store = Language`NewExpressionStore["_globalStore"];


Protect[$singleton]
Protect[$sameInstance]
Protect[$strongReference]

(* *************************************************************************

            WeakHashTable - sub values

** ************************************************************************* *)



(*

      	ds["Elements"]	return a list of the elements of ds	time: O(n)
      	ds["EmptyQ"]	True, if ds has no elements	time: O(1)
      	ds["Insert",key->value]	add key to ds with the associated value and return True if the addition succeeded	time: O(1)
      	ds["KeyDrop",key]	drop key and its value from ds 	time: O(1)
      	ds["KeyDropAll"]	drop all the keys and their values from ds 	time: O(n)
      	ds["KeyExistsQ",key]	True, if the key exists in ds	time: O(1)
      	ds["Keys"]	return the keys in ds as a list	time: O(n)
      	ds["Length"]	the number of key-value pairs stored in ds	time: O(1)
      	ds["Lookup",key]	return the value stored with key in ds; if the key is not found return a Missing object	time: O(1)
      	ds["Lookup",key,defFun]	return the value stored with key in ds; if the key is not found return defFun[key]	time: O(1)
      	ds["Values"]	return the values in ds as a list	time: O(n)
      	ds["Visualization"]	return a visualization of ds	time: O(n)



*)

WeakHashTable[tab_Language`ExpressionStore]["Elements"] := Rule[#1, Rule @@@ #2] & @@@ tab[listTable[]]

WeakHashTable[tab_Language`ExpressionStore]["EmptyQ"] := tab[listTable[]] === {}

WeakHashTable[tab_Language`ExpressionStore][
	"Insert", expr_, key_, value_
]  := tab[put[expr,key, value]]


WeakHashTable[tab_Language`ExpressionStore][
	"Insert", expr_, value_
] := tab[put[expr, Automatic, value]]

WeakHashTable[tab_Language`ExpressionStore][
	"Insert", HoldPattern[Rule[expr_,Rule[key_, value_]]]
] := tab[put[expr, key, value]]

WeakHashTable[tab_Language`ExpressionStore][
	"Insert", HoldPattern[Rule[expr_,value_]]
] := tab[put[expr, Automatic, value]]

WeakHashTable[tab_Language`ExpressionStore][
	"Lookup", expr_, key_
]  := tab[get[expr,key]]

WeakHashTable[tab_Language`ExpressionStore][
	"KeyDrop", expr_, key_
] := tab[remove[expr,key]]

WeakHashTable[tab_Language`ExpressionStore][
	"KeyDrop", expr_
] := tab[remove[expr]]

(expr : WeakHashTable[tab_Language`ExpressionStore])[
	"KeyDropAll"
] := (
	tab["remove"[#]] & /@ tab["listTable"[]][[All, 1]];
	expr
)

WeakHashTable[tab_Language`ExpressionStore][
	"KeyExistsQ", expr_, key_
] := tab[containsQ[expr, key]]

WeakHashTable[tab_Language`ExpressionStore][
	"KeyExistsQ", expr_
] := tab[containsQ[expr]]


WeakHashTable[tab_Language`ExpressionStore]["Length"] := Total[Length /@ tab[listTable[]][[All, 2]]]


WeakHashTable[tab_Language`ExpressionStore][
	"_table"
] := tab

(* *************************************************************************

            SetWeakCache

** ************************************************************************* *)


(* *************************************************************************

            CheckWeakCache

** ************************************************************************* *)


(* *************************************************************************

            ClearWeakCache

** ************************************************************************* *)





CacheSet[HoldPattern[Rule[a_, Rule[b_, c_]]]] := $store @ put[a, b, c]
CacheSet[HoldPattern[Rule[Rule[a_, b_], c_]]] := $store @ put[a, b, c]
CacheSet[a_, b_, c_] := $store @ put[a, b, c]

CacheSet[Rule[a_, c_]] := $store @ put[a, $singleton, c]
CacheSet[a_, c_] := $store @ put[a, $singleton, c]


WeakCacheValue[expr_] := $store @ get[expr, $singleton]
WeakCacheValue[expr_, key_] := $store @ get[expr, key]

WeakCacheValue /: HoldPattern[Set[WeakCacheValue[expr_], val_]] := ($store @ put[expr, $singleton, val]; val)
WeakCacheValue /: HoldPattern[Set[WeakCacheValue[expr_, key_], val_]] := ($store @ put[expr, key, val]; val)

WeakCacheValue /: HoldPattern[Unset[WeakCacheValue[expr_]]] := ($store @ remove[expr];)
WeakCacheValue /: HoldPattern[Unset[WeakCacheValue[expr_, key_]]] := ($store @ remove[expr, key];)

WeakCacheValue /: HoldPattern[Remove[WeakCacheValue[expr_]]] := ($store @ remove[expr];)
WeakCacheValue /: HoldPattern[Remove[WeakCacheValue[expr_, key_]]] := ($store @ remove[expr, key];)



(* *************************************************************************

            SameInstanceQ

** ************************************************************************* *)


SameInstanceQ[] := True;
SameInstanceQ[_] := True;
SameInstanceQ[expr1_, exprs__] := WithCleanup[
	$store @ put[expr1, $sameInstance, 0]
	,
	AllTrue[Unevaluated @ {exprs}, ($store @ containsQ[#, $sameInstance])&]
	,
	$store @ "remove"[expr1, $sameInstance]
]



(* *************************************************************************

           CreateReference, WeakReference, and StrongReference
           
           these are pretty weird, not sure if useful

** ************************************************************************* *)

$expiredReference := $expiredReference = Failure[
	"ExpiredReference", <|
	"Message" -> "The reference has expired."|>
]


StrongReference::nosrl = "Invalid attempt to deserialize a StrongReference."

_StrongReference?System`Private`HoldEntryQ := (Message[StrongReference::nosrl]; $Failed)

(sr_StrongReference?System`Private`HoldNoEntryQ)[] := $store @ get[sr, $strongReference]

StrongReference /: MakeBoxes[sr_StrongReference?System`Private`HoldNoEntryQ, fmt_] := InterpretationBox[
	StyleBox[
		RowBox[
			{
				StyleBox["\"<\"", ShowStringCharacters -> False],
				"", "StrongReference", "", StyleBox["\">\"", ShowStringCharacters -> False]
			}
		],
		FontColor -> GrayLevel[0.5],
		StripOnInput -> False
	],
	StrongReference[],
	Selectable -> False
]


HoldPattern[WeakReference[inner_][]] := Replace[
	System`Utilities`ExprLookup[inner],
	{
		$Failed :> $expiredReference,
		_System`Utilities`ExprLookup :> $Failed
	}
]

WeakReference /: MakeBoxes[wr_WeakReference?System`Private`HoldNoEntryQ, fmt_] := InterpretationBox[
	StyleBox[
		RowBox[{"<WeakReference>"}],
		FontColor -> GrayLevel[0.5],
		StripOnInput -> False
	],
	wr,
	Selectable -> False
]


CreateReference[expr_] := With[
	{ref = System`Private`ConstructNoEntry[StrongReference]},
	$store @ put[ref, $strongReference, expr];
	ref
]

CreateReference[expr_, "Weak"] := With[
	{ref = System`Private`ConstructNoEntry[WeakReference, System`Utilities`ExprLookupAdd[expr]]},
	ref
]




EndPackage[]

End[]

