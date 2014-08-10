# QUOTED-PRINTABLEを変換する
# ※複数の項目に使われている場合には１つしか対応できない。

# 使用法：
# ruby quotedprintable.rb <filepath>

require 'kconv'


# QUOTED-PRINTABLEが始まる直前の文字列
QSTART="QUOTED-PRINTABLE:"
# QUOTED-PRINTABLEが終わったあとの文字列
QEND="END:VNOTE"
# QUOTED-PRINTABLEのみを表示するか否か
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
