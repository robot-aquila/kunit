// Class to represent test event

runoncepath("kunit/class/KUnitObject").

// Constructor.
function KUnitEvent {
	declare local parameter
	   type,               // String identifier of the event type (for example
	                       // "fail", "ok", etc...)
	   msg is "",          // Text message to describe the event (optional)
	   testName is "",     // Test name (optional) 
	   testCaseName is "", // Test case name (optional) 
	   className is list(),
	   protected is lexicon().
	className:add("KUnitEvent").

	local public is KUnitObject(className, protected).
	
	set public#type to type.
	set public#message to msg.
	set public#testName to testName.
	set public#testCaseName to testCaseName.

	// class methods
	set public#toString to KUnitEvent_toString@:bind(public).
	set public#equals to KUnitEvent_equals@:bind(public).

	return public.
}

function KUnitEvent_toString {
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

function KUnitEvent_equals {
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
