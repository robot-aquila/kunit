// Unit test of KUnitTest class

runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

function KUnitTestTest {
	declare local parameter reporter is KUnitReporter().
	local public is KUnitTest("KUnitTestTest", reporter).
	local private is lexicon().

    set public#testFail to KUnitTestTest_testFail@:bind(public, private).
    set public#testAssetEquals to KUnitTestTest_testAssertEquals@:bind(public, private).
    
    set public#testRun to KUnitTestTest_testRun@:bind(public, private).
    set public#testRun_ShouldSkipAllTestCases_IfSetUpTestFailed to KUnitTestTest_testRun_ShouldSkipAllTestCases_IfSetUpTestFailed@:bind(public, private).
    set public#testRun_ShouldSkipTestCase_IfSetUpFailed to KUnitTestTest_testRun_ShouldSkipTestCase_IfSetUpFailed@:bind(public, private).

    public#addCasesByNamePattern("^test").
    
	return public.
}

function KUnitTesttest_testFail {
    declare local parameter public, private.
    local reporterMock is KUnitReporter().
    //set reporterMock#
    public#fail("Not yet implemented").

}

function KUnitTestTest_testAssertEquals {
    declare local parameter public, private.
    public#fail("Not yet implemented").
}

function KUnitTestTest_testRun {
	declare local parameter public, private.

	// Given
	local actual is list().
	local reporter is KUnitReporter().
	local service is KUnitTest("test1", reporter).
	service#shuffleTestCases(false).
	set service#setUpTest to { actual:add("setUpTest"). return true. }.
	set service#tearDownTest to { actual:add("tearDownTest"). return true. }.
	set service#setUp to { actual:add("setUp"). return true. }.
	set service#tearDown to { actual:add("tearDown"). return true. }.
	set service#testCase1 to { actual:add("testCase1"). }.
	set service#testCase2 to { actual:add("testCase2"). }.
	service#addCase("testCase1", service#testCase1).
	service#addCase("testCase2", service#testCase2).

	// When
	service#run().

	// Then
	local expected is list().
	expected:add("setUpTest").
	expected:add("setUp").
	expected:add("testCase1").
	expected:add("tearDown").
	expected:add("setUp").
	expected:add("testCase2").
	expected:add("tearDown").
	expected:add("tearDownTest").

    // Example assertions
	if not public#assertListEquals(expected, actual, "Unexpected call sequence") { return. }.
}

function KUnitTestTest_testRun_ShouldSkipAllTestCases_IfSetUpTestFailed {
    declare local parameter public, private.

}

function KUnitTesttest_testRun_ShouldSkipTestCase_IfSetUpFailed {
    declare local parameter public, private.
    public#fail("Not yet implemented").
}

