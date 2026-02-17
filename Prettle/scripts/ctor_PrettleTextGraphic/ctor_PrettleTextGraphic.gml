function PrettleTextGraphic(_text, _style, _left = undefined, _top = undefined, _width = undefined, _height = undefined) : PrettleGraphic(_left, _top, _width, _height) constructor {
    text = _text;
    style = _style;
    
    var _current_font = draw_get_font();
    draw_set_font(style.font);
    width ??= string_width(text);
    height ??= string_height(text);
    draw_set_font(_current_font);
    
    static draw_at = function(_x, _y) {
        draw_set_color(style.color);
        draw_set_alpha(style[$ "alpha"] ?? 1);
        draw_set_font(style.font);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text(_x + left, _y + top, text);
    }
}
