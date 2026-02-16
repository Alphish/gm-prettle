function PrettleShortcodePattern(_delimiter, _codechars) : StrewtPattern() constructor {
    delimiter_byte = _delimiter;
    code_charset = _codechars;
    
    static skip = function(_reader) {
        var _position = _reader.position;
        if (!_reader.try_skip_byte(delimiter_byte))
            return 0;
        
        if (!_reader.skip_charset_string(code_charset)) {
            _reader.move_to(_position);
            return 0;
        }
        
        if (!_reader.try_skip_byte(delimiter_byte)) {
            _reader.move_to(_position);
            return 0;
        }
        
        return _reader.position - _position;
    }
    
    static read_into = function(_reader, _target) {
        var _position = _reader.position;
        var _target_from = buffer_tell(_target);
        var _target_to = _target_from;
        
        if (!_reader.try_skip_byte(delimiter_byte)) {
            buffer_poke(_target, _target_from, buffer_u8, 0);
            return 0;
        }
        
        var _code_bytes = _reader.skip_charset_string(code_charset);
        if (_code_bytes == 0 || !_reader.try_skip_byte(delimiter_byte)) {
            _reader.move_to(_position);
            buffer_poke(_target, _target_from, buffer_u8, 0);
            return 0;
        }
        
        buffer_copy(_reader.content_buffer, _position + 1, _code_bytes, _target, _target_from);
        buffer_poke(_target, _target_from + _code_bytes, buffer_u8, 0);
        buffer_seek(_target, buffer_seek_start, _target_to);
        return _code_bytes;
    }
}
