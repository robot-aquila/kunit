// Builder of a test result

runoncepath("kunit/class/KUnitObject").
runoncepath("kunit/class/KUnitResult").

function KUnitResultBuilder {
    declare local parameter
        testName is "",
        testCaseName is "",
        className is list(),
        protected is lexicon().
    className:add("KUnitResultBuilder").

    local public is KUnitObject(className, protected).
    local private is lexicon().
    
    set private#testName to testName.
    set private#testCaseName to testCaseName.
    
    set public#setTestName to KUnitResultBuilder_setTestName@:bind(public, private).
    set public#setTestCaseName to KUnitResultBuilder_setTestCaseName@:bind(public, private).
    set public#buildFailure to KUnitResultBuilder_buildFailure@:bind(public, private).
    set public#buildSuccess to KUnitResultBuilder_buildSuccess@:bind(public, private).
    set public#buildError to KUnitResultBuilder_buildError@:bind(public, private).
    set public#buildExpectationFailure to KUnitResultBuilder_buildExpectationFailure@:bind(public, private).
    
    return public. 
}

function KUnitResultBuilder_setTestName {
    declare local parameter public, private, testName.
    set private#testName to testName.
}

function KUnitResultBuilder_setTestCaseName {
    declare local parameter public, private, testCaseName.
    set private#testCaseName to testCaseName.
}

function KUnitResultBuilder_buildFailure {
    declare local parameter public, private, msg, clarification is "".
    if msg:length > 0 and clarification:length > 0 {
        set msg to msg + ". " + clarification.
    }
    return KUnitResult("failure", msg, private#testName, private#testCaseName).
}

function KUnitResultBuilder_buildSuccess {
    declare local parameter public, private.
    return KUnitResult("success", "", private#testName, private#testCaseName).
}

function KUnitResultBuilder_buildError {
    declare local parameter public, private, msg.
    return KUnitResult("error", msg, private#testName, private#testCaseName). 
}

function KUnitResultBuilder_buildExpectationFailure {
    declare local parameter public, private, msg, clarification, expected, actual.
    set clarification to clarification
        + ": expected: <[" + expected + "]> but was <[" + actual + "]>".
    return public#buildFailure(msg, clarification).
}
