#!/usr/bin/env ruby
# -*- coding: sjis -*-

require 'optparse'
require 'nkf'

class Replace
	DEFAULT_LOG = 'replace.log'
	WIDTH = 9	# ���ʂ�\������Ƃ��̊e�^�C�g���̕\����

	@@options = nil
	@@opts = nil

	def self.action(argv)
		@@options = Hash.new

		@@opts = OptionParser.new
		@@opts.banner = "Usage: #{File.basename(__FILE__)} (regexp | -r regexp_file) replacement target [options]\n" \
					+   "       #{File.basename(__FILE__)} --restore       [log_file]\n" \
					+   "       #{File.basename(__FILE__)} --delete-backup [log_file]\n\n"

		@@opts.program_name = "replace.rb"
		@@opts.version = "2.0"
		@@opts.release = "beta"
		@@opts.on('-r', '--regexp  regexp_file', 'Search pattern') {|var| @@options[:regexp] = var}
		@@opts.on('-y', "Don't display confirmation messages") {|val| @@options[:yes] = true}
		@@opts.on('-c', '--confirm', "Confirm update files (don't update)") { @@options[:confirm] = true}
		@@opts.on('-b', '--backup  [add_suffix]', '(default: .bak)') {|var| @@options[:backup] = (var ? var : ".bak")}
		@@opts.on('--limit   max_update_file_num') {|var| @@options[:limit] = var}
		@@opts.on('-l', '--log           [log_file]', '(default: replace.log)') {|var| @@options[:log] = (var ? var : DEFAULT_LOG)}
		@@opts.separator " "
		@@opts.on('--restore       [log_file]', '(default: replace.log)') {|var| @@options[:restore] = (var ? var : DEFAULT_LOG)}
		@@opts.on('-d', '--delete-backup [log_file]', '(default: replace.log)') {|var| @@options[:delete_backup] = (var ? var : DEFAULT_LOG)}

		begin
			@@opts.parse!(argv)
		rescue
			puts "�����ȃp�����[�^���w�肳��܂����B"
			puts @@opts
			exit
		end

		# �I�v�V�����m�F
		if @@options[:restore]
			if 2 <= @@options.length
				puts "restore�I�v�V�����͑��̃I�v�V�����ƕ��p�ł��܂���B"
				exit
			end
			self.restore(@@options[:restore])
		elsif @@options[:delete_backup]
			if 2 <= @@options.length
				puts "delete-backup�I�v�V�����͑��̃I�v�V�����ƕ��p�ł��܂���B"
				exit
			end
			self.delete_backup @@options[:delete_backup]
		else
			self.replace(argv)
		end
	end

	def self.replace(argv)
		if ARGV.size < 3 - (@@options[:regexp] ? 1 : 0)
			puts "�p�����[�^������܂���B"
			puts @@opts
			exit
		end

		# regexp
		if @@options[:regexp]
			regexp_src = file_get_contents(@@options[:regexp])[0]
		else
			regexp_src = argv.shift.dup
			regexp_src.force_encoding(NKF.guess(regexp_src))
		end
		regexp = regexp_src.encode('UTF-8')
		begin
			regexp = eval(regexp)
		rescue Exception => err
			print "�p�����[�^ regexp ���s���ł��B\n\n"
			puts err
			exit
		end
		unless regexp.kind_of?(Regexp)
			puts "�p�����[�^ regexp ���s���ł��B"
			exit
		end

		# replacement
		replacement = argv.shift.dup
		replacement = replacement.encode('UTF-8', NKF.guess(replacement))
		# \n,\t,\\ �̃G�X�P�[�v������
		replacement = replacement.gsub(/\\([nt\\])/) do |matched|
			case($1)
				when 'n'
					"\n"
				when 't'
					"\t"
				else
					$1
			end
		end

		# �I�v�V�����`�F�b�N
		# �o�b�N�A�b�v
		if @@options[:backup] and %r{[\\/:*?"<>|]} =~ @@options[:backup]
			puts "�o�b�N�A�b�v�t�@�C���̃T�t�B�b�N�X�w�肪�s���ł��B(#{@@options[:backup]})"
			exit
		end
		# �ő�X�V�t�@�C�����i1�ȏ�̐����j
		if @@options[:limit] and /^[1-9]\d*$/ !~ @@options[:limit]
			puts "�ő�X�V�t�@�C�����̎w�肪�s���ł��B(#{@@options[:limit]})"
			exit
		end
		# ���O
		if @@options[:log] and /[*?"<>|]/ =~ @@options[:log]
			puts "���O�o�̓t�@�C�������s���ł��B(#{@@options[:log]})"
			exit
		end

		# �m�F
		puts "Regexp     : #{regexp_src}"
		puts "Replacement: \"#{replacement.gsub("\\", "\\\\\\\\").gsub(/"/, '\\\\"').gsub(/\n/, "\\\\n").gsub(/\t/, "\\\\t")}\""
		puts "Backup     : #{@@options[:backup]}" if @@options[:backup]
		puts "Confirm    : true" if @@options[:confirm]
		puts "Limit      : #{@@options[:limit]}" if @@options[:limit]
		puts "Log        : #{@@options[:log]}" if @@options[:log]
		puts

		unless @@options[:yes]
			loop do
				print "OK(Y/N)? "
				case STDIN.gets.chomp
				when 'Y', 'y'
					break
				when 'N', 'n'
					exit
				end
			end
			puts
		end

		# replace
		count = 0
		contents = ""
		if @@options[:confirm]
			argv.each do |target|
				unless File.exists?(target)
					puts "not found: #{target}"
					next
				end
				next unless File.file?(target)

				# �t�@�C������ǂݍ���
				contents, src_encoding = file_get_contents(target)
				begin
					next if regexp !~ contents
				rescue
					puts "Error!!  : #{target}"
					puts "           " + $!.message
					next
				end

				puts "match    : #{target}"
				count += 1

				# �ő�X�V�t�@�C�����`�F�b�N
				if @@options[:limit] == count
					puts "�ő�X�V���ɒB���܂����B(#{@@options[:limit]})"
					break
				end
			end
			puts
			if 0 == count
				puts "�X�V�����t�@�C���͂���܂���B"
			else
				puts "�ȏ�� #{count} �̃t�@�C�����X�V����܂��B"
			end
		else
			log = open(@@options[:log], "w") if @@options[:log]
			begin
				# �o�b�N�A�b�v�t�@�C���̃T�t�B�b�N�X���L�^
				log.print("Backup: #{@@options[:backup]}\n\n") if @@options[:backup] and @@options[:log]

				argv.each do |target|
					unless File.exists?(target)
						puts "not found: #{target}"
						next
					end
					next unless File.file?(target)

					# �t�@�C������ǂݍ���
					contents, src_encoding = file_get_contents(target)
					begin
						next unless contents.gsub!(regexp, replacement)
						contents.encode!(src_encoding)
					rescue
						puts "Error!!  : #{target}"
						puts "           " + $!.message
						next
					end

					# �o�b�N�A�b�v
					File.rename(target, target + @@options[:backup]) if @@options[:backup]
					# �X�V���ʕۑ�
					open(target, "w"){|file| file.print(contents)}
					# ���O
					log.puts(target) if @@options[:log]
					puts "updated  : #{target}"
					count += 1

					# �ő�X�V�t�@�C�����`�F�b�N
					if @@options[:limit] == count
						puts "�ő�X�V���ɒB���܂����B(#{@@options[:limit]})"
						break
					end
				end
			ensure
				log.close if @@options[:log]
			end
			puts
			puts "���v #{count} �̃t�@�C�����X�V����܂����B"
		end
	end

	def self.restore(log_file)
		suffix, updated_files = self.read_log_file(log_file)
		count = 0
		updated_files.each do |file|
			bkfile = file + suffix
			unless File.file?(bkfile)
				printf("%-*s: %s\n", WIDTH, "not found", bkfile)
				next
			end
			begin
				File.rename(bkfile, file)
			rescue
				printf("%-*s: %s\n", WIDTH, "error", file)
				next
			end
			printf("%-*s: %s\n", WIDTH, "restored", file)
			count += 1
		end
		puts
		puts "�ȏ�� #{count} �̃t�@�C�������ɖ߂���܂���"
	end

	def self.delete_backup(log_file)
		suffix, updated_files = self.read_log_file(log_file)
		count = 0
		updated_files.map{|upfile| upfile + suffix}.each do |bkfile|
			unless File.file?(bkfile)
				printf("%-*s: %s\n", WIDTH, "not found", bkfile)
				next
			end
			begin
				File.delete(bkfile)
			rescue
				printf("%-*s: %s\n", WIDTH, "error", bkfile)
				next
			end
			printf("%-*s: %s\n", WIDTH, "deleted", bkfile)
			count += 1
		end
		# �G���[���Ȃ���΁A���O�t�@�C�����폜����B
		if updated_files.length == count
			begin
				File.delete(log_file)
				printf("%-*s: %s\n", WIDTH, "deleted", log_file)
				count += 1
			rescue
				printf("%-*s: %s\n", WIDTH, "error", log_file)
			end
		end
		puts
		puts "�ȏ�� #{count} �̃o�b�N�A�b�v�t�@�C���ƃ��O�t�@�C�����폜���܂����B"
	end

	# ���O�t�@�C���̊m�F
	# ����ɓǂݍ��߂��ꍇ�̓o�b�N�A�b�v�t�@�C���̃T�t�B�b�N�X�ƃ��O�t�@�C���ꗗ��Ԃ��B
	def self.read_log_file(log_file)
		unless File.file?(log_file)
			puts "�t�@�C�� #{log_file} ��������܂���B"
			exit
		end
		content = ""
		open(log_file){|file| content = file.read}
		unless %r{\ABackup: (?=([^\\/:*?"<>|\n]+))\1\n\n(?:^(?=(.*))\2\n)*\Z} =~ content
			puts "���O�t�@�C���̃t�H�[�}�b�g���s���ł��B"
			exit
		end

		return $~[1], content.each_line.to_a[2..-1].map{|i| i.chomp}
	end

	def self.file_get_contents(file)
		open(file) do |io|
			content = io.read
			src_encoding = NKF.guess(content)
			return content.encode('UTF-8', src_encoding), src_encoding
		end
	end
end

Replace.action(ARGV)
