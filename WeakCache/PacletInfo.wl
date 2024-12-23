(* ::Package:: *)

PacletObject @ <|
	"Name" -> "JasonB/WeakCache", 
	"Description" -> "Functions for caching with automatic garbage collection",
	"Creator" -> "Jason Biggs, Wolfram Research", 
	"License" -> "MIT", 
	"PublisherID" -> "JasonB",
	"Version" -> "1.1.0",
	"WolframVersion" -> "13.3+",
	"Extensions" ->
		{
			{
				"Kernel",
				"Root" -> "Kernel",
				"Context" -> {{"JasonB`WeakCache`", "WeakCache.wl"}},
				"Symbols" -> {
					"JasonB`WeakCache`CleanupAfter",
					"JasonB`WeakCache`SameInstanceQ",
					"JasonB`WeakCache`WeakHashTable",
					"JasonB`WeakCache`SetWeakCache",
					"JasonB`WeakCache`CheckWeakCache",
					"JasonB`WeakCache`ClearWeakCache",
					"JasonB`WeakCache`CreateReference",
					"JasonB`WeakCache`StrongReference",
					"JasonB`WeakCache`WeakReference",
					"JasonB`WeakCache`ClearHistory"
				}
			},
			{"Documentation"}
		}
|>

