require 'libusb'
require 'socket'
# a program to dump hid datagrams from mysterious hid devices

class VLC
  def initialize
    @vlc_pid = 0
  end
  def start_vlc(source_location)
    return if @vlc_pid != 0
    File.delete("/tmp/vlc_command") if File.exists?("/tmp/vlc_command")
    @vlc_pid = fork { exec("vlc --extraintf rc --rc-unix /tmp/vlc_command --fullscreen #{source_location}")}
    while(!File.exists?("/tmp/vlc_command"))
    end
    @vlc_socket = UNIXSocket.open("/tmp/vlc_command")
    sleep(3)
    Thread.new { 
      while(1) 
        @vlc_socket.getc() # this will eventually throw when the socket closes but we don't care
      end
    }
  end

  def puts(string)
    return if @vlc_pid == 0
    begin 
      @vlc_socket.puts(string)
    rescue Exception => e
      Kernel.puts "An error occured writing to VLC."
      end_thread
    end
  end

  def stop_vlc
    return if @vlc_pid == 0
    puts("quit")
    end_thread
  end

  def end_thread
    return if @vlc_pid == 0
    Process.waitpid(@vlc_pid)
    @vlc_pid = 0
  end
end 

# put your vendor/product id here (lsusb can help you find that)
high_speed = false
vlc = VLC.new
device = USB.device_matching(0x0480, 0x001)

endpoint = device.endpoints.detect { |e| 
  e.interface.hid? and 
  e.type.string_value == "USB_ENDPOINT_TYPE_INTERRUPT" and
  e.input? }
endpoint.interface.detach_kernel

tries_remaining = 5
reports = nil
while(tries_remaining > 0 and reports.nil?)
  begin
    reports = endpoint.interface.hid_reports
  rescue USB::UsbException => e
    puts "Could not get reports"
    tries_remaining = tries_remaining - 1
  end
end
raise "Could not initialize reports desipte several attempts" if reports.nil?
endpoint.interface.listen_for_hid_interrupts { |interface|
  while(1) 
    data = interface.next_interrupt
    puts data
    if(data.report_id == 1)
      button_code = data.values[0]
      case button_code
       when 5
        vlc.puts "next"
       when 4
        vlc.puts "prev"
       when 3
         # cd icon
        vlc.start_vlc("/dev/dvd")
       when 2
        `mount /dev/dvd /mnt/dvd`
        vlc.start_vlc("/mnt/dvd")
       when 1
        puts "Tape"
         vlc.start_vlc("--random /home/hewner/amv")
       when 12
        vlc.stop_vlc
      when 20
        vlc.puts "fastforward"
      when 19
        vlc.puts "pause"
      when 18
        vlc.puts "pause"
      when 17
        vlc.puts "rewind"
      when 10
        # moon
        vlc.stop_vlc
        `eject /dev/dvd`
      when 22
        vlc.puts "voldown 1"
      when 21
        vlc.puts "volup 1"
      end
    end
  end
}


