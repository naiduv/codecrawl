#!/usr/bin/ruby

=begin
���g�����ԉ�͂�Wavelet�ōs���A�K���Ƀt�B���^�����O�����čč\�����s��
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
    :da => 0, # �G������ 
    :de => 1, # �G���x�[�^
    :dt => 2, # �X���b�g��
    :dr => 3, # ���_�[
    :threshold => 1E4, # �Œ���̓��x��
    :plot => false,
    :prefix => "#{File.basename(__FILE__, ".*")}",
    :level_use => nil, # �������Ɏg�����x��
    :add_noise => false, # �m�C�Y���Ӑ}�I�ɍ��������邩�ǂ���
    }
    
if ARGV.empty? then
  $stderr.puts "No input file specified!!"
  exit(-1)
else
  fin = ARGV.shift
  unless '-' == fin then # �t�@�C������
    options[:in] = fin
    options[:prefix] = "#{File.basename(fin, ".*")}.ppmra"
    options[:out] = "#{options[:prefix]}.csv"
  end
end

# �I�v�V�����̃`�F�b�N
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
when :lng # �c
  mask = [:de, :dt]
  # TAS�ɂ��Ă� U0 + u �� u�̂ݒ��o
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
when :lat # ��
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

# ����
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

# �v���b�g
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

# �����Ńt�B���^�����O���s��(���낢��A�C�f�A������͂�)
# �o�C�A�X�������Ȃ����̂Ɠ��͂��K��l�ȉ��̏ꍇ�A�o�͂��J�b�g

# tfinfo��[s_{-1,0}, d_{0,0}, d_{1,0}, d_{1,1}, d_{2,0}, ...,]�̏��Ɋi�[
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
        next if options[:level_use] && options[:level_use].include?(level) # �������Ɏg��
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

# �v���b�g
if options[:plot] then
  Wavelet::plot(ref_tfinfo, plot_option.merge({
      :fname => "#{options[:prefix]}.mask.eps", :plot_power => false}))
  masked.each_with_index{|name, i|
    Wavelet::plot(masked_transformed[i], plot_option.merge({
        :fname => "#{options[:prefix]}.out.#{name}.eps"}))
  }
end

# ����
masked_recomposed = Wavelet::recompose(masked_transformed, wavelet_options)
$stderr.puts "Before: #{data.size} => After: #{masked_recomposed.size}"

# �f�[�^�������Ă���̂ŁA�����̈ʒu�ɖ߂�
masked.zip(masked_recomposed.transpose).each{|name, values|

  noise_gen = WN_Generator::new
  # �m�C�Y���Ӑ}�I�ɍ���������ꍇ
  if options[:add_noise] then
    noise = noise_sigma[name]
    values.collect!{|v| v + noise_gen::gen(0, noise)}
  end
  data_t[FlightLogReader::FLIGHT_LOG_LABELS.index(name)] = values[0...(data.size)]
}

data = data_t.transpose

# �o��
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