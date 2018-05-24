// Class to gather and process test results.

// Constructor.
// Return: reporter class instance
function KUnitReporter {
	local public is lexicon().
	local private is lexicon().
	
	set private#numErrors to 0.
	set private#numByType to lexicon().

	// class methods
	set public#notifyOfTestStart to KUnitReporter_notifyOfTestStart@:bind(public, private).
	set public#notifyOfTestCaseStart to KUnitReporter_notifyOfTestCaseStart@:bind(public, private).
	set public#notifyOfAssertionResult to KUnitReporter_notifyOfAssertionResult@:bind(public, private).
	set public#notifyOfTestCaseEnd to KUnitReporter_notifyOfTestCaseEnd@:bind(public, private).
	set public#notifyOfTestEnd to KUnitReporter_notifyOfTestEnd@:bind(public, private).
	set public#notifyOfError to KUnitReporter_notifyOfError@:bind(public, private).
	set public#printReportSummary to KUnitReporter_printReportSummary@:bind(public, private).

    set private#printResult to KUnitReporter_printResult@:bind(public, private).	
	set private#printResultCombinedType to KUnitReporter_printResultCombinedType@:bind(public, private).

	return public.
}

function KUnitReporter_notifyOfTestStart {
	declare local parameter public, private, result.
	private#printResultCombinedType("test_start", result).
}

function KUnitReporter_notifyOfTestCaseStart {    
	declare local parameter public, private, result.
	private#printResultCombinedType("test_case_start", result).
}

function KUnitReporter_notifyOfAssertionResult {
	declare local parameter public, private, result.
	local type is result#type.
	local map is private#numByType.
	if map:haskey(type) {
		set map[type] to map[type] + 1.
	} else {
		set map[type] to 1.
	}
	private#printResultCombinedType("assertion", result).
}

function KUnitReporter_notifyOfTestCaseEnd {
	declare local parameter public, private, result.
	private#printResultCombinedType("test_case_end", result).
}

function KUnitReporter_notifyOfTestEnd {
	declare local parameter public, private, result.
	private#printResultCombinedType("test_end", result).
}

function KUnitReporter_notifyOfError {
	declare local parameter public, private, result.
	set private#numErrors to private#numErrors + 1.
	local nres is KUnitResult("ERROR", result#message, result#testName, result#testCaseName).
	private#printResult(nres).
}

function KUnitReporter_printResult {
	declare local parameter public, private, result.
	print result#toString().
}

function KUnitReporter_printReportSummary {
	declare local parameter public, private.
	print "Summary report not yet implemented". // TODO: fixme
}

// Private.
function KUnitReporter_printResultCombinedType {
	declare local parameter public, private, typeExtension, result.
	local ntype is typeExtension + "->" + result#type.
	local nres is KUnitResult(ntype, result#message, result#testName, result#testCaseName).
	private#printResult(nres).
}
