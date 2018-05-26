// KUnit test suite runner
@lazyglobal off.

parameter suitePath is "", testNamePattern is "", testCasePattern is "".

runoncepath("kunit/class/KUnit").
runoncepath("kunit/class/KUnitReporter").
runoncepath("kunit/class/KUnitRunner").

main().
function main {
    local suiteFile is KUnitFile(path(suitePath)).
    if not suiteFile#isDir() {
        local spath is "kunit/suite".
        print "Welcome to " + KUnit_getVersionString() + " test suite runner".
        print "Usage: ".
        print "  runpath(" + spath + ", <SUITE_DIRECTORY>, [NAME_PATTERN], [CASE_PATTERN]).".
        print " ".
        print "NOTE: Use double quotes when needed.".
        print "      KOS does not support escape sequences to show exact commands.".
        print " ".
        print "Usage examples".
        print " ".
        print "Show this help: ".
        print "  runpath(" + spath + ").".
        print " ".
        print "Run all KUnit tests: ".
        print "  runpath(" + spath + ", kunit/test).".
        print " ".
        print "Run KUnitObjectTest only: ".
        print "  runpath(" + spath + ", kunit/test, KUnitObject).".
        print "  runpath(" + spath + ", kunit/test, KUnitObjectTest).".
        print " ".
        print "Run testToString case of KUnitObjectTest only: ".
        print "  runpath(" + spath + ", kunit/test, KUnitObject, testToString).".
        print " ".
        print "Run testToString and testEquals of KUnitObjectTest: ".
        print "  runpath(" + spath + ", kunit/test, KUnitObject, test(ToString|Equals).".
        print " ".
        
        return.
    }
    local reporter is KUnitReporter().
    local runner is KUnitRunner(reporter).
    runner#suite(suiteFile, testNamePattern, testCasePattern).
    reporter#printReportSummary().
}
