module AgriController
module_function
  
  def mcp3208
    #for MCP3208 spi ADC 8ch
    ary=[]
    dir=File.dirname(__FILE__)
    system("gpio load spi")    
    
    for num in 0..7 do 
      ary << `#{dir}/adc_a #{num}`.to_f
    end
    
    return ary
  end
  
  def wd3_wet_5e 

    
    dir=File.dirname(__FILE__)
    system("gpio load spi")
    
    ch0=`#{dir}/adc_a 0`
    ch1=`#{dir}/adc_a 1`
   #ch2=`#{dir}/adc_a 2`
    ch3=`#{dir}/adc_a 3`
    ch4=`#{dir}/adc_a 4`
   #ch5=`#{dir}/adc_a 5`
   #ch6=`#{dir}/adc_a 6`
   #ch7=`#{dir}/adc_a 7`

   #p [ch0,ch1,ch3,ch4]
    return [ch0.to_f/4096*5*100,
      ch1.to_f/4096*500,
      ch3.to_f/4096*250-10,
      ch4.to_f/4096*35,
     ]
  end
end

if $0==__FILE__
  require "rubygems"
  require "agri-controller"
  require "profile"
  include AgriController
  
  p mcp3208
  p wd3_wet_5e
end