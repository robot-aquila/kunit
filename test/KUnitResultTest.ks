// Unit test of KUnitResult class

runoncepath("kunit/class/KUnitResult").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

function KUnitResultTest {
    declare local parameter
       reporter is KUnitReporter(),
       className is list(),
       protected is lexicon().
    className:add("KUnitResultTest").
       
    local public is KUnitTest("KUnitResultTest", reporter, className, protected).
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set private#testObject to -1.
    
    set protected#setUp to KUnitResultTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitResultTest_tearDown@:bind(private, parentProtected).
    
    set public#testCtor to KUnitResultTest_testCtor@:bind(public, private).
    set public#testToString to KUnitResultTest_testToString@:bind(public, private).
    set public#testEquals to KUnitResultTest_testEquals@:bind(public, private).
    
    public#addCasesByNamePattern("^test").
    
    return public.
}

function KUnitResultTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    set private#testObject to KUnitResult("failure", "test msg", "FooTest", "testCase1").
    
    return true.
}

function KUnitResultTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testObject:clear().
    set private#testObject to -1.
    
    parentProtected#tearDown().
}

function KUnitResultTest_testCtor {
    declare local parameter public, private.
    
    local object is private#testObject.

    if not public#assertEquals("KUnitResult", object#getClassName()) return.
    if not public#assertEquals("failure", object#type) return.
    if not public#assertEquals("test msg", object#message) return.
    if not public#assertEquals("FooTest", object#testName) return.
    if not public#assertEquals("testCase1", object#testCaseName) return.
}

function KUnitResultTest_testToString {
    declare local parameter public, private.

    local object is private#testObject.

    local expected is "FooTest#testCase1 failure: test msg".
    if not public#assertEquals(expected, object#toString()) return.
    
    set object#testCaseName to "".
    local expected is "FooTest failure: test msg".
    if not public#assertEquals(expected, object#toString()) return.
    
    set object#testName to "".
    local expected is "failure: test msg".
    if not public#assertEquals(expected, object#toString()) return.
    
    set object#message to "".
    local expected is "failure".
    if not public#assertEquals(expected, object#toString()) return.
}

function KUnitResultTest_testEquals {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    local msg is "Object must be equals to itself".
    if not public#assertTrue(object#equals(object), msg) return.
    
    local other is KUnitResult("failure", "test msg", "FooTest", "testCase1").
    local msg is "Objects must be equal if all attributes are equal".
    if not public#assertTrue(object#equals(other), msg) return.
    
    set other#type to "success".
    local msg is "Objects must be not equal if types are not equal".
    if not public#assertFalse(object#equals(other), msg) return.
    
    set other#type to object#type.
    set other#message to "another message".
    local msg is "Objects must be not equal if messages are not equal".
    if not public#assertFalse(object#equals(other), msg) return.
    
    set other#message to object#message.
    set other#testName to "SomeTest".
    local msg is "Objects must be not equal if test names are not equal".
    if not public#assertFalse(object#equals(other), msg) return.
    
    set other#testName to object#testName.
    set other#testCaseName to "myTestCase".
    local msg is "Objects must be not equal if test case names are not equal".
    if not public#assertFalse(object#equals(other), msg) return.
}
