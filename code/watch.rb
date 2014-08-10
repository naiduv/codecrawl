#!/usr/bin/env ruby

$KCODE = 'e'
require 'nkf'
require 'parsedate'

#����ʸ�������ɤ�SJIS�ξ��
def code_change_S(vcf,name)
  case NKF.guess(name)
  when NKF::SJIS
    cc = NKF.nkf("-sSx",vcf)
  when NKF::EUC
    cc = NKF.nkf("-eSx",vcf)
  when NKF::JIS
    cc = NKF.nkf("-jSx",vcf)
  when NKF::UTF8
    cc = NKF.nkf("-wSx",vcf)
  else
    cc = NKF.nkf("-uSx",vcf)
  end
  $vcard.puts cc
end

#����ʸ�������ɤ�EUC-JP�ξ��
def code_change_E(vcf,name)
  case NKF.guess(name)
  when NKF::SJIS
    cc = NKF.nkf("-sEx",vcf)
  when NKF::EUC
    cc = NKF.nkf("-eEx",vcf)
  when NKF::JIS
    cc = NKF.nkf("-jEx",vcf)
  when NKF::UTF8
    cc = NKF.nkf("-wEx",vcf)
  else
    cc = NKF.nkf("-uEx",vcf)
  end
  $vcard.puts cc
end

#����ʸ�������ɤ�JIS�ξ��
def code_change_J(vcf,name)
  case NKF.guess(name)
  when NKF::SJIS
    cc = NKF.nkf("-sJx",vcf)
  when NKF::EUC
    cc = NKF.nkf("-eJx",vcf)
  when NKF::JIS
    cc = NKF.nkf("-jJx",vcf)
  when NKF::UTF8
    cc = NKF.nkf("-wJx",vcf)
  else
    cc = NKF.nkf("-uJx",vcf)
  end
  $vcard.puts cc
end

#����ʸ�������ɤ�UTF-8�ξ��
def code_change_U(vcf,name)
  case NKF.guess(name)
  when NKF::SJIS
    cc = NKF.nkf("-sWx",vcf)
  when NKF::EUC
    cc = NKF.nkf("-eWx",vcf)
  when NKF::JIS
    cc = NKF.nkf("-jWx",vcf)
  when NKF::UTF8
    cc = NKF.nkf("-wWx",vcf)
  else
    cc = NKF.nkf("-uWx",vcf)
  end
  $vcard.puts cc
end

#����ʸ�������ɤ������ξ��
def code_change_A(vcf,name)
  case NKF.guess(name)
  when NKF::SJIS
    cc = NKF.nkf("-sx",vcf)
  when NKF::EUC
    cc = NKF.nkf("-ex",vcf)
  when NKF::JIS
    cc = NKF.nkf("-jx",vcf)
  when NKF::UTF8
    cc = NKF.nkf("-wx",vcf)
  else
    cc = NKF.nkf("-ux",vcf)
  end
  $vcard.puts cc
end

#�������줿���ɥ쥹Ģ��ʸ�������ɤ�Ĵ�٤�
def moji(vcf,name)
  case NKF.guess(vcf)
  when NKF::SJIS
    code_change_S(vcf,name)
  when NKF::EUC
    code_change_E(vcf,name)
  when NKF::JIS
    code_change_J(vcf,name)
  when NKF::UTF8
    code_change_U(vcf,name)
  else
    code_change_A(vcf,name)
  end
end

#�������֤ǥ�����
#ʸ���󹹿����֤�ɸ������ѹ��������
def time(time1,time2)
  time1 = ParseDate::parsedate(time1.to_s)
  time2 = ParseDate::parsedate(time2.to_s)
  for i in 0..5
    time = time1[i] - time2[i]
    if time > 0
      $hantei = 1
      break
    elsif time < 0
      break
    end
  end
end

pathfile = Array.new
pathtime = Array.new
difference = Array.new 
time = 0

#path�ե�����򳫤������ɥ쥹Ģpath��pathfile�س�Ǽ
path = File.open("path.txt")
while p = path.gets
  pathfile << p.chomp
end
path.close

#��Ǽ�������ɥ쥹Ģpath�κǽ��������֤�pathtime�س�Ǽ
for i in 0..pathfile.length - 1
  pathtime << File.mtime(pathfile[i])
end

#�������ֽ�˥�����(���λ���pathfile�⥽����)
for i in 0..pathtime.length - 2
  for j in i + 1..pathtime.length - 1
    $hantei = 0
    time(pathtime[i],pathtime[j])
    if $hantei == 1
      swap = pathtime[i]
      pathtime[i] = pathtime[j]
      pathtime[j] = swap

      swap = pathfile[i]
      pathfile[i] = pathfile[j]
      pathfile[j] = swap
    end
  end
end

#�ǽ��������֤ο��������ɥ쥹Ģ�ι������֤�ʸ���󷿤�p_t�س�Ǽ
p_t = pathtime.pop.to_s

#backup�ե�����ι������֤�ʸ���󷿤�b_t�س�Ǽ
if File.exist?("backup_ver2.1.vcf")
  b_t = File.mtime("backup_ver2.1.vcf").to_s
#version2.1���ʤ����version3�����
elsif File.exist?("backup_ver3.vcf")
  b_t = File.mtime("backup_ver3.vcf").to_s
#version3��ʤ���кǽ��������֤θŤ����ɥ쥹Ģ�ι������֤����
else
  b_t = pathtime.shift.to_s
end

#p_t��b_t��ʸ���󷿹������֤�ɸ������ǳ�Ǽ
p_t = ParseDate::parsedate(p_t)
b_t = ParseDate::parsedate(b_t)

#ǯ�����������ʬ�κ�ʬ���ꡢtime�زû�
for i in 0..4
  difference = p_t[i] - b_t[i]
  if difference > 0
    time = 1
    break
  elsif difference < 0
    time = -1
    break
  end
end

#time > 0���ʤ�й�������ǧ���줿�Ȥߤʤ�
#�Ĥޤ�ʬñ�̤ǹ�������Ƥ��뤫��ǧ

#time < 0�ʤ�С�backup�ե�������ѹ������ߤ�줿��ǽ��������Τ�
#�������֤θŤ����ɥ쥹Ģ�ι������֤����
if time < 0
  b_t = ParseDate::parsedate(pathtime.shift.to_s)
  time = 0
  for i in 0..4
  difference = p_t[i] - b_t[i]
  if difference > 0
    time = 1
    break
  end
end

end

if time > 0
  print("��������ǧ����ޤ�����\n")
  print("�ǿ��ξ���˹������ޤ���\n")

  vcf2 = ""
  vcf3 = ""
  path = pathfile.pop
  vcffile = File.open(path)
  while vcfline = vcffile.gets
    if vcfline =~ /^SOUND:/
      vcf3 += "SORT-STRING" + $'
      vcf2 += vcfline
    elsif vcfline =~ /^SORT-STRING:/
      vcf2 += "SOUND" + $'
      vcf3 += vcfline
    elsif vcfline =~ /^VERSION:/
      vcf2 += "VERSION:2.1\n"
      vcf3 += "VERSION:3\n"
    else
      vcf2 += vcfline
      vcf3 += vcfline
    end
  end
  vcffile.close

  ver2 = File.open("backup_ver2.1.vcf","w")
  ver2.puts vcf2
  ver2.close

  ver3 = File.open("backup_ver3.vcf","w")
  ver3.puts vcf3
  ver3.close


  name = ""

  pathfile = File.open("path.txt")
  while pathline = pathfile.gets
    vcffile = File.open(pathline.chomp)
    while line = vcffile.gets
      if line =~ /^N:|^N;.*?:/
        name = $'.gsub(/;/,"").gsub(/\s/,"")
      elsif line =~ /^VERSION:/
        version = $'.to_i
      end
    end
    if name == ""
      name ="a"
    end
    $vcard = File.open(pathline.chomp,"w")
    if version == 2
      moji(vcf2,name)
    else
      moji(vcf3,name)
    end
    $vcard.close
    vcffile.close
  end
  pathfile.close

else
  print("�����ϳ�ǧ����ޤ���Ǥ�����\n")
end