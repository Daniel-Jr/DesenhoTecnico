class HistorygramJob < ApplicationJob
  queue_as :default

  def perform(image)
    # Load the image
    img = Magick::Image.from_blob(image.image.blob.download).first

    width = img.columns
    height = img.rows

    # Arrays para armazenar valores de intensidade (0-255) de cada canal
    red_values = []
    green_values = []
    blue_values = []

    # Array para todos os valores de intensidade para Brilho/Contraste geral
    all_values = []

    # 1. Separar canais e coletar dados
    img.each_pixel do |x, y|
      r = scale_pixel_value(img.pixel_color(x, y).red)
      g = scale_pixel_value(img.pixel_color(x, y).green)
      b = scale_pixel_value(img.pixel_color(x, y).blue)

      red_values << r
      green_values << g
      blue_values << b

      all_values << r
      all_values << g
      all_values << b
    end

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

    self.metadata = {
      "red_stats" => red_stats,
      "green_stats" => green_stats,
      "blue_stats" => blue_stats,
      "general" => {
        "brightness" => brightness,
        "contrast" => contrast,
        "dominant_color" => dominant_color
      },
      # Os histogramas são arrays de {intensidade => contagem}
      "histograms" => {
        "r" => hist_r,
        "g" => hist_g,
        "b" => hist_b
      }
    }
  end
end
