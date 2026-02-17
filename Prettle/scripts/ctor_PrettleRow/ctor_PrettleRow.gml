function PrettleRow(_left, _top) constructor {
    left = _left;
    top = _top;
    width = 0;
    height = 0;
    
    items = [];
    
    static append_items = function(_items) {
        array_copy(items, array_length(items), _items, 0, array_length(_items));
        for (var i = 0, _count = array_length(_items); i < _count; i++) {
            width = (_items[i].left + _items[i].width) - left;
            height = max(height, (_items[i].top + _items[i].height) - top);
        }
    }
    
    static draw_at = function(_x, _y) {
        for (var i = 0, _count = array_length(items); i < _count; i++) {
            items[i].draw_at(_x, _y);
        }
    }
}
