parser = new PrettleParser()
    .with_separators(" \n")
    .with_shortcodes(":")
    .with_tags("[", "]", "/", "=");

processor = new PrettleCanvasProcessor()
    .with_tag_values("sfx", {})
    .with_tag_values("orange", { color: c_orange })
    .with_shortcode_image("earth", spr_Emoji, 0)
    .with_shortcode_image("sun", spr_Emoji, 1);

canvas_config = {
    width: 240, height: 120, row_separation: 4, font: fnt_Test, color: c_white
    };

var _sequence = parser.parse_sequence("Hello, world! :earth:\nWatch out: It's [sfx=roast/][orange]:sun: scorching hot[/] today!");
canvas = processor.process_sequence(_sequence, canvas_config);
