// Run all KUnit self-tests
@lazyglobal off.

runoncepath("kunit/class/KUnitReporter").
local reporter is KUnitReporter().

//runoncepath("kunit/test/KUnitObjectTest").
//local test is KUnitObjectTest().
//test#run().

//runoncepath("kunit/test/KUnitResultTest").
//local test is KUnitResultTest().
//test#run().

//runoncepath("kunit/test/KUnitResultBuilderTest").
//local test is KUnitResultBuilderTest().
//test#run().

//runoncepath("kunit/test/KUnitPrinterTest").
//local test is KUnitPrinterTest().
//test#run().

//runoncepath("kunit/test/KUnitCounterTest").
//local test is KUnitCounterTest().
//test#run().

runoncepath("kunit/test/KUnitReporterTest").
local test is KUnitReporterTest(reporter).
test#run().

//runoncepath("kunit/test/KUnitTestTest").
//local test is KUnitTestTest().
//test#run().

//runoncepath("kunit/class/KUnitRunner").
//local runner is KUnitRunner("kunit/test").
//runner#run().

reporter#printReportSummary().
