function PrettleSequence() constructor {
    elements = [];
    last_element = undefined;
    
    static append_literal = function(_literal) {
        if (is_string(last_element)) {
            last_element += _literal;
            elements[array_length(elements) - 1] = last_element;
        } else {
            array_push(elements, _literal);
            last_element = _literal;
        }
    }
    
    static append_element = function(_element) {
        array_push(elements, _element);
        last_element = _element;
    }
}
