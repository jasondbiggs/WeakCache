BeginPackage["JasonB`WeakCache`"]


`Private`$exportedSymbols = FirstCase[
	PacletObject["JasonB/WeakCache"]["Extensions"],
	{"Kernel", ___, _["Symbols", `Private`symbols_], ___} :> `Private`symbols
]
Unprotect /@ Chemistry`Private`$exportedSymbols
ClearAll /@ Chemistry`Private`$exportedSymbols


CleanupAfter::usage = "CleanupAfter[expr, func] evaluates func when there are no more references to expr in a Wolfram Language session."

SameInstanceQ::usage = "SameInstanceQ[expr1, expr2] returns True if expr1 and expr2 share the same instance."


WeakHashTable::usage = "WeakHashTable[\"label\"] returns a weak hash table data structure with the given label."

SetWeakCache::usage = "SetWeakCache[expr,key,value] stores the key value pair in a global hash table and removes the entry \
when there are no references to expr in a Wolfram Language session."(*
SetWeakCache[expr,value] uses Automatic as the key."*)

CheckWeakCache::usage = "CheckWeakCache[expr,key] returns the value associated with key in a global hash table using a \
weak reference to expr, and $Failed otherwise."(*
CheckWeakCache[expr] uses Automatic as the key."*)

ClearWeakCache::usage = "ClearWeakCache[expr,key] removes the given entry from the global weak hash table.
ClearWeakCache[expr] removes all key-value pairs associated with the expression expr.
ClearWeakCache[] removes all entries from the global weak hash table."

ClearHistory::usage = "ClearHistory[] clears all expressions from In and Out and resets $Line to zero."


StrongReference::usage = "StrongReference[..] represents a reference to an expression which ensures the \
expression is kept in memory for the lifetime of the reference. 
StrongReference[..][] returns the referenced expression."

WeakReference::usage = "WeakReference[..] represents a reference to an expression which does not ensure the \
expression is kept in memory for the lifetime of the reference. 
WeakReference[..][] returns the referenced expression."

CreateReference::usage = "CreateReference[expr] returns a strong reference to the input expression.
CreateReference[expr, \"Weak\"] returns a weak reference to the input expression."




Begin["`Private`"]


ClearAll @ $exportedFunctions

Get[FileNameJoin[{DirectoryName @ $InputFileName, #}]]& /@ {"CacheFunctions.wl", "CleanupAfter.wl"}





(* :!CodeAnalysis::BeginBlock:: *)
(* :!CodeAnalysis::Disable::SuspiciousSessionSymbol:: *)

ClearHistory[] := (
	Unprotect[In, Out];
	Clear[In, Out];
	Protect[In, Out];
	$Line = 0;
)


(* :!CodeAnalysis::EndBlock:: *)

SetAttributes[#, {Protected, ReadProtected}]& /@ $exportedSymbols

End[] (* End `Private` *)

EndPackage[]
