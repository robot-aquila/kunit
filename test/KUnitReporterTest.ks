// Unit test of KUnitReporter class
// Also this is a good example how to deal with mocks and captures to
// test class behavior. Next KUnit versions will include a special class
// for capturing arguments.

runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").
runoncepath("kunit/class/KUnitResultBuilder").

function KUnitReporterTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitReporterTest").
 
    local public is KUnitTest("KUnitReporterTest", reporter, className, protected).
    
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set private#printerMock to -1.
    set private#testObject to -1.
    set private#resBuilder to -1.
    
    set protected#setUp to KUnitReporterTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitReporterTest_tearDown@:bind(private, parentProtected).
 
    set public#testCtor to KUnitReporterTest_testCtor@:bind(public, private).
    set public#testNotifyOfTestStart to KUnitReporterTest_testNotifyOfTestStart@:bind(public, private).
    set public#testNotifyOfTestCaseStart to KUnitReporterTest_testNotifyOfTestCaseStart@:bind(public, private).
    set public#testNotifyOfAssertionResult to KUnitReporterTest_testNotifyOfAssertionResult@:bind(public, private).
    set public#testNotifyOfTestCaseEnd to KUnitReportertest_testNotifyOfTestCaseEnd@:bind(public, private).
    set public#testNotifyOfTestEnd to KUnitReporterTest_testNotifyOfTestEnd@:bind(public, private).
    set public#testNotifyOfError to KUnitReporterTest_testNotifyOfError@:bind(public, private).
    set public#testPrintReportSummary_Redline to KUnitReporterTest_testPrintReportSummary_Redline@:bind(public, private).
    set public#testPrintReportSummary_Greenline to KUnitReporterTest_testPrintReportSummary_Greenline@:bind(public, private).
    
    public#addCasesByNamePattern("^test").

    return public.
}

function KUnitReporterTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    set private#printerMock to KUnitPrinter().
    set private#testObject to KUnitReporter(private#printerMock).
    set private#resBuilder to KUnitResultBuilder("TestName", "testCase").
    
    return true.
}

function KUnitReporterTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testObject:clear().
    private#resBuilder:clear().
    private#printerMock:clear().
    
    parentProtected#tearDown().
}

function KUnitReporterTest_testCtor {
    declare local parameter public, private.
    
    local object is private#testObject.
    if not public#assertEquals("KUnitReporter", object#getClassName()).
}

function KUnitReporterTest_testNotifyOfTestStart {
    declare local parameter public, private.

    local builder is private#resBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local captured is -1.
    set printerMock#print to {
        declare local parameter text.
        set captured to text.
    }.
    builder#setTestCaseName("").
    local res is builder#buildSuccess().
     
    object#notifyOfTestStart(res).
    
    if not public#assertEquals("TestName test_start->success", captured) return.
}

function KUnitReporterTest_testNotifyOfTestCaseStart {
    declare local parameter public, private.
    
    local builder is private#resBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local captured is -1.
    set printerMock#print to {
        declare local parameter text.
        set captured to text.
    }.
    local res is builder#buildSuccess().
    
    object#notifyOfTestCaseStart(res).
    
    if not public#assertEquals("TestName#testCase test_case_start->success", captured) return.
}

function KUnitReporterTest_testNotifyOfAssertionResult {
    declare local parameter public, private.
    
    local builder is private#resBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local captured is -1.
    set printerMock#print to {
        declare local parameter text.
        set captured to text.
    }.
    local res is builder#buildSuccess().
    
    object#notifyOfAssertionResult(res).
    
    if not public#assertEquals("TestName#testCase assertion[0]->success", captured) return.
}

function KUnitReporterTest_testNotifyOfTestCaseEnd {
    declare local parameter public, private.
    
    local builder is private#resBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local captured is -1.
    set printerMock#print to {
        declare local parameter text.
        set captured to text.
    }.
    local res is builder#buildSuccess().

    object#notifyOfTestCaseEnd(res).
    
    if not public#assertEquals("TestName#testCase test_case_end->success", captured) return.
}

function KUnitReporterTest_testNotifyOfTestEnd {
    declare local parameter public, private.
    
    local builder is private#resBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local captured is -1.
    set printerMock#print to {
        declare local parameter text.
        set captured to text.
    }.
    builder#setTestCaseName("").
    local res is builder#buildSuccess().

    object#notifyOfTestEnd(res).
    
    if not public#assertEquals("TestName test_end->success", captured) return.
}

function KUnitReporterTest_testNotifyOfError {
    declare local parameter public, private.

    local builder is private#resBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local captured is -1.
    set printerMock#print to {
        declare local parameter text.
        set captured to text.
    }.
    local res is builder#buildError("Some error text").
    
    object#notifyOfError(res).
    
    if not public#assertEquals("TestName#testCase ERROR: Some error text", captured) return.
}

function KUnitReporterTest_testPrintReportSummary_Redline {
    declare local parameter public, private.
    
    // Given
    
    // Yep. That is the hard case.
    // Decision to make refactoring for better design is close around.
    // Ideally it should be two classes: one to gather the data and
    // other to represent the result.
    
    // We have to reproduce valid sequence of notifications to build correct
    // summary report. Let's assume it will be: two tests with one test case
    // each. The first test will finish with result of two successful
    // assertions.  The second test will finish with one success and one
    // failure. The third test will finish with an error. So we can predict the
    // summarty report. It should be:
    
    local expected is list().
    expected:add("== REDLINE ===============================").
    expected:add("                  total |success | failed ").
    expected:add("     assertions:      4 |      3 |      1 ").
    expected:add("     test cases:      2 |      1 |      1 ").
    expected:add("          tests:      2 |      1 |      1 ").
    expected:add("         errors:      1                   ").
    expected:add("========================== KUnit v0.0.1 ==").

    local builder is private#resBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    
    // We're making fixture and do not need the output.
    // Let's make our printer mock "nice" to hide whole output until it needed
    set printerMock#print to { declare local parameter text. }.
    
    // Next let's add entries for summary report
    builder#setTestName("FirstTest").
    object#notifyOfTestStart(builder#buildSuccess()).
    builder#setTestCaseName("testMyFirstTestCase").
    object#notifyOfTestCaseStart(builder#buildSuccess()).
    object#notifyOfAssertionResult(builder#buildSuccess()).
    object#notifyOfAssertionResult(builder#buildSuccess()).
    object#notifyOfTestCaseEnd(builder#buildSuccess()).
    builder#setTestCaseName("").
    object#notifyOfTestEnd(builder#buildSuccess()).
    
    builder#setTestName("SecondTest").
    object#notifyOfTestStart(builder#buildSuccess()).
    builder#setTestCaseName("testMySecondTestCase").
    object#notifyOfTestCaseStart(builder#buildSuccess()).
    object#notifyOfAssertionResult(builder#buildSuccess()).
    object#notifyOfAssertionResult(builder#buildFailure("Test failure")).
    object#notifyOfTestCaseEnd(builder#buildSuccess()).
    builder#setTestName("").
    object#notifyOfTestEnd(builder#buildSuccess()).
    
    builder#setTestName("ThirdTest").
    object#notifyOfError(builder#buildError("Third test not started")).
    
    // So, the time to build report. Let's capture all output from now.
    local actual is list().
    set printerMock#print to {
        declare local parameter text.
        actual:add(text).
    }.
    
    // When
    object#printReportSummary().
    
    // Then
    if not public#assertListEquals(expected, actual, "Expected output does not match") return.
}

function KUnitReporterTest_testPrintReportSummary_Greenline {
    declare local parameter public, private.

    // GIVEN

    local expected is list().
    expected:add("== GREENLINE =============================").
    expected:add("                  total |success | failed ").
    expected:add("     assertions:      4 |      4 |      0 ").
    expected:add("     test cases:      2 |      2 |      0 ").
    expected:add("          tests:      2 |      2 |      0 ").
    expected:add("         errors:      0                   ").
    expected:add("========================== KUnit v0.0.1 ==").

    local builder is private#resBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    
    set printerMock#print to { declare local parameter text. }.
    
    builder#setTestName("FirstTest").
    object#notifyOfTestStart(builder#buildSuccess()).
    builder#setTestCaseName("testMyFirstTestCase").
    object#notifyOfTestCaseStart(builder#buildSuccess()).
    object#notifyOfAssertionResult(builder#buildSuccess()).
    object#notifyOfAssertionResult(builder#buildSuccess()).
    object#notifyOfTestCaseEnd(builder#buildSuccess()).
    builder#setTestCaseName("").
    object#notifyOfTestEnd(builder#buildSuccess()).

    builder#setTestName("SecondTest").
    object#notifyOfTestStart(builder#buildSuccess()).
    builder#setTestCaseName("testMySecondTestCase").
    object#notifyOfTestCaseStart(builder#buildSuccess()).
    object#notifyOfAssertionResult(builder#buildSuccess()).
    object#notifyOfAssertionResult(builder#buildSuccess()).
    object#notifyOfTestCaseEnd(builder#buildSuccess()).
    builder#setTestName("").
    object#notifyOfTestEnd(builder#buildSuccess()).

    local actual is list().
    set printerMock#print to {
        declare local parameter text.
        actual:add(text).
    }.
    
    // WHEN
    object#printReportSummary().
    
    // THEN
    if not public#assertListEquals(expected, actual, "Expected output does not match") return.
}


