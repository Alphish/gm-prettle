function PrettlePen(_canvas, _style) constructor {
    canvas = _canvas;
    current_row = canvas.begin_row();
    current_style = _style;
    cursor_x = current_row.left;
    cursor_y = current_row.top;
    
    pending_span = [];
    pending_styles = [];
    
    static append_text = function(_text) {
        var _graphic = new PrettleTextGraphic(_text, current_style, cursor_x, cursor_y);
        append_graphic(_graphic);
    }
    
    static append_image = function(_sprite, _image) {
        var _graphic = new PrettleImageGraphic(_sprite, _image, cursor_x, cursor_y);
        append_graphic(_graphic);
    }
    
    static append_space = function() {
        complete_span();
        var _previous_font = draw_get_font();
        draw_set_font(current_style.font);
        cursor_x += string_width(" ");
        draw_set_font(_previous_font);
    }
    
    static append_line = function() {
        complete_span();
        current_row = canvas.begin_row();
        cursor_x = current_row.left;
        cursor_y = current_row.top;
    }
    
    static append_graphic = function(_graphic) {
        array_push(pending_span, _graphic);
        cursor_x += _graphic.width;
    }
    
    static finish = function() {
        complete_span();
    }
    
    static complete_span = function() {
        var _last = array_last(pending_span);
        if (!is_undefined(_last) && _last.left + _last.width > canvas.left + canvas.width) {
            var _previous_row = current_row;
            current_row = canvas.begin_row();
            var _xoffset = current_row.left - array_first(pending_span).left;
            var _yoffset = current_row.top - _previous_row.top;
            
            for (var i = 0, _count = array_length(pending_span); i < _count; i++) {
                var _item = pending_span[i];
                _item.shift_by(_xoffset, _yoffset);
            }
            cursor_x += _xoffset;
            cursor_y += _yoffset;
        }
        current_row.append_items(pending_span);
        array_resize(pending_span, 0);
    }
    
    // ------
    // Styles
    // ------
    
    static push_style = function(_style) {
        array_push(pending_styles, current_style)
        current_style = _style;
    }
    
    static push_values = function(_values) {
        array_push(pending_styles, current_style)
        current_style = variable_clone(current_style);
        struct_foreach(_values, function(_key, _value) {
            current_style[$ _key] = _value;
        });
    }
    
    static pop_style = function() {
        current_style = array_pop(pending_styles);
    }
}
