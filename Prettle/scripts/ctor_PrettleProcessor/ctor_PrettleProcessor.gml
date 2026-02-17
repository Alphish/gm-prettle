function PrettleProcessor() constructor {
    shortcode_handlers = {};
    tag_handlers = {};
    
    // -----
    // Setup
    // -----
    
    static with_shortcode_handler = function(_code, _handler) {
        shortcode_handlers[$ _code] = _handler;
        return self;
    }
    
    static with_tag_handler = function(_name, _handler) {
        tag_handlers[$ _name] = _handler;
        return self;
    }
    
    // ----------
    // Processing
    // ----------
    
    static process_sequence = function(_sequence, _config) {
        throw PrettleException.not_implemented(self, nameof(process_sequence));
    }
    
    static process_elements = function(_elements, _context) {
        for (var i = 0, _count = array_length(_elements); i < _count; i++) {
            process_element(_elements[i], _context);
        }
    }
    
    static process_element = function(_element, _context) {
        if (is_string(_element))
            process_literal(_element, _context);
        else if (is_instanceof(_element, PrettleSeparator))
            process_separator(_element.separator, _context);
        else if (is_instanceof(_element, PrettleShortcode))
            process_shortcode(_element.code, _context);
        else if (is_instanceof(_element, PrettleTag))
            process_tag(_element, _context);
        else
            throw PrettleException.processing_invalid_type(_element);
    }
    
    static process_literal = function(_text, _context) {
        throw PrettleException.not_implemented(self, nameof(process_literal));
    }
    
    static process_separator = function(_separator, _context) {
        throw PrettleException.not_implemented(self, nameof(process_separator));
    }
    
    static process_shortcode = function(_code, _context) {
        var _handler = shortcode_handlers[$ _code];
        if (is_undefined(_handler))
            throw PrettleException.processing_unknown_shortcode(_code);
        
        _handler(_code, _context);
    }
    
    static process_tag = function(_tag, _context) {
        if (_tag.opens)
            process_opening_tag(_tag, _context);
        else
            process_closing_tag(_tag, _context);
    }
    
    static process_opening_tag = function(_tag, _context) {
        var _handler = tag_handlers[$ _tag.name];
        if (is_undefined(_handler))
            throw PrettleException.processing_unknown_tag(_tag.name);
        
        _handler(_tag, _context);
    }
    
    static process_closing_tag = function(_tag, _context) {
        throw PrettleException.not_implemented(self, nameof(process_closing_tag));
    }
}
