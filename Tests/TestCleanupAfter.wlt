BeginTestSection["TestCleanupAfter"]


VerificationTest[
	Needs @ "JasonB`WeakCache`"
	,
	Null
	,
	{}
	,
	TestID->"TestCleanupAfter_20221024-YWV3YN"
]


VerificationTest[
	Block[{expr = Range @ 5, expr2 = 5},
		JasonB`WeakCache`CleanupAfter[expr, TimesBy[expr2, 2]];
		{
			expr2,
			Unset @ expr;
			expr2
		}
	]
	,
	{5, 10}
	,
	{}
	,
	TestID->"TestCleanupAfter_20221024-TLXPW5"
]


VerificationTest[
	Block[{x},
		{
			x = 20,
			Block[{expr = Range @ 5},
				JasonB`WeakCache`CleanupAfter[expr, TimesBy[x, 2]];
				x
			],
			x
		}
	]
	,
	{20, 20, 40}
	,
	{}
	,
	TestID->"TestCleanupAfter_20221024-TD3PHP"
]


EndTestSection[]
