#just pushes random words to github every so often
require 'net/http'
require 'timeout'

def push_to_git
  system 'git add --all'
  system 'git commit -a -m "newline"'
  system 'git pull origin master'
  system 'git push origin master'
end


$word = String.new
$lengthmax = 10

$letters = "abcdefghijklmnopqrstuvwxyz"
$size = $letters.length;

$letters = "abcdefghijklmnopqrstuvwxyz"
$size = $letters.length;


x=ARGV[0].to_i
while true do
	$f = File.new("newfile.txt",  "a")
	$wordlength = rand($lengthmax);
	$newletters = 0
	$word = String.new
	while $wordlength>$newletters do
	 	$word[$newletters] = $letters[rand($size)]
	 	$newletters = $newletters+1;
	end
	$f.write($word.to_s + " ")
	
	push_to_git
	sleep rand(36000);
end
