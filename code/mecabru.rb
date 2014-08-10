#!/usr/bin/ruby -Ku
$KCODE="u"

# Author:: Masato Watanabe(MWSoft)
# License:: BSD

# 
# MeCabRu 0.01
#
# [概要]
# Mecabをコマンドラインから呼び出し、mecab-rubyの戻り値に似せた結果を返します。
# レンタルサーバなどmecab-rubyが使用できない環境での回避策となることを想定して作成しました。
#
# コマンドラインから呼び出し、戻り値をパースし、Nodeクラスに詰め直している為、
# バインディングと比べて実効速度は遅くなります。
#
# [動作確認環境]
# Fedora11, ruby1.8.7, Ruby1.9.1
# WindowsXP ruby1.8.7(mswin32版)
#
# [mecab-rubyとの差異]
# mecab-rubyを実行した際と、以下の項目で処理結果に差異が発生します
# ・alpha,beta等のFLOATを戻り値とする値について、小数点6桁まで(7桁目を四捨五入)しか取得できていません
# 
# [未実装の項目]
# ・-Nを指定した際の複数解取得の為の処理をまだ記述していません
# ・文中のスペースをsurfaceに加えて処理をする為の措置を記述していません
# ・TaggerのparseNBestInit, next, nextNodeは実装していません
# ・Nodeのenext, bnextは実装していません
#
# [使用方法]
# 使用方法はmecab-rubyとほぼ同じです
# 
# require 'mecabru'
# mecab = MeCabRu::Tagger.new
# node = m.parseToNode( str )
# while node
#   puts node.surface
#   node = node.next
# end
#
# コンストラクタの第2引数で、mecabのパスを指定することができます
# mecab = MeCabRu::Tagger.new( "-l2", 'c://mecab/bin/mecab.exe' )
# puts mecab.parse( str )
#

module MeCabRu

  # フォーマット一覧
  # [ "フォーマット名", "対応するNodeクラスのフィールド名", "型" ]
  FMT_LIST = [
        [ "m",   "surface",   "s" ],
        [ "H",   "feature",   "s" ],
        [ "pl",  "length",    "i" ],
        [ "pL",  "rlength",   "i" ],
        [ "pi",  "id",        "i" ],
        [ "phr", "rcAttr",    "i" ],
        [ "phl", "lcAttr",    "i" ],
        [ "pi",  "posid",     "i" ],
        [ "t",   "char_type", "i" ],
        [ "s",   "stat",      "i" ],
        [ "pb",  "isbest",    "s" ],
        [ "pA",  "alpha",     "f" ],
        [ "pB",  "beta",      "f" ],
        [ "pP",  "prob",      "f" ],
        [ "c",   "wcost",     "i" ],
        [ "pc",  "cost",      "i" ]
  ]

  class Tagger
    def initialize( options = nil, mecab_path = nil )
      # Nodeの保持変数
      @node = nil

      # mecabを呼び出す際の引数
      @options = options.to_s

      # mecabのパスを指定する
      @mecab_path = "mecab"
      @mecab_path = mecab_path if mecab_path
    end

    #
    # 引数を解析し、結果を文字列で返す
    #
    def parse( str )
      ret = IO.popen( "#{@mecab_path} #{@options}", "r+" ) { | io |
        io.puts str
        io.close_write
        io.readlines
      }
      # 空行を取り除く
      ret.delete_if { | item | item.strip == "" }
      return "#{ret.join}\n"
    end

    #
    # 引数を解析し、結果を文字列で返す（parseと同様の処理）
    #
    def parseToString( str )
      return parse( str )
    end

    #
    # 引数を解析し、結果をNodeとして返す
    #
    def parseToNode( str )
      f_args = []
      FMT_LIST.each { | item |
        f_args.push( item[0] )
      }

      # MeCab実行
      fmt_param = "%#{f_args.join("\\t%")}\\t\\n"
      @options += " -B\"#{fmt_param}\" -E\"#{fmt_param}\" -F\"#{fmt_param}\""
      parse_str = parse( str.gsub(/\r|\n/, " ") )

      # 解析してNodeに格納
      first_node = nil
      prev_node = nil
      eos_node = nil
      i = 0
      parse_str.each_line { | line |
        next if line.strip == ""
        node = Node.new( line )
        node.setPrev( prev_node )
        prev_node.setNext( node ) if prev_node
        prev_node = node
        first_node = node if (i += 1) == 1
      }
      first_node
    end

    #
    # 未実装
    #
    def parseNBestInit( str )
      raise UnsupportMethodException.new( "申し訳ありません。このメソッドは実装されていません。" )
    end

    #
    # 未実装
    #
    def next
      raise UnsupportMethodException.new( "申し訳ありません。このメソッドは実装されていません。" )
    end

    #
    # 未実装
    #
    def nextNode
      raise UnsupportMethodException.new( "申し訳ありません。このメソッドは実装されていません。" )
    end

  end

  #
  # MeCab解析結果を格納するNodeクラス
  #
  class Node

    #
    # 初期化。
    # MeCabから返された値を1行ずつ引数として取る。
    #
    def initialize( line )
      params = line.split( "\t" )

      FMT_LIST.each_with_index { | item, i |
        case item[2]
          when "s"
           self.instance_variable_set("@#{item[1]}", params[i])
          when "i"
           self.instance_variable_set("@#{item[1]}", params[i].to_i)
          when "f"
           self.instance_variable_set("@#{item[1]}", params[i].to_f)
        end
      }

      # isbestの設定
      @isbest = 1 if @isbest == "*"
    end

    # 形態素の文字列情報
    attr_reader :surface

    # CSVで表記された素性情報
    attr_reader :feature

    # 形態素の長さ
    attr_reader :length

    # 形態素の長さ（先頭のスペースを含む）
    attr_reader :rlength

    # 右文脈ID
    attr_reader :rcAttr

    # 左文脈ID
    attr_reader :lcAttr

    # 形態素ID（未使用。MeCab自身が用意だけして使用してない）
    attr_reader :posid

    # 文字種情報
    attr_reader :char_type

    # 形態素の種類（NOR_NODE:0, UNK_NODE:1, BOS_NODE:2, EOS_NODE:3）
    attr_reader :stat

    # ベストの解の場合 true, それ以外 0
    attr_reader :isbest

    # forward backward の foward log 確率
    attr_reader :alpha

    # forward backward の backword log 確率
    attr_reader :beta

    # 周辺確率
    attr_reader :prob

    ### alpha, beta, probは -l 2 オプションを指定された時に定義されます

    # 周辺確率FMT_LIST
    attr_reader :wcost

    # 周辺確率
    attr_reader :cost

    # 前のNodeを取得する
    attr_reader :prev

    # 次のNodeを取得する
    attr_reader :next

    #
    # 未実装
    #
    def enext
      raise UnsupportMethodException.new( "申し訳ありません。このメソッドは実装されていません。" )
    end
    
    #
    # 未実装
    #
    def bnext
      raise UnsupportMethodException.new( "申し訳ありません。このメソッドは実装されていません。" )
    end

    #
    # 前のNodeを設定する
    #
    def setPrev( prevNode )
      @prev = prevNode
    end
    
    #
    # 次のNodeを設定する
    #
    def setNext( nextNode )
      @next = nextNode
    end

    #
    # Hashを返す
    #
    def to_hash
      hash = {}
      FMT_LIST.each { | item |
        hash[ item[1] ] = self.instance_variable_get("@#{item[1]}").to_s
      }
      hash
    end

  end

  class UnsupportMethodException < StandardError
  end

end


=begin
str = "mecab-rubyと同時に使って結果をあれこれする例。\n2行にしてみる。\n3行にしてみる。"

m = MeCabRu::Tagger.new( "-l2" )
node_p = m.parseToNode( str )

require 'MeCab'
m = MeCab::Tagger.new( "-l2" )
node_l = m.parseToNode( str )

1000.times do
  puts "=========="
  puts "--- surface ---"
  puts node_p.surface
  puts node_l.surface
  puts "--- length ---"
  puts node_p.length
  puts node_l.length
  puts "--- rlength ---"
  puts node_p.rlength
  puts node_l.rlength
  #puts "--- id ---"
  #puts node_p.id
  #puts node_l.id
  puts "--- rcAttr ---"
  puts node_p.rcAttr
  puts node_l.rcAttr
  puts "--- lcAttr ---"
  puts node_p.lcAttr
  puts node_l.lcAttr
  puts "--- posid ---"
  puts node_p.posid
  puts node_l.posid
  puts "--- char_type ---"
  puts node_p.char_type
  puts node_l.char_type
  puts "--- isbest ---"
  puts node_p.isbest
  puts node_l.isbest
  puts "--- aplha ---"
  puts node_p.alpha
  puts node_l.alpha
  puts "--- beta ---"
  puts node_p.beta
  puts node_l.beta
  puts "--- prob ---"
  puts node_p.prob
  puts node_l.prob
  puts "--- stat ---"
  puts node_p.stat
  puts node_l.stat
  puts "--- wcost ---"
  puts node_p.wcost
  puts node_l.wcost
  puts "--- cost ---"
  puts node_p.cost
  puts node_l.cost

  node_p = node_p.next
  node_l = node_l.next

  break if node_p == nil or node_l == nil
end
=end

