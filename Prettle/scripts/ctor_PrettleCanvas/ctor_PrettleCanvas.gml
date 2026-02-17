function PrettleCanvas(_left, _top, _width, _height, _separation = 0) constructor {
    left = _left;
    top = _top;
    width = _width;
    height = _height;
    
    rows = [];
    row_separation = _separation;
    
    static begin_row = function() {
        var _previous_row = array_last(rows);
        var _row = !is_undefined(_previous_row)
            ? new PrettleRow(0, _previous_row.top + _previous_row.height + row_separation)
            : new PrettleRow(left, top);
        array_push(rows, _row);
        return _row;
    }
    
    static draw_at = function(_x, _y) {
        for (var i = 0, _count = array_length(rows); i < _count; i++) {
            rows[i].draw_at(_x, _y);
        }
    }
}
