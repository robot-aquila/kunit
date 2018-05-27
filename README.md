# KUnit - Unit Testing framework for kerboscript

#### Note: This project is not part of [KOS project](https://github.com/KSP-KOS/KOS). Please don't ask to do something with KOS.

KUnit provides possibility to write repeatable tests for kerboscript -
[KOS programming language](https://github.com/KSP-KOS/KOS). KUnit is an
instance of the xUnit architecture for unit testing frameworks.

KUnit also demonstrates how to use object-oriented approach in KOS
programs to achieve well-looking design, maximum code reusability and
exceptional software quality.


## Professor Kobert informs you of possible risks

* Higher level - you can use object#member calling signature in your programs
but keep in mind that availability of such approach may be terminated by kOS
maintainers. In case if it is terminated you will be forced to rewrite all your
classes for official supported syntax with object["member"] calling signature. 
Possible, KUnit maintainers will provide a tool for automatical refactoring
but no promises.

* Lower level - you can use object["member"] calling signature in your
programs. This should work while kOS supports binding code with variables.
That is official KOS feature with low risk to disapper.

* Lowest level - you can use ancient procedural approach which is officially
supported by KOS. In this case you'll never face with problems around
object-oriented programming on KOS.

* Zero level - you can use any other language to write your programs for
[KSP](https://www.kerbalspaceprogram.com/en/).
In this case you'll never face with problems programming on KOS.

## Get started

To get started just run KUnit unit tests. Let's assume that you placed KUnit to
Archive volume. Open KOS terminal and run:
```
runpath("kunit/suite", "kunit/test").
```


TODO:

## How to run

TODO:

### How to write Unit Tests

To get started have a look on files in kunit/examples. Those classes are
especially simplified. Some useful (I hope) comments are provided.


Also KUnit covered by self-tests. Those tests have lot examples of basics and
tricks how to test your code. Study it and you could do TDD as pro. All KUnit
self-tests are located in kunit/test subdirectory of project root. 


## Known issues

### KOS bugs

The most critical issue is that KOS have a very unpleasant bug which appeared
often when you coding TDD + OOP. In such case you run your test often and you
have lot calls on stack. In case if you mistaked in variable name sometimes KOS
cannot handle stack and that leads to KSP chash. The problem is that situation
cannot be easily reproduced in automated test. When we try then we get an
expected KOS behavior. But we will keep trying. Project crash_cases directory
contains description of issues. They are definitely bugs and do not related to
object-oriented programming or unit testing only. They may appear any time you
work kerboscript. KUnit developers informed KOS maintainers about that case and
hope this kind of bugs will be fixed soon.

### Don't make protected class attributes

Combination of inheritance and calling parent may lead to a mess with
references. Making a shallow copy of parent protected interface means you will
get two independent copies of attributes if they are primitive types. Better to
keep all properties private and use protected mutator/accessor to provide an
access to them for derived classes.

### Where object#member does not work

In some cases referencing with # does not work
```
print "PRINT ME: " + ("" + private#numTests). 
```
Use official syntax instead of code above
```
print "PRINT ME: " + ("" + private["numTests"]).
```

## What would be nice to get better OOP on top of KOS

* Having three lexicons for those scopes: public, protected and private is most
significant problem while programming OOP on KOS. It causes lot problems with
method declaration and definition. There should be an adequate analogue for
visibility specificators.

* TDA (tell, don't ask) principle does not work well without possibility to
force call stack. Exceptions support would be nice and useful feature. Also TDA
means we do not want to negotiate interfaces. We want to tell of interfaces.
Type checking is very desirable feature in weak typed language. Something like
PHP type hinting would be great addition to provide strong contract declaration.
