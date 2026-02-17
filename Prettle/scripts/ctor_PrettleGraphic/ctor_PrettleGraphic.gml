function PrettleGraphic(_left = undefined, _top = undefined, _width = undefined, _height = undefined) {
    left = _left;
    top = _top;
    width = _width;
    height = _height;
    
    static move_to = function(_left, _top) {
        left = _left;
        top = _top;
    }
    
    static shift_by = function(_x, _y) {
        left += _x;
        top += _y;
    }
}
