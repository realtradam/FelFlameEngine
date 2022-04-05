include Test
WHITE = Color.new(r: 255, g: 255, b: 255, a: 255)
GRAY = Color.new(r: 100, g: 100, b: 100, a: 255)

screen_width = 800
screen_height = 450

init_window(width: screen_width, height: screen_height, title: "raylib [core] example - basic window")

Test.target_fps = 60

while !window_should_close do
  begin_drawing

  clear_background(WHITE)

  draw_text(text: "Congrats! You created your first window!", posX: 190, posY: 200, fontSize: 20, color: GRAY)

  end_drawing
end
close_window
