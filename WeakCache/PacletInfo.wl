(* ::Package:: *)

PacletObject @ <|
	"Name" -> "JasonB/WeakCache", 
	"Description" -> "Functions for caching with automatic garbage collection",
	"Creator" -> "Jason Biggs, Wolfram Research", 
	"License" -> "MIT", 
	"PublisherID" -> "JasonB",
	"Version" -> "0.0.1", 
	"WolframVersion" -> "13.0+",
	"Extensions" ->
		{
			{"LibraryLink"},
			{
				"Kernel",
				"Root" -> "Kernel",
				"Context" -> {{"JasonB`WeakCache`", "WeakCache.wl"}},
				"Symbols" -> {
					"JasonB`WeakCache`CleanupAfter",
					"JasonB`WeakCache`SameInstanceQ",
					"JasonB`WeakCache`WeakHashTable",
					"JasonB`WeakCache`WeakCacheValue",
					"JasonB`WeakCache`ClearHistory"
				}
			},
			{"Documentation"}
		}
|>

