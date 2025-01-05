require 'chunky_png'

class GaltonBoard
  DEFAULT_NUM_ROWS = 10
  DEFAULT_NUM_BALLS = 100_000
  IMAGE_WIDTH = 500
  IMAGE_HEIGHT = 300
  BACKGROUND_COLOR = ChunkyPNG::Color.rgb(128, 0, 128)
  DISTRIBUTION_COLOR = ChunkyPNG::Color.rgb(144, 238, 144)

  def initialize(num_rows = DEFAULT_NUM_ROWS, num_balls = DEFAULT_NUM_BALLS)
    @num_rows = num_rows
    @num_balls = num_balls
    @bin_frequencies = Array.new(num_rows * 2 + 1, 0)
  end

  def simulate
    @num_balls.times do
      bin_index = @num_rows
      @num_rows.times do
        bin_index += rand(2).zero? ? -1 : 1
      end
      @bin_frequencies[bin_index] += 1
    end
  end

  def generate_and_save_image(filename = 'galton_board.png')
    image = ChunkyPNG::Image.new(IMAGE_WIDTH, IMAGE_HEIGHT, BACKGROUND_COLOR)
    draw_distribution(image)
    image.save(filename)
    puts "Galton Board simulation completed. Image saved to: #{filename}"
  end

  private

  def draw_distribution(image)
    max_frequency = @bin_frequencies.max
    bar_width = IMAGE_WIDTH / @bin_frequencies.size

    @bin_frequencies.each_with_index do |frequency, bin_index|
      bar_height = (frequency.to_f / max_frequency * IMAGE_HEIGHT).to_i

      (0...bar_height).each do |y_offset|
        (0...bar_width).each do |x_offset|
          x = bin_index * bar_width + x_offset
          y = IMAGE_HEIGHT - y_offset - 1
          image[x, y] = DISTRIBUTION_COLOR
        end
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  num_rows = ARGV[0] ? ARGV[0].to_i : GaltonBoard::DEFAULT_NUM_ROWS
  num_balls = ARGV[1] ? ARGV[1].to_i : GaltonBoard::DEFAULT_NUM_BALLS

  galton_board = GaltonBoard.new(num_rows, num_balls)
  galton_board.simulate
  galton_board.generate_and_save_image
end