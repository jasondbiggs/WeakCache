BeginPackage["JasonB`WeakCache`CleanupAfter`", {"JasonB`WeakCache`"}]
Begin["`Private`"]





Attributes[CleanupAfter] = {HoldRest}

CleanupAfter[expr_, cleanup_] /; $Initialized := Block[
	{
		obj = CreateManagedObject[Null, Function[cleanup]]
	},
	$store["put"[expr, ++key, obj]];
	
]

CleanupAfter[expr_] /; $Initialized  := ($store["remove"[expr]];)

CleanupAfter[] /; $Initialized  := (Map[
	$store["remove"[#]]&,
	$store["listTable"[]][[All, 1]]
];)

$Initialized := (
	ClearAll[$Initialized];
	Quiet[CreateManagedObject, General::shdw];
	$store = Language`NewExpressionStore["_expressionCleanup"];
	If[!Developer`MachineIntegerQ[key],
		key = 0
	];
	$Initialized = True
) 

End[]
EndPackage[]
