# KUnit - Unit Testing framework for kerboscript

#### Note: This project is not part of [KOS project](https://github.com/KSP-KOS/KOS). Please don't ask to do something with KOS.


## What is it?

KUnit provides possibility to write repeatable tests for kerboscript -
[KOS programming language](https://github.com/KSP-KOS/KOS). KUnit is an
instance of the xUnit architecture for unit testing frameworks.

KUnit also demonstrates how to use object-oriented approach in KOS
programs to achieve well-looking design, maximum code reusability and
exceptional software quality.


## Professor Kobert informs you of possible risks

* Higher level - you can use object#member calling signature in your programs
but keep in mind that supporting such approach may be terminated by kOS
maintainers. In case if it is terminated you will forced to rewrite all your
classes for official supported syntax with object["member"] calling signature. 
Possible, KUnit maintainers will provide a tool for automatical refactoring
but no promises.

* Lower level - you can use object["member"] calling signature in your
programs. This should work while kOS supports binding code with variables.
That is official KOS feature with low risk to disapper.

* Lowest level - you can use ancient procedural approach which is officially
supported by KOS. In this case you'll never face with problems around
object-oriented programming on KOS.

* Zero level - you can use any other language to write your programs for KSP.
In this case you'll never face with problems programming on KOS.


## What KOS must have to provide better programming

* There is only one point. Project crash_cases directory contains description
of some issues. They are definitely bugs and do not related to object-oriented
programming or unit testing only. They may appear any time you kerboscript
works. They must be fixed.


## What would be nice to provide to get better OOP on top of KOS

* Having three lexocons for those scopes: public, protected and private is most
significant problem while programming OOP on KOS. It causes lot problems with
method declaration and definition. There should be an adequate analogue for
visibility specificators.

* TDA (tell, don't ask) principle does not work well without possibility to
force call stack. Exceptions support would be nice and useful feature.

