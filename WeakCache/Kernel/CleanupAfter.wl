BeginPackage["JasonB`WeakCache`CleanupAfter`", {"JasonB`WeakCache`"}]
Begin["`Private`"]



(* ::Section::Closed:: *)
(*Find library, build if necessary*)


$context = $Context
$library = FindLibrary["CleanupAfter"]
CleanupAfter::lib = "Library failed to load, CleanupAfter will not be available."
$Initialized := Enclose[
	ClearAll[$Initialized];
	Quiet[LibraryUnload[$library]];
	Confirm @ LibraryLoad[$library];
	With[
		{
			setFunctionName = Confirm @ LibraryFunctionLoad[$library, "setFunctionName", {"UTF8String"}, "Void"],
			functionName = $context <> "iCleanup"
		},
		ConfirmMatch[setFunctionName @ functionName, Null]
	];
	$Initialized = True,
	(
		
		$Initialized = False
	)&
]


(* ::Section::Closed:: *)
(*Main functions*)



$cache = <| |>
$store = Language`NewExpressionStore["_expressionCleanup"];

Attributes[CleanupAfter] = {HoldRest}

CleanupAfter[expr_, func_] /; $Initialized := Module[
	{
		mle = CreateManagedLibraryExpression["ExpressionCleanup", ExpressionCleanup]
	},
	$store["put"[expr, 0, mle]];
	$cache[ManagedLibraryExpressionID[mle]] := func;
]

CleanupAfter[expr_] /; $Initialized := ($store["remove"[expr]];)

CleanupAfter[] /; $Initialized := (Map[
	$store["remove"[#]]&,
	$store["listTable"[]][[All, 1]]
];)


iCleanup[id_] := WithCleanup[Null,Null,
	$cache[id];
	KeyDropFrom[$cache, id];
]


End[]
EndPackage[]
