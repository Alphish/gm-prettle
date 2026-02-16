function PrettleParser() constructor {
    method_table = new StrewtChartable(method(self, parse_literal), undefined);
    
    literal_charset = new StrewtCharset(true);
    
    separator_table = new StrewtChartable();
    
    shortcode_delimiter = "";
    shortcode_pattern = undefined;
    shortcode_delimiter_digraph = undefined;
    known_shortcodes = {};
    
    tag_begin_byte = undefined;
    tag_end_byte = undefined;
    tag_close_byte = undefined;
    tag_assign_byte = undefined;
    tag_arg_pattern = undefined;
    tag_separator_charset = undefined;
    known_open_tags = {};
    known_close_tags = {};
    blank_close_tag = new PrettleTag("", false, true, undefined, undefined);
    
    // -----
    // Setup
    // -----
    
    static with_separators = function(_separators) {
        literal_charset.excluding(_separators);
        separator_method = method(self, parse_separator);
        string_foreach(_separators, function(_ch) {
            separator_table.with_value(_ch, new PrettleSeparator(_ch));
            method_table.with_value(_ch, separator_method);
        });
        delete separator_method;
        return self;
    }
    
    static with_shortcodes = function(_delimiter, _codechars = "_0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz") {
        var _delimiter_byte = ord(_delimiter);
        var _code_charset = new StrewtCharset(false).including(_codechars);
        shortcode_delimiter = _delimiter;
        shortcode_pattern = new PrettleShortcodePattern(_delimiter_byte, _code_charset)
        shortcode_delimiter_digraph = strewt_digraph(_delimiter + _delimiter);
        
        literal_charset.excluding(_delimiter_byte);
        method_table.with_byte_value(_delimiter_byte, method(self, parse_shortcode));
        return self;
    }
    
    static with_tags = function(_begin, _end, _close, _assign, _arg = "_-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", _separators = " \r\n\t") {
        tag_begin_byte = ord(_begin);
        tag_end_byte = ord(_end);
        tag_close_byte = ord(_close);
        tag_assign_byte = ord(_assign);
        
        if (is_string(_arg)) {
            var _name_charset = new StrewtCharset(false).including(_arg);
            tag_arg_pattern = new PrettleTagStringPattern(_name_charset);
        } else {
            tag_arg_pattern = _arg;
        }
        tag_separator_charset = new StrewtCharset(false).including(_separators);
        
        literal_charset.excluding(tag_begin_byte);
        method_table.with_byte_value(tag_begin_byte, method(self, parse_tag));
        return self;
    }
    
    // -------
    // Parsing
    // -------
    
    static parse_sequence = function(_content) {
        static newline_sequences = ["\r\n", "\r", "\n"];
        
        if (is_string(_content))
            _content = string_join_ext("\n", string_split_ext(_content, newline_sequences));
        
        var _reader = new StrewtReader(_content);
        var _sequence = new PrettleSequence();
        while (!_reader.is_end_of_string()) {
            var _method = _reader.peek_chartable(method_table);
            _method(_reader, _sequence);
        }
        return _sequence;
    }
    
    static parse_literal = function(_reader, _sequence) {
        var _literal = _reader.read_charset_string(literal_charset);
        _sequence.append_literal(_literal);
    }
    
    static parse_separator = function(_reader, _sequence) {
        var _separator = _reader.read_chartable(separator_table);
        _sequence.append_element(_separator);
    }
    
    static parse_shortcode = function(_reader, _sequence) {
        if (_reader.try_skip_digraph(shortcode_delimiter_digraph)) {
            _sequence.append_literal(shortcode_delimiter);
            return;
        }
        
        var _code = _reader.read_pattern(shortcode_pattern);
        if (string_length(_code) == 0) {
            _reader.move_by(1);
            _sequence.append_literal(shortcode_delimiter);
        } else {
            known_shortcodes[$ _code] ??= new PrettleShortcode(_code);
            _sequence.append_element(known_shortcodes[$ _code]);
        }
    }
    
    static parse_tag = function(_reader, _sequence) {
        if (!_reader.try_skip_byte(tag_begin_byte))
            throw PrettleException.syntax_unopened_tag(_reader.position);
        
        var _opens = !_reader.try_skip_byte(tag_close_byte);
        var _closes = !_opens;
        
        // closing tag
        if (_closes) {
            var _closename = _reader.read_pattern(tag_arg_pattern);
            if (!_reader.try_skip_byte(tag_end_byte))
                throw PrettleException.syntax_unclosed_tag(_reader.position);
            
            if (_closename == "") {
                _sequence.append_element(blank_close_tag);
            } else {
                known_close_tags[$ _closename] ??= new PrettleTag(_closename, _opens, _closes, /* arg */ undefined, /* attrs */ undefined);
                _sequence.append_element(known_close_tags[$ _closename]);
            }
            return;
        }
        
        // opening tag
        var _name = _reader.read_pattern(tag_arg_pattern);
        var _arg = _reader.try_skip_byte(tag_assign_byte) ? _reader.read_pattern(tag_arg_pattern) : undefined;
        
        var _attributes = undefined;
        while (_reader.skip_charset_string(tag_separator_charset)) {
            _attributes ??= {};
            var _attrname = _reader.read_pattern(tag_arg_pattern);
            if (_attrname == "")
                break;
            
            if (struct_exists(_attributes, _attrname))
                throw PrettleException.parser_tag_duplicate_attribute(_reader.position - string_length(_attrname), _attrname);
            
            var _attrvalue = _reader.try_skip_byte(tag_assign_byte) ? _reader.read_pattern(tag_arg_pattern) : undefined;
            _attributes[$ _attrname] = _attrvalue;
        }
        
        _closes = _reader.try_skip_byte(tag_close_byte);
        if (!_reader.try_skip_byte(tag_end_byte))
            throw PrettleException.syntax_unclosed_tag(_reader.position);
        
        // adding the tag
        if (is_undefined(_arg) && is_undefined(_attributes)) {
            known_open_tags[$ _name] ??= new PrettleTag(_name, _opens, false, /* arg */ undefined, /* attrs */ undefined);
            if (_closes)
                known_open_tags[$ _name].closes = true;
            
            _sequence.append_element(known_open_tags[$ _name]);
        } else {
            var _tag = new PrettleTag(_name, _opens, _closes, _arg, _attributes);
            _sequence.append_element(_tag);
        }
    }
}
