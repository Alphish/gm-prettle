function PrettleTagStringPattern(_namechars) : StrewtPattern() constructor {
    static fallback_pattern = new StringQuoteDoublingPattern();
    
    name_charset = _namechars;
    
    static skip = function(_reader) {
        var _name_read = _reader.skip_charset_string(name_charset);
        return _name_read > 0 ? _name_read : fallback_pattern.skip(_reader);
    }
    
    static read_into = function(_reader, _target) {
        var _name_read = _reader.skip_charset_string(name_charset);
        if (_name_read > 0) {
            buffer_copy(_reader.content_buffer, _reader.position - _name_read, _name_read, _target, buffer_tell(_target));
            return _name_read;
        } else {
            return fallback_pattern.read_into(_reader, _target);
        }
    }
}
