function PrettleImageGraphic(_sprite, _image, _left, _top, _width = sprite_get_width(_sprite), _height = sprite_get_height(_sprite)) : PrettleGraphic(_left, _top, _width, _height) constructor {
    sprite = _sprite;
    image = _image;
    xoffset = sprite_get_xoffset(_sprite);
    yoffset = sprite_get_yoffset(_sprite);
    
    static with_offset = function(_xoffset, _yoffset) {
        xoffset = _xoffset;
        yoffset = _yoffset;
    }
    
    static draw_at = function(_x, _y) {
        draw_sprite(sprite, image, _x + left + xoffset, _y + top + yoffset);
    }
}
