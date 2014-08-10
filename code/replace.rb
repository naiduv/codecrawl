#!/usr/bin/env ruby
# -*- coding: sjis -*-

require 'optparse'
require 'nkf'

class Replace
	DEFAULT_LOG = 'replace.log'
	WIDTH = 9	# 結果を表示するときの各タイトルの表示幅

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
			puts "無効なパラメータが指定されました。"
			puts @@opts
			exit
		end

		# オプション確認
		if @@options[:restore]
			if 2 <= @@options.length
				puts "restoreオプションは他のオプションと併用できません。"
				exit
			end
			self.restore(@@options[:restore])
		elsif @@options[:delete_backup]
			if 2 <= @@options.length
				puts "delete-backupオプションは他のオプションと併用できません。"
				exit
			end
			self.delete_backup @@options[:delete_backup]
		else
			self.replace(argv)
		end
	end

	def self.replace(argv)
		if ARGV.size < 3 - (@@options[:regexp] ? 1 : 0)
			puts "パラメータが足りません。"
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
			print "パラメータ regexp が不正です。\n\n"
			puts err
			exit
		end
		unless regexp.kind_of?(Regexp)
			puts "パラメータ regexp が不正です。"
			exit
		end

		# replacement
		replacement = argv.shift.dup
		replacement = replacement.encode('UTF-8', NKF.guess(replacement))
		# \n,\t,\\ のエスケープを解除
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

		# オプションチェック
		# バックアップ
		if @@options[:backup] and %r{[\\/:*?"<>|]} =~ @@options[:backup]
			puts "バックアップファイルのサフィックス指定が不正です。(#{@@options[:backup]})"
			exit
		end
		# 最大更新ファイル数（1以上の整数）
		if @@options[:limit] and /^[1-9]\d*$/ !~ @@options[:limit]
			puts "最大更新ファイル数の指定が不正です。(#{@@options[:limit]})"
			exit
		end
		# ログ
		if @@options[:log] and /[*?"<>|]/ =~ @@options[:log]
			puts "ログ出力ファイル名が不正です。(#{@@options[:log]})"
			exit
		end

		# 確認
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

				# ファイルから読み込む
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

				# 最大更新ファイル数チェック
				if @@options[:limit] == count
					puts "最大更新数に達しました。(#{@@options[:limit]})"
					break
				end
			end
			puts
			if 0 == count
				puts "更新されるファイルはありません。"
			else
				puts "以上の #{count} 個のファイルが更新されます。"
			end
		else
			log = open(@@options[:log], "w") if @@options[:log]
			begin
				# バックアップファイルのサフィックスを記録
				log.print("Backup: #{@@options[:backup]}\n\n") if @@options[:backup] and @@options[:log]

				argv.each do |target|
					unless File.exists?(target)
						puts "not found: #{target}"
						next
					end
					next unless File.file?(target)

					# ファイルから読み込む
					contents, src_encoding = file_get_contents(target)
					begin
						next unless contents.gsub!(regexp, replacement)
						contents.encode!(src_encoding)
					rescue
						puts "Error!!  : #{target}"
						puts "           " + $!.message
						next
					end

					# バックアップ
					File.rename(target, target + @@options[:backup]) if @@options[:backup]
					# 更新結果保存
					open(target, "w"){|file| file.print(contents)}
					# ログ
					log.puts(target) if @@options[:log]
					puts "updated  : #{target}"
					count += 1

					# 最大更新ファイル数チェック
					if @@options[:limit] == count
						puts "最大更新数に達しました。(#{@@options[:limit]})"
						break
					end
				end
			ensure
				log.close if @@options[:log]
			end
			puts
			puts "合計 #{count} 個のファイルが更新されました。"
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
		puts "以上の #{count} 個のファイルが元に戻されました"
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
		# エラーがなければ、ログファイルも削除する。
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
		puts "以上の #{count} 個のバックアップファイルとログファイルを削除しました。"
	end

	# ログファイルの確認
	# 正常に読み込めた場合はバックアップファイルのサフィックスとログファイル一覧を返す。
	def self.read_log_file(log_file)
		unless File.file?(log_file)
			puts "ファイル #{log_file} が見つかりません。"
			exit
		end
		content = ""
		open(log_file){|file| content = file.read}
		unless %r{\ABackup: (?=([^\\/:*?"<>|\n]+))\1\n\n(?:^(?=(.*))\2\n)*\Z} =~ content
			puts "ログファイルのフォーマットが不正です。"
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
