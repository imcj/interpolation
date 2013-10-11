Interpolation
==============

[![Build Status](https://travis-ci.org/imcj/interpolation.png?branch=master)](https://travis-ci.org/interpolation)

You can use interpolation to perform string interpolation, using $ to identify the variables in the string :

Install
--------

    haxelib install interpolation

Using
------

    import interpolation.Template;

    var template = new Template("My name is $name.");
    var context:Hash<Dynamic> = new Hash();
    context.set("name", "cj");

    trace(template.substitute(context));
    // will trace "My name is cj".

You can also use {} curly braces to enclose a whole expression :

    var template = new Template("My name is ${name}.");
    var context:Hash<Dynamic> = new Hash();
    context.set("name", "cj");

    trace(template.substitute(context));
    // will trace "My name is cj".

If you want to output a single $, you can use $$ :

    var template = new Template("My name is $$name.");
    var context:Hash<Dynamic> = new Hash();
    context.set("name", "cj");

    trace(template.substitute(context));
    // will trace "My name is $name".

Feature
--------

[PEP209](http://www.python.org/dev/peps/pep-0292/) Simpler String Substitutions

TODO
-----

- [PEP3101](http://www.python.org/dev/peps/pep-3101/) Advanced String Formmating