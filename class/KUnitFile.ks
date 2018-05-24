// Wrapper around kOS files

runoncepath("kunit/class/KUnitObject").

function KUnitFile {
    declare local parameter
        kosPath,
        className is list(),
        protected is lexicon().
    className:add("KUnitFile").

    local public is KUnitObject(className, protected).
    local private is lexicon().    

    private#path is kosPath.
    
    set public#getPath to KUnitFile_getPath@:bind(public, protected, private).

    return public.
}

// Public methods.

// Public.
// Get file path.
// Raturn: kOS path structure
function KUnitFile_getPath {
    declare local parameter public, protected, private.
    return private#path.
}

// Protected methods.


