/// @desc An exception to be thrown due to invalid Prettle usage.
/// @arg {String} code              The code of the exception to differentiate between different exception causes.
/// @arg {String} description       A detailed description explaining the exception.
function PrettleException(_code, _description) constructor {
    /// @desc The code of the exception to differentiate between different exception causes.
    /// @type {String}
    code = _code;
    
    /// @desc A detailed description explaining the exception.
    /// @type {String}
    description = _description;
    
    toString = function() {
        return $"Prettle.{code}: {description}";
    }
}

PrettleException.parser_unopened_tag = function(_position) {
    return new PrettleException(
        nameof(parser_unopened_tag),
        $"Parsing error at #{_position}: Expected a tag opening character, but none was found."
        );
}

PrettleException.syntax_unclosed_tag = function(_position) {
    return new PrettleException(
        nameof(syntax_unclosed_tag),
        $"Syntax error at #{_position}: Expected a tag closing character, but none was found."
        );
}

PrettleException.parser_tag_duplicate_attribute = function(_position, _attribute) {
    return new PrettleException(
        nameof(parser_tag_duplicate_attribute),
        $"Parsing error at #{_position}: The attribute {_attribute} is duplicated."
        );
}
