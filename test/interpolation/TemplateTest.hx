package interpolation;

import massive.munit.Assert;

class TemplateTest
{
    #if haxe3
    public var context:Map<String, Dynamic>;
    #else
    public var context:Hash<Dynamic>;
    #end

    @Before
    public function setUp()
    {
        #if haxe3
        context = new Map<String, Dynamic>();
        #else
        context = new Hash<Dynamic>();
        #end
        context.set("name", "cj");
        context.set("age", 28);
        context.set("null", null);
    }

	@Test
	@TestDebug
	public function testSubsititue()
	{
		var t = new Template("my name is $name,i\'m $age old.");
        Assert.areEqual('my name is cj,i\'m 28 old.', t.substitute(context));
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
    // @TestDebug
    public function testSubsititueHasEnscape()
    {
        var t = new Template("my name is $${name}.");
        Assert.areEqual('my name is $${name}.', t.substitute(context));
    }

    @Test
    public function testSafeSubsititue()
    {
        var t = new Template("$name");
        #if haxe3
        var context2 = new Map<String, Dynamic>();
        #else
        var context2 = new Hash<Dynamic>();
        #end
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
