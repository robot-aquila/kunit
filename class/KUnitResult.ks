// Class to represent test result

runoncepath("kunit/class/KUnitObject").

// Constructor.
// Param1: string identifier of the result type (for example "fail", "ok", etc...)
// Param2: text message to describe the result (optional, default is "")
// Param3: test name (optional, default "")
// Param4: test case name (optional, default "")
// Return: result class instance
function KUnitResult {
	declare local parameter
	   type,
	   msg is "",
	   testName is "",
	   testCaseName is "",
	   className is list(),
	   protected is lexicon().
	className:add("KUnitResult").

	local public is KUnitObject(className, protected).
	
	set public#type to type.
	set public#message to msg.
	set public#testName to testName.
	set public#testCaseName to testCaseName.

	// class methods
	set public#toString to KUnitResult_toString@:bind(public).
	set public#equals to KUnitResult_equals@:bind(public).

	return public.
}

function KUnitResult_toString {
	declare local parameter public.
	local r is "".
	if public#testName <> "" {
		set r to public#testName.
		if public#testCaseName <> "" {
			set r to r + "#" + public#testCaseName.
		}
		set r to r + " ".
	}
	set r to r + public#type.	
	if public#message <> "" {
		set r to r + ": " + public#message.
	}
	return r.
}

function KUnitResult_equals {
    declare local parameter public, other.
    if public = other {
        return true.
    }
    if not public#isSameClassWith(other) {
        return false.
    }
    if public#type = other#type and
        public#message = other#message and
        public#testName = other#testName and
        public#testCaseName = other#testCaseName
    {
        return true.
    }
    return false.
}
