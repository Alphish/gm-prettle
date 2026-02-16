var _parser = new PrettleParser()
    .with_separators(" \n")
    .with_shortcodes(":")
    .with_tags("[", "]", "/", "=");

var _sequence = _parser.parse_sequence("Hello, world! :earth:\nWatch out: It's [sfx=roast/][red]scorching hot[/] today!");
array_foreach(_sequence.elements, function(_element) {
    if (is_string(_element))
        show_debug_message($"Literal: \"{_element}\"");
    else
        show_debug_message($"{instanceof(_element)}: {_element}");
});
