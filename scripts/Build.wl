(* Wolfram Language Package *)

BeginPackage["CachUtilities`Build`"]

buildLibrary
buildPaclet

Begin["`Private`"] (* Begin Private Context *) 

$libraryName = "CleanupAfter"
$pacletName = "WeakHashTable"
$inputFileName = $InputFileName
$pacletSourceDir = FileNameJoin @ {ParentDirectory @ DirectoryName[$inputFileName], $pacletName}
$extension = Replace[$OperatingSystem, 
	{
		"MacOSX" -> ".dylib",
		"Windows" ->".dll",
		_ -> ".so"
	}
];


Options[buildPaclet] = {
	"TargetDirectory" -> Automatic,
	"BuildLibrary" -> Automatic,
	"Clean" -> False
}

buildPaclet[OptionsPattern[]] := Module[
	{targetdir, buildLib},
	{targetdir, buildLib} = OptionValue @ {"TargetDirectory", "BuildLibrary"};
	targetdir = Replace[
		OptionValue["TargetDirectory"],
		Automatic :> FileNameJoin[{ParentDirectory @ $pacletSourceDir, "build", $pacletName}]
	];
	buildLib = Replace[OptionValue["BuildLibrary"],
		Automatic :> !FileExistsQ[
			FileNameJoin[{$pacletSourceDir, "LibraryResources", $SystemID, $libraryName <> $extension}]
		]
	];
	If[buildLib,
		Replace[
			buildLibrary[],
			x : Except[_?FileExistsQ] :> Return[x, Module]
		]
	];
	If[DirectoryQ[targetdir],
		DeleteDirectory[targetdir, DeleteContents -> True];
	];
	CreateDirectory[targetdir];
	CopyDirectory[
		FileNameJoin[{$pacletSourceDir, "Kernel"}],
		FileNameJoin[{targetdir, "Kernel"}]
	];
	CopyDirectory[
		FileNameJoin[{$pacletSourceDir, "LibraryResources"}],
		FileNameJoin[{targetdir, "LibraryResources"}]
	];
	CopyFile[
		FileNameJoin[{$pacletSourceDir, "PacletInfo.wl"}],
		FileNameJoin[{targetdir, "PacletInfo.wl"}]
	]
]




buildLibrary[] := (
	Needs["CCompilerDriver`"];
	Module[
		{
			sourceFile = FileNameJoin[{$pacletSourceDir, "CPPSource", $libraryName <> ".cpp"}],
			targetDirectory = FileNameJoin[{$pacletSourceDir, "LibraryResources", $SystemID}]
		},
		PrintTemporary["building library"];
		CCompilerDriver`CreateLibrary[
			{sourceFile}, 
			$libraryName, 
			"TargetDirectory" -> targetDirectory, "Language" -> "C++"
		]
	]
)






End[] (* End Private Context *)

EndPackage[]