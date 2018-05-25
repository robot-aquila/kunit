// Unit test of KUnitResultBuilder class

runoncepath("kunit/class/KUnitResultBuilder").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

function KUnitResultBuilderTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitResultBuilderTest").
    
    local public is KUnitTest("KUnitResultBuilderTest", reporter, className, protected).
    
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set private#testObject to -1.
    
    set protected#setUp to KUnitResultBuilderTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitResultBuilderTest_tearDown@:bind(private, parentProtected).
    
    set public#testCtor0 to KUnitResultBuilderTest_testCtor0@:bind(public, private).
    set public#testCtor2 to KUnitResultBuilderTest_testCtor2@:bind(public, private).
    set public#testSetTestName to KUnitResultBuilderTest_testSetTestName@:bind(public, private).
    set public#testSetTestCaseName to KUnitResultBuilderTest_testSetTestCaseName@:bind(public, private).
    set public#testBuildFailure to KUnitResultBuilderTest_testBuildFailure@:bind(public, private).
    set public#testBuildSuccess to KUnitResultBuilderTest_testBuildSuccess@:bind(public, private).
    set public#testBuildError to KUnitResultBuilderTest_testBuildError@:bind(public, private).
    set public#testBuildExpectationFailure to KUnitResultBuilderTest_testBuildExpectationFailure@:bind(public, private).
    
    public#addCasesByNamePattern("^test").

    return public.    
}

function KUnitResultBuilderTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }
    
    set private#testObject to KUnitResultBuilder().
    
    return true.
}

function KUnitResultBuilderTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testObject:clear().
    set private#testObject to -1.
    
    parentProtected#tearDown().
}

function KUnitResultBuilderTest_testCtor0 {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    if not public#assertEquals("KUnitResultBuilder", object#getClassName()) return.
    
    local expected is KUnitResult("success").
    local actual is object#buildSuccess().
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitResultBuilderTest_testCtor2 {
    declare local parameter public, private.

    local object is KUnitResultBuilder("TestName", "TestCase1").
    
    if not public#assertEquals("KUnitResultBuilder", object#getClassName()) return.
    
    local expected is KUnitResult("success", "", "TestName", "TestCase1").
    local actual is object#buildSuccess().
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitResultBuilderTest_testSetTestName {
    declare local parameter public, private.

    local object is private#testObject.
    
    object#setTestName("FooBarTest").
    local expected is KUnitResult("success", "", "FooBarTest").
    local actual is object#buildSuccess().
    if not public#assertObjectEquals(expected, actual) return.    
}

function KUnitResultBuilderTest_testSetTestCaseName {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    object#setTestName("FooBarTest").
    object#setTestCaseName("zulu24").
    local expected is KUnitResult("success", "", "FooBarTest", "zulu24").
    local actual is object#buildSuccess().
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitResultBuilderTest_testBuildFailure {
    declare local parameter public, private.
    
    local object is private#testObject.

    object#setTestName("Zulu24").
    object#setTestCaseName("myCase").
    local expected is KUnitResult("failure", "Message. Clarification", "Zulu24", "myCase").
    local actual is object#buildFailure("Message", "Clarification").
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitResultBuilderTest_testBuildSuccess {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    object#setTestName("Delta").
    object#setTestCaseName("Charlie").
    local expected is KUnitResult("success", "", "Delta", "Charlie").
    local actual is object#buildSuccess().
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitResultBuilderTest_testBuildError {
    declare local parameter public, private.
    
    local object is private#testObject.

    object#setTestName("KerbalSpace").
    object#setTestCaseName("isCool").
    local expected is KUnitResult("error", "No errors please", "KerbalSpace", "isCool").
    local actual is object#buildError("No errors please").
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitResultBuilderTest_testBuildExpectationFailure {
    declare local parameter public, private.
    
    local object is private#testObject.

    object#setTestName("ExpectationTest").
    object#setTestCaseName("testCase100").
    local expected is KUnitResult("failure",
        "Message. Clarification: expected: <[100]> but was <[500]>",
        "ExpectationTest", "testCase100").
    local actual is object#buildExpectationFailure("Message", "Clarification", 100, 500).
    if not public#assertObjectEquals(expected, actual) return.
}

