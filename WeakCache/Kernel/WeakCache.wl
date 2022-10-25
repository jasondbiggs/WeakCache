BeginPackage["JasonB`WeakCache`"]


CleanupAfter::usage = "CleanupAfter[expr, func] evaluates func when there are no more references to expr in a Wolfram Language session."

SameInstanceQ::usage = "SameInstanceQ[expr1, expr2] returns True if expr1 and expr2 share the same instance."


WeakHashTable::usage = "WeakHashTable[\"label\"] returns a weak hash table data structure with the given label."

SetWeakCache::usage = "SetWeakCache[expr,key,value] stores the key value pair in a global hash table and removes the entry \
when there are no references to expr in a Wolfram Language session.
SetWeakCache[expr,value] uses Automatic as the key."

CheckWeakCache::usage = "CheckWeakCache[expr,key] returns the value associated with key in a global hash table using a \
weak reference to expr, and $Failed otherwise.
CheckWeakCache[expr] uses Automatic as the key."

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

$exportedFunctions = {
	CleanupAfter,
	SameInstanceQ,
	WeakHashTable,
	WeakCacheValue,
	ClearHistory,
	StrongReference,
	WeakReference,
	GetReference
}

ClearAll @ $exportedFunctions

Get[FileNameJoin[{DirectoryName @ $InputFileName, #}]]& /@ {"CacheFunctions.wl", "CleanupAfter.wl"}



ClearHistory[] := (
	Unprotect[In, Out];
	Clear[In, Out];
	Protect[In, Out];
	$Line = 0;
)

SetAttributes[#, {Protected, ReadProtected}]& /@ $exportedFunctions

End[] (* End `Private` *)

EndPackage[]
