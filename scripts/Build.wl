(* ::Package:: *)

(* Wolfram Language Package *)

BeginPackage["CachUtilities`Build`"]

buildLibrary
buildPaclet

Begin["`Private`"] (* Begin Private Context *) 

$libraryName = "CleanupAfter"
$pacletName = "WeakCache"
$inputFileName = $InputFileName
$pacletSourceDir = ParentDirectory @ DirectoryName[$inputFileName]

$sourceFile = FileNameJoin[{$pacletSourceDir, "CPPSource", $libraryName <> ".cpp"}]
$targetDirectory = FileNameJoin[{$pacletSourceDir, "LibraryResources", $SystemID}]


Needs["Wolfram`PacletCICD`" -> "cicd`"]
Needs["CCompilerDriver`"]


Print["building library"];
$built = CCompilerDriver`CreateLibrary[
	{$sourceFile}, 
	$libraryName, 
	"TargetDirectory" -> $targetDirectory, "Language" -> "C++"
]

If[FileExistsQ @ $built,
	$built,
	cicd`ConsoleError[ "Failed to build the library on " <> $SystemID <> ".", "Fatal" -> True ]
]






End[] (* End Private Context *)

EndPackage[]
