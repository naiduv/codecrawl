#!/usr/bin/ruby

=begin
周波数時間解析をWaveletで行い、適当にフィルタリングをして再構成を行う
=end

$: << "~/src/eclipse/autopilot/common/param/swig/build_SWIG"
$: << "~/src/eclipse/autopilot/common/ruby"
$: << File::dirname(__FILE__)

require 'util'
require 'gsl'
require 'wavelet'
require 'gnuplot'
require 'gnuplot_support'
require 'stringio'
require 'flight_log_reader'

$stderr.puts <<-__STRING__
Usage: #{__FILE__} in.csv [options: --window=64, --out=output.csv]
__STRING__

options = {
    :in => $stdin,
    :out => $stdout,
    :window => 64,
    :order => 4,
    :mode => :lng,
    :da => 0, # エルロン 
    :de => 1, # エレベータ
    :dt => 2, # スロットル
    :dr => 3, # ラダー
    :threshold => 1E4, # 最低入力レベル
    :plot => false,
    :prefix => "#{File.basename(__FILE__, ".*")}",
    :level_use => nil, # 無条件に使うレベル
    :add_noise => false, # ノイズを意図的に混入させるかどうか
    }
    
if ARGV.empty? then
  $stderr.puts "No input file specified!!"
  exit(-1)
else
  fin = ARGV.shift
  unless '-' == fin then # ファイル入力
    options[:in] = fin
    options[:prefix] = "#{File.basename(fin, ".*")}.ppmra"
    options[:out] = "#{options[:prefix]}.csv"
  end
end

# オプションのチェック
ARGV.each{|arg|
  next unless arg =~ /^--([^=]+)=/
  k = $1.to_sym
  if op = {
      :out => proc{|s| (s == '-') ? $stdout : s},
      :window => proc{|s| s.to_i},
      :mode => proc{|s| s.to_sym},
      :da => proc{|s| s.to_i},
      :de => proc{|s| s.to_i},
      :dt => proc{|s| s.to_i},
      :dr => proc{|s| s.to_i},
      :threshold => proc{|s| s.to_f},
      :plot => proc{|s| true & eval(s)},
      :level_use => proc{|s| eval(s)},
      :add_noise => proc{|s| true & eval(s)},
      }[k] then
    options[k] = op.call($')
  else
    options[k] = $'
  end
}

$stderr.puts "opt(ppmra): " + options.inspect

data = FlightLogReader::read(options[:in], 1)
data_t = data.transpose
input_t = data_t[FlightLogReader::FLIGHT_LOG_LABELS.index(:Input)].transpose

alias d2r deg2rad
  
mask = nil
masked = nil
noise_sigma = {}
case options[:mode]
when :lng # 縦
  mask = [:de, :dt]
  # TASについては U0 + u で uのみ抽出
  target = [
      [:Pitch, d2r(0.2)], 
      [:TAS, 0.1], 
      [:AoAttack, d2r(0.5)], 
      [:AccX, 0.5], 
      [:AccZ, 0.5], 
      [:PitchRate, d2r(1)], 
      [:PitchAccel, d2r(5)]]
  masked = target.transpose[0]
  noise_sigma = Hash[*(target.flatten)]
when :lat # 横
  mask = [:da, :dr]
  target = [
      [:Yaw, d2r(1)], 
      [:Roll, d2r(0.2)], 
      [:SideSlip, d2r(0.5)], 
      [:AccY, 0.5], 
      [:RollRate, d2r(1)], 
      [:YawRate, d2r(1)], 
      [:RollAccel, d2r(5)], 
      [:YawAccel, d2r(5)]]
  masked = target.transpose[0]
  noise_sigma = Hash[*(target.flatten)]
end

raise "No filtering occured!!" unless mask

# 分解
src = []

wavelet_options = {:window_size => options[:window], :oredr => options[:order]}
mask_transformed = Wavelet::decompose( \
    mask.collect{|name|
      res = input_t[options[name]]
      if res.size < options[:window] then
        #raise "Data too short!!"
        res = res + ([res[-1]] * (options[:window] - res.size)) # padding
      end
      res
    }.transpose, \
    wavelet_options)
masked_transformed = Wavelet::decompose( \
    masked.collect{|name|
      res = data_t[FlightLogReader::FLIGHT_LOG_LABELS.index(name)]
      if res.size < options[:window] then
        #raise "Data too short!!"
        res = res + ([res[-1]] * (options[:window] - res.size)) # padding
      end
      res
    }.transpose, \
    wavelet_options)

chunk_size = mask_transformed[0][0].size
chunks = mask_transformed[0].size
tlength = data[-1][0] - data[0][0]
deltaT = tlength / data.size

# プロット
plot_option = {
    :multi_plot => true, 
    :a_logarithmic => true,
    :a_max => 1.0 / deltaT,
    :b_shift => data[0][0],
    :b_scaling => deltaT}
if options[:plot] then
  mask.each_with_index{|name, i|
    Wavelet::plot(mask_transformed[i], plot_option.merge({
        :fname => "#{options[:prefix]}.#{name}.eps"}))
  }
  masked.each_with_index{|name, i|
    Wavelet::plot(masked_transformed[i], plot_option.merge({
        :fname => "#{options[:prefix]}.in.#{name}.eps"}))
  }
end

# ここでフィルタリングを行う(いろいろアイデアがあるはず)
# バイアス成分をなくすのと入力が規定値以下の場合、出力をカット

# tfinfoは[s_{-1,0}, d_{0,0}, d_{1,0}, d_{1,1}, d_{2,0}, ...,]の順に格納
ref_tfinfo = []
chunks.times{|i|
  ref_tfinfo << ([0.0] * chunk_size)
}

mask_transformed.each{|item|
  item.each_with_index{|tfinfo, i|
    j = 0
    tfinfo.each{|v|
      ref_tfinfo[i][j] += (v ** 2)
      j += 1
    }
  }
}
masked_transformed.each{|item|
  item.each_with_index{|tfinfo, i|
    level = -1
    next_level = 0
    tfinfo.size.times{|j|
      begin
        next if options[:level_use] && options[:level_use].include?(level) # 無条件に使う
        tfinfo[j] = 0 if ref_tfinfo[i][j] < options[:threshold]
      ensure
        if j > next_level then
          level += 1
          next_level += (2**level)
        end
      end
    }
  }
}

# プロット
if options[:plot] then
  Wavelet::plot(ref_tfinfo, plot_option.merge({
      :fname => "#{options[:prefix]}.mask.eps", :plot_power => false}))
  masked.each_with_index{|name, i|
    Wavelet::plot(masked_transformed[i], plot_option.merge({
        :fname => "#{options[:prefix]}.out.#{name}.eps"}))
  }
end

# 復元
masked_recomposed = Wavelet::recompose(masked_transformed, wavelet_options)
$stderr.puts "Before: #{data.size} => After: #{masked_recomposed.size}"

# データが増えているので、削りつつ元の位置に戻す
masked.zip(masked_recomposed.transpose).each{|name, values|

  noise_gen = WN_Generator::new
  # ノイズを意図的に混入させる場合
  if options[:add_noise] then
    noise = noise_sigma[name]
    values.collect!{|v| v + noise_gen::gen(0, noise)}
  end
  data_t[FlightLogReader::FLIGHT_LOG_LABELS.index(name)] = values[0...(data.size)]
}

data = data_t.transpose

# 出力
if options[:out].kind_of?(String)
  open(options[:out], 'w'){|io|
    data.each{|item|
      io.puts item.flatten.join(',')
    }
  }
else
  data.each{|item|
    options[:out].puts item.flatten.join(',')
  } 
end