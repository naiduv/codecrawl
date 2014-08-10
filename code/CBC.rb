###############################################
#		Cipher Block Chaining: Encryption and Decryption Module		#
#				Author: Mukul Sharma						#
#				Date: 09/09/2008						#
###############################################

=begin rdoc

	Cipher Block Chaining: Encryption and Decryption Module

=== Algorithms

	Cipher Block Chaining has been implemented using TEA - Tiny Encryption Algorithm as a base.

== License

	Creative Commons License

== Support

	To contact the author, send mail to elitecoder.mukul@gmail.com
	You can also visit my website at:
	http://elitecoder.mukul.googlepages.com/

	This code is a part of my Network Security (CNT5410C) Project-1. Although, Tiny Encryption Algorithm 
	has its weaknesses,	this implementation is good enough for testing and simple client-server usage.

(C) 2008 Mukul Sharma

=end

require 'digest/md5'

module CBC

	#-------------------------------------------------------------------------------------------------------------------------------------------
	# encrypt: 		Calling this function will encrypt the passed plain text message using Cipher Block Chaining method;
	# 			using passphrase as the key and Initialization Vector as a starter.
	# Return: 		Encrypted text as string
	# Parameters: 	plain_text - Plain Text Message to be encrypted
	#			pass_phrase - Password used as a key to encrypt the message
	#			init_vector - Initialization Vector
	#-------------------------------------------------------------------------------------------------------------------------------------------

	def encrypt(plain_text, pass_phrase, init_vector)

            # Obtaining a 128-bit key from the pass_phrase
			key = key_from_passphrase(pass_phrase)

			# Obtaining 2x32-bit pieces from the Intialization Vector
			# Setting up Chain Blocks which will be used in encryption
			chain_block = []
			chain_block[0] = init_vector[0]
			chain_block[1] = init_vector[1]
            
			# Padding the Plain Text Message to adhere to the required block size.
			# The number of padding characters added is also attached as a part of the padding
            # Character "@" is used as the padding character.
            pad_char = 8 - plain_text.length % 8
		
			1.upto(pad_char-1) do |i|
                plain_text = plain_text + "@"
            end
			
			plain_text = "#{plain_text}#{pad_char}"
			
			# Preparing an array to store the cipher text generated
            cipher_text = []
				
            # Each 8 characters i.e. 8x8 = 64 bits are packed as 2 integers of 32 bits each
            range = Range.new(0,plain_text.length,true)
            range.step(8) do |n|
			
                # Obtaining first integer
				num1  = plain_text[n].to_i << 24
                num1 += plain_text[n+1].to_i << 16
				num1 += plain_text[n+2].to_i << 8
                num1 += plain_text[n+3].to_i 
			
				# Obtaining second integer
				num2  = plain_text[n+4].to_i << 24
                num2 += plain_text[n+5].to_i << 16
                num2 += plain_text[n+6].to_i << 8
                num2 += plain_text[n+7].to_i  
				
				# Doing an XOR with the Initialization Vector
				# 32-bit each of plain text and initialization vector are XOR'ed with each other
				num1 = num1 ^ chain_block[0]
				num1 = num1 & 0xFFFFFFFF;
				num2 = num2 ^ chain_block[1]
				num2 = num2 & 0xFFFFFFFF;
					
				# Using TEA to encrypt the plain-text
				# Return: 2x32-bit integers
				enum1,enum2  = encrypt_tea(num1,num2,key)
                
                # Updating the value of chain block in order to XOR it with the next block of plain text
				chain_block[0] = enum1
				chain_block[1] = enum2
				
				# Storing the encrypted data in an arrray
				cipher_text << enum1
                cipher_text << enum2
				
                
            end 
          
			# Joining the encrypted values stored in the array and storing them as a string (or character sequence of 8-bits each)
			# This value is returned by the encrypt function
            cipher_text.collect { |c| sprintf("%.8x",c) }.join('')
        end

    #---------------------------------------------------------------------------------------------------------------------------------------------
	# decrypt: 		Calling this function will decrypt the passed cipher text message using Cipher Block Chaining method;
	# 			using passphrase as the key and Initialization Vector as a starter.
	#			This function also deals with eblock (block nuber of cipher text block manipulated by a snooper);
	#			if some block of cipher text is manipulated by the snooper
	# Return: 		Decrypted Plain text as string
	# Parameters: 	cipher_text - Cipher Text Message to be decrypted
	#			pass_phrase - Password used as a key to decrypt the message
	#			init_vector - Initialization Vector
	#			eblock - Block modified by a snooper
	#---------------------------------------------------------------------------------------------------------------------------------------------
	
	def decrypt(cipher_text, pass_phrase, init_vector, eblock)

		# Checking if eblock (Block number modified by the snooper) is valid or not
		if eblock > cipher_text.length/16
			puts "||\n||\t----------------------------------------------------\n"
			puts "||\teblock value is larger than number of cipher blocks."
			puts "||\t\t  Please Enter a smaller value"
			puts "||\t\t\Proceeding with eblock value as zero."
			puts "||\t----------------------------------------------------\n||\n"
			eblock = 0
		end
		
			# Obtaining a 128-bit key from the pass_phrase
			key = key_from_passphrase(pass_phrase)

			# Obtaining 2x32-bit pieces from the Intialization Vector
			# Setting up Chain Blocks which will be used in encryption
			chain_block = []
			chain_block[0] = init_vector[0]
			chain_block[1] = init_vector[1]
            
			# Preparing an array to store the plain text generated
			plain_text = []

			# This count is used as a Block Count in order to implement eblock functionality
			count = 0
			
            # Converting the Cipher Text into an array of 2 Character strings
            cipher_array = cipher_text.scan(/../)

            # Each 8 characters i.e. 8x8 = 64 bits are packed as 2 integers of 32 bits each
            range = Range.new(0,cipher_array.length,true)
			range.step(8) do |n|
			
			# This count is used as a Block Count in order to implement eblock functionality
			count += 1

			if (eblock == count)
				# Obtaining first integer
				# Values are swapped in this case, as eblock matches the block number
				num1  = cipher_array[n+7].to_i(16) << 24
                num1 += cipher_array[n+6].to_i(16) << 16
                num1 += cipher_array[n+5].to_i(16) << 8
                num1 += cipher_array[n+4].to_i(16)
			
				# Obtaining second integer
				# Values are swapped in this case, as eblock matches the block number
                num2  = cipher_array[n+3].to_i(16) << 24
                num2 += cipher_array[n+2].to_i(16) << 16
                num2 += cipher_array[n+1].to_i(16) << 8
                num2 += cipher_array[n].to_i(16) 
			else
				# Obtaining first integer
				# Values are appropriate as eblock does not match the block number
		        num1  = cipher_array[n].to_i(16)   << 24
                num1 += cipher_array[n+1].to_i(16) << 16
                num1 += cipher_array[n+2].to_i(16) << 8
                num1 += cipher_array[n+3].to_i(16)

				# Obtaining second integer
				# Values are appropriate as eblock does not match the block number
                num2  = cipher_array[n+4].to_i(16) << 24
                num2 += cipher_array[n+5].to_i(16) << 16
                num2 += cipher_array[n+6].to_i(16) << 8
                num2 += cipher_array[n+7].to_i(16) 
			end
			
                # Using TEA to decrypt the cipher-text
				# Return: 2x32-bit integers
				dnum1,dnum2  = decrypt_tea(num1,num2,key)
				
					# Doing an XOR with the Initialization Vector
					# 32-bit each of decrypted text and initialization vector are XOR'ed with each other
					# to obtain the original plain text
					dnum1 = dnum1 ^ chain_block[0]
					dnum1 = dnum1 & 0xFFFFFFFF;
					dnum2 = dnum2 ^ chain_block[1]
					dnum2 = dnum2 & 0xFFFFFFFF;
				
                # 32-bit integers dnum1 and dnum2 are bit shifted to obtain 8-bit characters and then entered into plain-text array
				plain_text << ((dnum1 & 0xFF000000) >> 24)
                plain_text << ((dnum1 & 0x00FF0000) >> 16)
                plain_text << ((dnum1 & 0x0000FF00) >> 8)
                plain_text << ((dnum1 & 0x000000FF))

                plain_text << ((dnum2 & 0xFF000000) >> 24)
                plain_text << ((dnum2 & 0x00FF0000) >> 16)
                plain_text << ((dnum2 & 0x0000FF00) >> 8)
                plain_text << ((dnum2 & 0x000000FF))
				
				# Updating the value of Chain Block in order to XOR it with the next block of cipher text
				chain_block[0] = num1
				chain_block[1] = num2
            end 
          
			# Removing the padding bits from the plain text
             pad_char = plain_text.last.chr.to_i
            (pad_char).times { |x| plain_text.pop }

			# Collecting the characters from the plain text array and joining them as a string
			# This value is returned by the decrypt function
            plain_text.collect { |c| c.chr }.join("")
        end

		############
 		private
		############
		
		# Following functions are supposed to be used by encrypt or decrypt function only and should not be used by an end user.
		
		
	#--------------------------------------------------------------------------------------------------------------------------------------------------------
	# key_from_passphrase: This function calculates the MD5 sum and gets the 128-bit key in the form or 4x32 bit integers
	# Return: 		Key consisting of 4x32 bit integers
	# Parameters: 	pass_phrase - Password used as a key to decrypt the message
	#
	# Using MD5 to obtain a 128-bit key is a widely used method and is not originally my idea.
	#--------------------------------------------------------------------------------------------------------------------------------------------------------
        
		def key_from_passphrase(pass_phrase)
            Digest::MD5.digest(pass_phrase).unpack('L*')
        end


	#--------------------------------------------------------------------------------------------------------------------------------------------------------
	# encrypt_tea: 	This function encrypts the 2x32-bit integers using the 128-bit key using Tiny Encryption Algorithm
	# Return: 		Encrypted 2x32 bit integers
	# Parameters: 	num1 - First 32-bit integer
	#			num2 - Second 32-bit integer
	#			key - 128-bit key
	#--------------------------------------------------------------------------------------------------------------------------------------------------------
       
	   def encrypt_tea(num1,num2,key)
            
			# Setting up variables for encryption operation
			y,z,sum = num1,num2,0

			# 32 cycles
            32.times do |i|
			
				# Encryption of first integer
                y   += ( z << 4 ^ z >> 5) + z ^ sum + key[sum & 3]
				
				# This step is necessary as by default, ruby variables are Bignum, which keep on getting bigger with each XOR operation
				# Thus we need to do and AND operation to get the Fixnum value.
				y   = y & 0xFFFFFFFF;

				# Value of Delta = 0x9e3779b9
                sum += 0x9e3779b9
				
				# Encryption of second integer
                z   += ( y << 4 ^ y >> 5) + y ^ sum + key[sum >> 11 & 3]
				
				# This step is necessary as by default, ruby variables are Bignum, which keep on getting bigger with each XOR operation
				# Thus we need to do this step to get the Fixnum value.
                z   = z & 0xFFFFFFFF;
				
				end
				
			# Return the encrypted integers
            return [y,z]
        end


	#--------------------------------------------------------------------------------------------------------------------------------------------------------
	# decrypt_tea: 	This function decrypts the 2x32-bit integers using the 128-bit key using Tiny Encryption Algorithm
	# Return: 		Decrypted 2x32 bit integers
	# Parameters: 	num1 - First 32-bit integer
	#			num2 - Second 32-bit integer
	#			key - 128-bit key
	#--------------------------------------------------------------------------------------------------------------------------------------------------------
     
        def decrypt_tea(num1,num2,key)
		
			# Setting up variables for encryption operation
            y,z = num1,num2
			
			# Value of Delta = 0x9e3779b9
            sum = 0x9e3779b9 << 5
			
			# 32 cycles
            32.times do |i|
			
				# Decryption of second integer
                z   -= ( y << 4 ^ y >> 5) + y ^ sum + key[sum >> 11 & 3]
				
				# This step is necessary as by default, ruby variables are Bignum, which keep on getting bigger with each XOR operation
				# Thus we need to do and AND operation to get the Fixnum value.
                z    = z & 0xFFFFFFFF;
				
				# Subtracting Delta from sum
                sum -= 0x9e3779b9
				
				# Decryption of first integer
                y   -= ( z << 4 ^ z >> 5) + z ^ sum + key[sum & 3]
				
				# This step is necessary as by default, ruby variables are Bignum, which keep on getting bigger with each XOR operation
				# Thus we need to do and AND operation to get the Fixnum value.
                y    = y & 0xFFFFFFFF;
				
				end
				
			# Return the decrypted integers
            return [y,z]
        end
		
	# Functions provided by this Module
	module_function :encrypt, :decrypt, :encrypt_tea, :decrypt_tea, :key_from_passphrase
end