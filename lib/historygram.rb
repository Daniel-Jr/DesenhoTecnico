require "mini_magick"
require "descriptive_statistics"

class Historygram
  attr_accessor :results

  def initialize(tempfile)
    @tempfile = tempfile
  end

  def process_historygram
    img = MiniMagick::Image.read(@tempfile.read)

    red_values = []
    green_values = []
    blue_values = []

    all_values = []

    rows = img.get_pixels("RGB")

    rows.each do |column|
      column.each do |channel|
        r = channel[0]
        g = channel[1]
        b = channel[2]

        red_values << r
        green_values << g
        blue_values << b

        all_values << r
        all_values << g
        all_values << b
      end
    end

    red_stats = channel_stats(red_values, "Vermelho")
    green_stats = channel_stats(green_values, "Verde")
    blue_stats = channel_stats(blue_values, "Azul")

    brightness = all_values.mean.round(2)
    contrast = all_values.standard_deviation.round(2)

    dominant_color = {
      "r" => red_values.mean.round,
      "g" => green_values.mean.round,
      "b" => blue_values.mean.round
    }

    hist_r = red_values.tally.sort.to_h
    hist_g = green_values.tally.sort.to_h
    hist_b = blue_values.tally.sort.to_h


    bpc = img["%[depth]"]

    channel_size = channel_number(img)

    bpp_total = bpc * channel_size

    @results = {
      "bcp" => bpc,
      "bpp_total" => bpp_total,
      "red_stats" => red_stats,
      "channel_size" => channel_size,
      "green_stats" => green_stats,
      "blue_stats" => blue_stats,
      "general" => {
        "brightness" => brightness,
        "contrast" => contrast,
        "dominant_color" => dominant_color
      },
      "histograms" => [
        { name: "Red", data: hist_r },
        { name: "Green", data: hist_g },
        { name: "Blue", data: hist_b }
      ]
    }
  end

  private

  def channel_stats(values, name)
    {
      "name"   => name,
      "mean"   => values.mean.round(2),
      "std"    => values.standard_deviation.round(2),
      "min"    => values.min,
      "max"    => values.max,
      "median" => values.median.round(2)
    }
  end

  def channel_number(img)
    colorspace = img["%[colorspace]"].downcase

    if colorspace.include?("rgb")
      3
    elsif colorspace.include?("cmyk")
      4
    elsif colorspace.include?("gray") || colorspace.include?("grayscale")
      1
    else
      0
    end
  end
end
