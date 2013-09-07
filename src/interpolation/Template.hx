package interpolation;

class Template
{
    public var template(default, null):String;
    static var debug:Bool = false;

    public function new(template:String)
    {
        this.template = template;
    }

    function is_id(char):Bool
    {
        var char_code:Int = char.charCodeAt(0);

        if ((char_code >= 65 && char_code <= 90) ||
            (char_code >= 97 && char_code <= 122) ||
            (char_code >= 48 && char_code <= 57) ||
            char == "-" || char == "_") {
            return true;
        } else {
            return false;
        }
    }

    function log(message)
    {
        if (debug)
            trace(message);
    }

    #if haxe3
    function _substitute(context:Map<String, Dynamic>, safe)
    #else
    function _substitute(context, safe)
    #end
    {
        var char:String;
        var char_code:Int;
        var output:Array<String> = [];
        var variable_name:String;
        var point_delimiter:Int = -1;
        var point_left_bracket:Int = -1;
        var point_right_bracket:Int = -1;
        var point_variable_start:Int = -1;
        var point_variable_end:Int = -1;
        var size = template.length;
        var lineno:Int = 1;
        var col:Int = 1;
        var value:String;

        var state:Int = 0;

        var state_not_interpolation:Int = 0;
        var state_interpolation:Int     = 1;
        var state_matching_variable:Int = 2;
        var state_matched_variable:Int  = 3;
        var state_escape_dollar:Int = 4;
        var error_invalid_placeholder:Int = 5;

        var state_last_character:Bool = false;

        for (i in 0...size) {
            char = template.charAt(i);
            char_code = char.charCodeAt(0);
            state_last_character = i == size - 1;

            if ("\n" == char) {
                lineno += 1;
                col = 0;
            }
            col += 1;

            if (state == state_not_interpolation) {
                if ("$" == char) {
                    point_delimiter = i;
                    point_variable_start = i + 1;
                    state = state_interpolation;

                    log("State changed to interpolation");
                }
            } else if (state == state_interpolation) {
                if ("$" == char) {
                    point_delimiter = -1;
                    point_variable_start = -1;
                    state = state_escape_dollar;
                } else if ("{" == char) {
                    point_left_bracket = i;
                    point_variable_start += 1;
                } else if ("}" == char) {
                    point_right_bracket = i;
                    point_variable_end = point_right_bracket;
                    state = state_matched_variable;

                    log("Matched right bracket and change state to matched variable.");
                } else if (" " == char || i == size - 1 || !is_id(char)) {
                    // 结束状态
                    state = state_matched_variable;
                    point_variable_end = i;

                    if (i == size - 1)
                        point_variable_end += 1;

                    if (point_left_bracket > -1) {
                        if (point_right_bracket == -1) {
                            // FIXME 没有匹配到右大括号
                            state = error_invalid_placeholder;
                            log("error: Missing right bracket.");
                        }

                        point_variable_end = i;
                    }
                    log("State matched variable");
                }
            }

            if (state == state_escape_dollar) {
                output.push("$");
                state = state_not_interpolation;
            }

            if (state == state_not_interpolation)
                output.push(char);

            if (state == state_matched_variable) {
                state = state_not_interpolation;

                variable_name = template.substring(point_variable_start, 
                                          point_variable_end);
                
                #if haxe3
                log("variable variable_name:$variable_name");
                #else
                log(Std.format("variable variable_name:$variable_name"));
                #end

                if (!context.exists(variable_name)) {
                    state = error_invalid_placeholder;
                } else {
                    value = context.get(variable_name);
                    output.push(value);

                    if (-1 == point_left_bracket && !state_last_character)
                        output.push(char);

                    point_delimiter = point_left_bracket = point_right_bracket = -1;
                    point_variable_start = point_variable_end = -1;
                }
            }

            if (state == error_invalid_placeholder) {
                if (!safe)
                    throw "Invalid placeholder in string: line " + 
                          Std.string(lineno) + 
                          ", col " + Std.string(col);
                else {
                    output.push(template.substring(point_delimiter, i + 1));
                    state = state_not_interpolation;

                    point_delimiter = point_left_bracket = point_right_bracket = -1;
                    point_variable_start = point_variable_end = -1;
                }
            }
        }

        return output.join("");
    }

    public function substitute(context)
    {
        return _substitute(context, false);
    }

    public function safe_substitute(context)
    {
        return _substitute(context, true);
    }
}
