# QUOTED-PRINTABLE��ϊ�����
# �������̍��ڂɎg���Ă���ꍇ�ɂ͂P�����Ή��ł��Ȃ��B

# �g�p�@�F
# ruby quotedprintable.rb <filepath>

require 'kconv'


# QUOTED-PRINTABLE���n�܂钼�O�̕�����
QSTART="QUOTED-PRINTABLE:"
# QUOTED-PRINTABLE���I��������Ƃ̕�����
QEND="END:VNOTE"
# QUOTED-PRINTABLE�݂̂�\�����邩�ۂ�
ONLY_PRINTABLE=false

def readFile(file)
  meisai = false
  body  = open(file, "r").read
  if ONLY_PRINTABLE
    body.scan(/#{QSTART}(.+?)#{QEND}/mi).each {|note|
      print qptosjis(note.to_s)
    }
  else
    print body.gsub(/#{QSTART}(.+?)#{QEND}/mi){
      QSTART + qptosjis($1.to_s) + QEND
    }
  end
end

def qptosjis(a)
  r = ''
  if a != nil && a != ""
    b = a.unpack("M")
    (0..b.length-1).each {|c|
      if b[c] != nil && b[c] != ""
        r += Kconv.tosjis(b[c])
      end
    }
  end
  if r == ''
    a
  else
    r.gsub! /</,'&lt;'
    r.gsub! />/,'&gt;'
    r
  end
end

readFile $*[0]
