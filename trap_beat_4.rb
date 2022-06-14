#These file paths should be changed once samples are downloaded to your local machine

kick1 = "/Users/admin/Music/trap-beat-4/808-Kicks02.wav"
kick2 = "/Users/admin/Music/trap-beat-4/808-Kicks05.wav"
snare = "/Users/admin/Music/trap-beat-4/808-Clap05.wav"
hat1 = "/Users/admin/Music/trap-beat-4/808-HiHats07.wav"
hat2 = "/Users/admin/Music/trap-beat-4/808-HiHats10.wav"

use_bpm 74

k = [
  [1, 0, 1, 1, 2, 0, 0, 0, 1, 0, 0, 0, 2, 0, 1, 0],
  [1, 0, 0, 1, 2, 0, 0, 1, 1, 0, 0, 0, 2, 0, 1, 1],
  [1, 1, 0, 1, 2, 1, 0, 0, 1, 1, 0, 0, 2, 0, 0, 2]
]

live_loop :kick do
  r = get[:r]
  16.times do |i|
    use_random_seed 132
    sample kick1, rpitch: scale(0, :minor_pentatonic).choose if k[r][i] == 1
    sample kick2, amp: 2 if k[r][i] == 1
    sample snare, amp: 1.6 if k[r][i] == 2
    sleep 0.25
  end
end

define :h do |x, a, p, h|
  density x do
    sample h, amp: a, pan: p
    sleep 1
  end
end

live_loop :hat, sync: :kick do

  in_thread do
    with_fx :echo, decay: 2 do
      h 2, 0.5, rrand(-0.75, 0.75), hat1
    end
  end
  in_thread do
    h [4, 4, 4, 6, 6, 8, 12, 3].choose, 0.8, 0, hat2
  end
  h 2, 0.1, rrand(-0.25, 0.25), hat1
  set :r, rrand_i(0, 2)
end


live_loop :ciord, sync: :kick do
  with_fx  :tremolo, phase: 1 do
    with_fx :reverb, room: 0.7, amp: 0.6 do
      use_synth :tri
      play chord(:b3, ['6', :major7].choose, invert: rrand_i(0, 3)), attack: 3, release: 3, amp: 0.4
      sleep 8
    end
  end
end

live_loop :plk, sync: :kick do
  use_synth :pretty_bell
  use_random_seed 22
  with_fx :ring_mod, freq: :ab3, mod_amp: 0.75 do
    16.times do
      play scale(:ab2, :minor).choose, amp: 0.3, release: 0.5 if spread(11, 16).tick
      sleep 0.5
    end
  end
end


live_loop :basss, sync: :kick do
  c = (knit, 0, 16, 1, 8).tick
  with_fx :lpf, cutoff: 100 do
    with_fx :reverb, room: 0.8 do
      n = synth :blade, note: :ab3, sustain: 8, note_slide: 0.125, amp: 0.25, amp_slide: 0.125
      use_random_seed 555
      if c == 1
        32.times do
          control n, note: scale(:ab3, :minor_pentatonic, num_octaves: 2).choose, amp: rrand(0.25, 0.4)
          sleep 0.25
        end
      else
        4.times do
          control n, note: (ring, :ab4, :b3, :eb4).tick
          sleep 4
        end
      end
    end
  end
end
