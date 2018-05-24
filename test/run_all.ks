// Run all KUnit self-tests
@lazyglobal off.

//runoncepath("kunit/test/KUnitTestTest").
//local test is KUnitTestTest().
//test#run().

runoncepath("kunit/test/KUnitObjectTest").
local test is KUnitObjectTest().
test#run().

//runoncepath("kunit/class/KUnitRunner").
//local runner is KUnitRunner("kunit/test").
//runner#run().
