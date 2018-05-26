// Test runner

runoncepath("kunit/class/KUnitObject").
runoncepath("kunit/class/KUnitReporter").
runoncepath("kunit/class/KUnitResultBuilder").

function KUnitRunner {
    declare local parameter
        suiteRootDir,
        reporter is KUnitReporter(),
        filePattern is "test\.ksm?$",
        .
    
    local protected is lexicon().
    local public is KUnitObject("KUnitRunner", protected).
    local private is lexicon().
    
    set private#suiteRootDir to suiteRootDir.
    set private#reporter to reporter.
    set private#filePattern to filePattern.
    set private#resultBuilder to KUnitResultBuilder().
    
    set private#scanForTests to KUnitRunner_scanForTests@:bind(public, protected, private).
    
    set public#run to KUnitRunner_run@:bind(public, protected, private).
        
    return public.
}

function KUnitRunner_run {
    declare local parameter public, protected, private.
    local reporter is private#reporter.
    local resultBuilder is private#resultBuilder.
    local suiteRootDir is private#suiteRootDir.
    
    //local parentItem is volume():open(suiteRootDir).
    //if parentItem:isfile {
    //    local result is resultBuilder#buildError("Invalid root directory: " + suiteRootDir).
    //    reporter#notifyOfError(result).
    //    return.
    //}
    //local filePattern is private#filePattern.
    //for childItem in parentItem {
    //    if childItem:name:matchespattern(filePattern) {
    //        parentItem
    //        print "found: " + childItem.
    //    }
    //}
    local resultFiles is list().
    private#scanForTests(resultFiles, suiteRootDir).
}

function KUnitRunner_scanForTests {
    declare local parameter public, protected, private,
        resultFiles,    // list of kOS path structures pointed to selected files
        dir.            // string path to directory to scan
    local reporter is private#reporter.
    local resultBuilder is private#resultBuilder.
    local filePattern is private#filePattern.
    
    local dirPath is path(dir).
    if not exists(dirPath) {
        local result is resultBuilder#buildError("Path not exists: " + dir).
        reporter#notifyOfError(result).
        return false.
    }
    
    local parentItem is volume():open(dir).
    if parentItem:isfile {
        local result is resultBuilder#buildError("Expected is directory but was file: " + dir).
        reporter#notifyOfError(result).
        return false.
    }
    
    for childItem in parentItem {
        if childItem:name:matchespattern(filePattern) {
            local childPath is dirPath:combine(childItem:name).
            
            
            print "found: " + childPath.
        }
    }

    return true.
}

