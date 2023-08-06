defmodule Jax do
  def help do
    :sys.get_state(ScenicDriverInky)
    %{cap: cap, inky_pid: inky_pid} = :sys.get_state(ScenicDriverInky).assigns.state
    {:ok, mycap} = RpiFbCapture.start_link()
    {:ok, frame} = RpiFbCapture.capture(mycap, :rgb24)
    pixel_data = ScenicDriverInky.process_pixels(frame.data, %{size: {250, 0}, dithering: false, color_high: 180, color_low: 75, color_affinity: :low})
  end

  def fix_pixels(pixels) do
    # Dimensions are 800 x 480
    # Pixels are currently going from {0, 0} to {799, 431}
    # Maybe it should be {799, 479}
    #
    # {0, 431}
    # {1, 431}
    # Pixels are {y, x}? But this is surprising!
    # Note: Also need to adjust the width/height

    # Enum.reduce(pixel_data, )
    # new_pixels =
    #   for x <- 0..799, y <- 432..479, into: pixels do
    #     {{x, y}, :green}
    #   end

    new_pixels =
      for x <- 720..799, y <- 0..479, into: pixels do
        {{x, y}, :white}
      end

    # DataTracer.store(pixels, key: "pixels")
    # DataTracer.store(new_pixels, key: "new_pixels")

    new_pixels
  end
end
