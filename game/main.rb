text = "Our poggies game engine :^)"

Rl.init_window(600, 600, text)

Rl.target_fps = 60
color = Rl::Color.new(200,50,50,255)
white = Rl::Color.new(255,255,255,255)

pause_champ = Rl::Texture.new("./assets/PauseChamp.png")

y = 10
spaceing = 25
font_size = 30

Rl.while_window_open do
  result_x = (Math.cos(Rl.time*2) * 100) + 250
  result_y = (Math.sin(Rl.time*2) * 100) + 250

  unless Rl.keys_pressed.empty?
    puts Rl.keys_pressed.to_s
  end

  Rl.begin_drawing
  Rl.clear_background

  if Rl.is_key_up? 87
    # Draw moving pausechamp face
    Rl.draw_texture(
      texture: pause_champ,
      x: result_x - 100,
      y: result_y + 200 - 140
    )
  end

  Rl.draw_text(
    text: "mouse wheel:#{Rl.mouse_wheel}",
    x: 350,
    y: y + (spaceing*2),
    font_size: font_size,
    color: color
  )

  Rl.draw_text(
    text: "mouse x: #{Rl.mouse_x}",
    x: 350,
    y: y,
    font_size: font_size,
    color: color
  )

  Rl.draw_text(
    text: "mouse y: #{Rl.mouse_y}",
    x: 350,
    y: y + spaceing,
    font_size: font_size,
    color: color
  )

  # Draw moving text
  Rl.draw_text(
    text: text,
    x: result_x - 120,
    y: result_y + 200,
    font_size: 25,
    color: color
  )

  # Draw Fps
  Rl.draw_text(
    text: "FPS: #{Rl.fps.to_s}",
    x: 10,
    y: y,
    font_size: font_size,
    color: color
  )

  # Draw Frametime
  Rl.draw_text(
    text: "Frametime: #{"%.4f" % Rl.frame_time}",
    x: 10,
    y: y + spaceing,
    font_size: font_size,
    color: color
  )

  # Draw Elapse Time
  Rl.draw_text(
    text: "Elapsed Time: #{"%.2f" % Rl.time}",
    x: 10, y: y + (spaceing * 2), font_size: font_size, color: color)

  Rl.end_drawing
end
