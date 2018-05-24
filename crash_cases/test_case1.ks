@lazyglobal off.

// Not yet done.
// Still unable to reproduce test case automatically.

// The Case: Calling object member on wrong variable causes KSP crash.
// Example1:
//
//function KUnitObject_equals {
//    declare local parameter public, protected, private, other.
//    if other = public {
//        return true.
//    }
//    if not public#isSameClassWith(other) {
//        return false.
//    }
//    //if object#getRefID() = public#getRefID() {
//    if object["getRefID"]() = public["getRefID"]() {
//       ^^^^^ IT MUST BE other
//       Calling this causes KSP crash.
//       But reproduce it from a clear leaf is hard.
//       Possible the current stack state is matters.
//       That does not matter what reference syntax is used: o#x or o["x"]
//       Both lead to crash.
//
//        return true.
//    } else {
//        return false.
//    }
//}
//
//
// Example2:
//function KUnitObject_isSameClassWith {
//    declare local parameter public, protected, private,
//        other.  // Value to test. It must be at least lexicon or
//                // runtime error will occur.
//        
//    if not KUnitObject_isObject(other) {
//        return false.
//    }
//    if object#getClassName() = public#getClassName() {
//       ^^^^^^ IT MUST BE other
//        return true.
//    }
//    return false.
//}
//
