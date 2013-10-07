package interpolation;

import massive.munit.Assert;

#if haxe3
import haxe.ds.StringMap;
#else
private typedef StringMap<T> = Hash<T>;
#end

class TemplateTest
{
    public var context:StringMap<Dynamic>;

    @Before
    public function setUp()
    {
        context = new StringMap<Dynamic>();
        context.set("name", "cj");
        context.set("age", 28);
        context.set("null", null);
    }

	@Test
	// @TestDebug
	public function testSubsititue()
	{
		var t = new Template("my name is $name,i\'m $age old.");
        Assert.areEqual('my name is cj,i\'m 28 old.', t.substitute(context));
	}

    @Test
    // @TestDebug
    public function testVariableLast()
    {
        var t = new Template("my name is $name.");
        Assert.areEqual('my name is cj.', t.substitute(context));
    }

    @Test
    @TestDebug
    public function testNull()
    {
        var t = new Template("$null");
        Assert.areEqual("null", t.substitute(context));
    }

    @Test
    // @TestDebug
    public function testSubsititueHasBracket()
    {
        var t = new Template("my name is ${name}.");
        Assert.areEqual('my name is cj.', t.substitute(context));
    }

    @Test
    @TestDebug
    public function testSubsititueHasEnscape()
    {
        var t = new Template("my name is $${name}.");
        Assert.areEqual("my name is ${name}.", t.substitute(context));
    }

    @Test
    public function testSafeSubsititue()
    {
        var t = new Template("$name");
        var context2 = new StringMap<Dynamic>();
        Assert.areEqual("$name", t.safe_substitute(context2));
    }

    @Test
    // @TestDebug
    public function testSafeSubsititueMissingRightBracket()
    {
        var t = new Template("my name is ${name.");
        Assert.areEqual("my name is ${name.", t.safe_substitute(context));
    }
}
