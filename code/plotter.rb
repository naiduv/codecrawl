#/***********************************************************
#    plotter.rb -- グラフィックス
#***********************************************************/
# プロッタのシミュレーション 

$xpen = 0; $ypen = 0;  # ペンの現在位置 

def gr_on
  $gplot = IO.popen("gnuplot -persist", "w")
  $gplot.puts 'plot "-" w l'
end

def gr_off
  $gplot.puts "end"
  $gplot.close
end

def gr_wline(x1, y1, x2, y2)
  $gplot.puts "#{x1} #{y1}\n#{x2} #{y2}\n\n"
end
 
def move(x,  y)  # ペンアップで移動 
    $xpen = x;  $ypen = y
end

def move_rel( dx,  dy)  # 同上 (相対座標) 
    $xpen += dx;  $ypen += dy
end

def draw(x,  y)  # ペンダウンで移動 
    gr_wline($xpen, $ypen, x, y)
    $xpen = x;  $ypen = y
end

def draw_rel( dx,  dy)  # 同上 (相対座標) 
    gr_wline($xpen, $ypen, $xpen + dx, $ypen + dy)
    $xpen += dx;  $ypen += dy
end

# sample usage

=begin
gr_on
gr_wline(0, 0, 10, 10)
move(5, 0)
draw_rel(0, 5)
gr_off
=end
