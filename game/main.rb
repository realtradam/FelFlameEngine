text = "Our poggies game engine :^)"

Rl.init_window(600, 600, text)

Rl.target_fps = 60
color = Rl::Color.new(200,50,50,255)
white = Rl::Color.new(255,255,255,255)
black = Rl::Color.new(0,0,0,255)

rect1 = Rl::Rectangle.new(50,50,10,10)
rect2 = Rl::Rectangle.new(100,50,10,10)
circ1 = Rl::Circle.new(100,100,10)
circ2 = Rl::Circle.new(100,50,10)

puts "rect1: #{rect1.x} #{rect1.y} #{rect1.w} #{rect1.h}"
puts "circ1: #{circ1.x} #{circ1.y} #{circ1.radius}"

puts "false: #{rect1.collide_with_rect? rect2}" # no
puts "true: #{rect1.collide_with_rect? rect1}" # ya

puts "false: #{circ1.collide_with_rect? rect1}" # no
puts "true: #{circ2.collide_with_rect? rect2}" # ya

puts "true: #{rect2.collide_with_circle? circ2}" # ya

puts "false: #{circ1.collide_with_circle? circ2}" # no
puts "true: #{circ1.collide_with_circle? circ1}" # ya

pause_champ = Rl::Texture.new("./assets/PauseChamp.png")
hollow = Rl::Texture.new("./assets/hollow.png")
puts "#{pause_champ.w} #{pause_champ.h}"

collect_this_texture = Rl::Texture.new("./assets/PauseChamp.png")
collect_this_texture = nil


# FelECS test
FECS::Cmp.new('Yep', x: 3)
a = FECS::Cmp::Yep.new
puts "A: #{a.x}"

y = 10
spaceing = 25
font_size = 30
blend_mode = 0

Rl.while_window_open do
  result_x = (Math.cos(Rl.time*2) * 100) + 250
  result_y = (Math.sin(Rl.time*2) * 100) + 250

  unless Rl.keys_pressed.empty?
    puts Rl.keys_pressed.to_s
  end

  if Rl.mouse_button_pressed? 0
    puts 'init audio device'
    Rl.init_audio_device
    puts 'it was init\'ed'
    boop = Rl::Sound.new("./assets/boop.wav")
    puts "Blend Mode: #{blend_mode += 1}"
  end

  Rl.draw(clear_color: black) do

    #Rl.scissor_mode(x: Rl.mouse_x - 50, y: Rl.mouse_y - 50, width: 100, height: 100) do
    if Rl.mouse_button_up? 0
      # Draw moving pausechamp face
      Rl.draw_texture(
        texture: pause_champ,
        x: result_x - 100,
        y: result_y + 200 - 140
      )
    end
    # end

    Rl.begin_blend_mode(blend_mode)
    Rl.draw_texture(
      texture: hollow,
      x: Rl.mouse_x - 50,
      y: Rl.mouse_y - 50,
      tint: white
    )

    Rl.end_blend_mode

    if Rl.key_down? 72
      pause_champ.w += 10
      pause_champ.h += 10
    end

    if Rl.key_down? 71
      pause_champ.w += 10
      pause_champ.h += 10
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
      x: 10, y: y + (spaceing * 2), font_size: font_size, color: color
    )

  end
end
