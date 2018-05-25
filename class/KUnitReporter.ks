// Class to gather and process test results.

runoncepath("kunit/class/KUnitPrinter").
runoncepath("kunit/class/KUnitResult").
runoncepath("kunit/class/KUnitCounter").

// Constructor.
function KUnitReporter {
    declare local parameter
        printer is KUnitPrinter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitReporter").
    
    local public is KUnitObject(className, protected).
    
	local private is lexicon().
	
	set private#printer to printer.
	set private#numErrors to 0.
	
	// This to count how many tests in total, how many success
	// and failed within synthetic slice of all tests
	set private#countTest to KUnitCounter().
	
	// This to count how many test cases in total, how many success
	// and failed within synthetic slice of all test cases
	set private#countTestCase to KUnitCounter().
	
	// This to count how many assertions in total, how many success
	// and failed within synthetic slice of all assertions
	set private#countAssertion to KUnitCounter().
	
	// To determine was the test success or failed we have to count failed
	// assertions in scope of single test. This counter is for that purposes.
	// It will reset every time when new test is started. Every time when test
	// is finished this counter will be aggregated to totals of all tests.
	set private#countCurrentTest to KUnitCounter().
	
	// To determine was the test case success or failed we have to count failed
	// assertions in scope of single test case. This counter is for that
	// purposes. It will reset every time when new test case is started. Every
	// time  when test case is finished this counter will be aggregated to
	// totals of all test cases.
	set private#countCurrentTestCase to KUnitCounter().

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
	
	set private#countCurrentTest to KUnitCounter().
	
	private#printResultCombinedType("test_start", result).
}

function KUnitReporter_notifyOfTestCaseStart {    
	declare local parameter public, private, result.
	
	set private#countCurrentTestCase to KUnitCounter().
	
	private#printResultCombinedType("test_case_start", result).
}

function KUnitReporter_notifyOfAssertionResult {
	declare local parameter public, private, result.
	
	local countCurrentTest is private#countCurrentTest.
	local countCurrentTestCase is private#countCurrentTestCase.
	local countAssertion is private#countAssertion.
    local assertionNumber is countCurrentTestCase#getTotalCount().
	
	if result#type = "success" {
	   countCurrentTest#addSuccess().
	   countCurrentTestCase#addSuccess().
	   countAssertion#addSuccess().
	} else {
       countCurrentTest#addFailure().
       countCurrentTestCase#addFailure().
       countAssertion#addFailure().	
	}
	private#printResultCombinedType("assertion[" + assertionNumber + "]", result).
}

function KUnitReporter_notifyOfTestCaseEnd {
	declare local parameter public, private, result.
	
	local countCurrentTestCase is private#countCurrentTestCase.
	local countTestCase is private#countTestCase.
	if countCurrentTestCase#getFailureCount() > 0 {
	    countTestCase#addFailure().
	} else {
	    countTestCase#addSuccess().
	}
	set private#countCurrentTestCase to KUnitCounter().
	private#printResultCombinedType("test_case_end", result).
}

function KUnitReporter_notifyOfTestEnd {
	declare local parameter public, private, result.
	
	local countCurrentTest is private#countCurrentTest.
	local countTest is private#countTest.
	if countCurrentTest#getFailureCount() > 0 {
	    countTest#addFailure().
	} else {
	    countTest#addSuccess().
	}
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
	local printer is private#printer.
	printer#print(result#toString()).
}

function KUnitReporter_printReportSummary {
	declare local parameter public, private.
	local printer is private#printer.
	local countTest is private#countTest.
	local countTestCase is private#countTestCase.
	local countAssertion is private#countAssertion.
	local numErrors is private#numErrors.
	
	if numErrors > 0 or countTest#getFailureCount() > 0 {
	    printer#print("== REDLINE ===============================").
	} else {
	    printer#print("== GREENLINE =============================").
	}
    
    local width is 6.
    local ff is {
        declare local parameter value.
        return ("" + value):padleft(width).
    }.
    
    printer#print("                  total |success | failed ").
    
    local tc is ff(countAssertion#getTotalCount()).
    local sc is ff(countAssertion#getSuccessCount()).
    local fc is ff(countAssertion#getFailureCount()).
    printer#print("     assertions: "+tc+" | "+sc+" | "+fc+" ").
    
    local tc is ff(countTestCase#getTotalCount()).
    local sc is ff(countTestCase#getSuccessCount()).
    local fc is ff(countTestCase#getFailureCount()).
    printer#print("     test cases: "+tc+" | "+sc+" | "+fc+" ").
    
    local tc is ff(countTest#getTotalCount()).
    local sc is ff(countTest#getSuccessCount()).
    local fc is ff(countTest#getFailureCount()).
    printer#print("          tests: "+tc+" | "+sc+" | "+fc+" ").
    
    local tc is ff(numErrors).
    printer#print("         errors: "+tc+"                   ").
    printer#print("========================== KUnit v0.0.1 ==").
}

// Private.
function KUnitReporter_printResultCombinedType {
	declare local parameter public, private, typeExtension, result.
	local ntype is typeExtension + "->" + result#type.
	local nres is KUnitResult(ntype, result#message, result#testName, result#testCaseName).
	private#printResult(nres).
}
