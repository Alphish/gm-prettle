function PrettleCanvasProcessor() : PrettleProcessor() constructor {
    // -----
    // Setup
    // -----
    
    static with_shortcode_image = function(_name, _sprite, _image) {
        return with_shortcode_handler(_name, method({ sprite: _sprite, image: _image }, function(_context) {
            _context.pen.append_image(sprite, image);
        }));
    }
    
    static with_tag_values = function(_name, _values) {
        return with_tag_handler(_name, method(_values, function(_tag, _context) {
            _context.pen.push_values(self);
        }));
    }
    
    // ----------
    // Processing
    // ----------
    
    static process_sequence = function(_sequence, _config) {
        var _canvas = new PrettleCanvas(0, 0, _config.width, _config.height, _config.row_separation);
        var _style = { font: _config.font, color: _config.color };
        var _pen = new PrettlePen(_canvas, _style);
        var _context = { canvas: _canvas, pen: _pen };
        process_elements(_sequence.elements, _context);
        _context.pen.finish();
        return _context.canvas;
    }
    
    static process_literal = function(_text, _context) {
        _context.pen.append_text(_text);
    }
    
    static process_separator = function(_separator, _context) {
        switch (_separator) {
            case " ":
                _context.pen.append_space();
                break;
            case "\n":
                _context.pen.append_line();
                break;
            default:
                throw "Unknown separator.";
        }
    }
    
    static process_shortcode = function(_code, _context) {
        var _handler = shortcode_handlers[$ _code];
        if (is_undefined(_handler))
            throw $"Unknown shortcode {_code}";
        
        _handler(_context);
    }
    
    static process_tag = function(_tag, _context) {
        if (_tag.opens) {
            var _handler = tag_handlers[$ _tag.name];
            if (is_undefined(_handler))
                throw $"Unknown tag {_tag.name}";
            
            _handler(_tag, _context);
        } else {
            _context.pen.pop_style();
        }
    }
}
