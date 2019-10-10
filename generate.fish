#!/usr/bin/env fish

mkdir -p videos sounds images

set colors '#000000' '#ffffff' '#ff0000' '#00ff00' '#0000ff' '#ffff00' '#ff00ff' '#00ffff'
set sizes 1920x1080 1920x1200 1280x720
for color in $colors
  for size in $sizes
    convert -size $size xc:$color images/$color-$size.png
  end
end

ffmpeg -y -f lavfi -i testsrc=duration=10:size=1280x720:rate=30 -qscale 0 videos/testsrc.mpg

set frequencies 432 440
for frequency in $frequencies
  ffmpeg -y -f lavfi -i "sine=frequency=$frequency:sample_rate=48000:duration=5" -c:a pcm_s16le -ac 2 sounds/$frequency'hz.wav'
  ffmpeg -y -i sounds/$frequency'hz.wav' -af 'pan=stereo|FR=FR' -c:v copy sounds/$frequency'hzr.wav'
  ffmpeg -y -i sounds/$frequency'hz.wav' -af 'pan=stereo|FL=FL' -c:v copy sounds/$frequency'hzl.wav'
end

set noises pink white
for noise in $noises
  ffmpeg -y -f lavfi -i "anoisesrc=d=5:c=$noise:r=48000:a=0.5" -c:a pcm_s16le -ac 2 sounds/$noise.wav
  ffmpeg -y -i sounds/$noise'.wav' -af 'pan=stereo|FR=FR' -c:v copy sounds/$noise'r.wav'
  ffmpeg -y -i sounds/$noise'.wav' -af 'pan=stereo|FL=FL' -c:v copy sounds/$noise'l.wav'
end