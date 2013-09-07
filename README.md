Interpolation
==============

[![Build Status](https://travis-ci.org/imcj/interpolation.png?branch=master)](https://travis-ci.org/interpolation)

为Haxe提供简单的字符串替换，类似perl或者shell的$符号，该类由
[PEP209](http://www.python.org/dev/peps/pep-0292/) Simpler String Substitutions
指导开发。

安装
-----

    haxelib install interpolation

使用说明
-------

    import interpolation.Template;

    var template = new Template("My name is.");
    trace(template.substitute(context));
    // My name is cj.

    var context:Hash<Dynamic> = new Hash();
    context.set("name", "cj");

TODO
-----

- [PEP3101](http://www.python.org/dev/peps/pep-3101/) Advanced String Formmating 
支持。