#! /usr/bin/ruby
require 'scanf'

class Interpreter
  SPACE = "\s"
  LF = "\n"
  TAB = "\t"
  
  #デバッグフラグ
  OUT_CODE = false
  OUT_OP_TYPE = false
  IS_DEBUG = false
  
  def initialize
    @source ||= open(ARGV[0],"r").read()
    @stack = Stack.new
    @heap = Heap.new
    @label_table ||= Hash.new
    @call_stack = Stack.new
    @pc = 0
    
    @out_op = false
  end
  
  def main
    make_label_table()
    @is_make_table = false
    interprete()
  end
  
  def make_label_table
    #ラベルのテーブルを作るための事前読み込み
    @is_make_table = true
    interprete()
    initialize()
    @out_op = false            
  end
  
  def interprete()
    prev = nil
    while a_code = read_a_code()
      case a_code
        when SPACE
          if prev == nil
            exec_stack()
          else
            case prev
              when TAB
                exec_arithmetic()
              else
                error
            end
            prev = nil
          end                      
        when LF
          if prev == nil
            exec_flow()
          else
            case prev
              when TAB
                exec_io()
              else
                error()
            end
            prev = nil
          end
        when TAB
          if prev == nil
            prev = TAB
          else
            case prev
              when TAB
                exec_heap()
              else
                error()
              end
              prev = nil
          end
      end
    end
  end

  ###################### stack ##########################  
  def exec_stack
    puts "stack" if OUT_OP_TYPE
    prev = nil
    
    while a_code = read_a_code() 
      case a_code
        when SPACE
          if prev == nil
            exec_stack_push_a_number()
            return
          else
            case prev
              when LF
                exec_stack_dup_top()
              when TAB
                exec_stack_copy_nth_item()
              else
                error()
            end
            return
         end
        when LF
          if prev == nil
            prev = LF
          else
            case prev
              when LF
                exec_stack_discard_top_item()
              when TAB
                exec_stack_slide_nitems_off()
              else
                error()              
            end
            return
          end
        when TAB
          if prev == nil
            prev = TAB
          else
            exec_stack_swap_two_items()
            return
          end
      end
    end
  end
  
  def exec_stack_push_a_number
    print "exec_stack_push_a_number" if @out_op
    num = read_a_number()
    @stack.push(num) unless @is_make_table
  end
  
  def exec_stack_dup_top
    puts "exec_stack_dup_top" if @out_op
    unless @is_make_table
      @stack.push(@stack.get_top())
    end
  end
  
  def exec_stack_copy_nth_item()
    print "exec_stack_copy_nth_item" if @out_op
    read_a_number()
    unless @is_make_table
      @stack.push(@stack.get(n))
    end    
  end
  
  def exec_stack_discard_top_item
    puts "exec_stack_discard_top_item" if @out_op
    @stack.pop() unless @is_make_table
  end

  def exec_stack_slide_nitems_off
    print "exec_stack_slide_nitems_off" if @out_op
    num = read_a_number()
    @stack.slide_nth_items_keeping_top(num) unless @is_make_table
  end

  def exec_stack_swap_two_items
    puts "exec_stack_swap_two_items" if @out_op
    unless @is_make_table
      first_one = @stack.pop()
      second_one = @stack.pop()
      @stack.push(first_one)
      @stack.push(second_one)
    end
  end
  
  ###################### arithmetic ##########################
  def exec_arithmetic
    puts "arithmetic" if OUT_OP_TYPE
    
    prev = nil
    while a_code = read_a_code()
      case a_code
        when SPACE
          if prev == nil
            prev = SPACE
          else
            case prev
              when SPACE
                exec_arithmetic_add()
              when TAB
                exec_arithmetic_div()
              when LF
                error()
            end
            return
          end        
        when TAB
          if prev == nil
            prev = TAB
          else
            case prev
              when SPACE
                exec_arithmetic_sub()
              when TAB
                exec_arithmetic_mod()
              when LF
                errror()
            end
            return
          end         
        when LF
          if prev == nil
            error()
          else
            case prev
              when SPACE
                exec_arithmetic_mul()                
              when TAB
                error()
              when LF
                error()
            end
            return
          end         
      end
    end
  end
  
  def exec_arithmetic_add
    puts "exec_arithmetic_add" if @out_op
    unless @is_make_table
      right_one = @stack.pop()
      left_one = @stack.pop()
      puts " " + left_one.to_s + "+" + right_one.to_s if @out_op
      @stack.push(left_one + right_one)
    end
  end
  
  def exec_arithmetic_div
    puts "exec_arithmetic_div" if @out_op
    unless @is_make_table
      right_one = @stack.pop()
      left_one = @stack.pop()
      puts " " + left_one.to_s + "/" + right_one.to_s if @out_op
      @stack.push(left_one / right_one)
    end
  end
  
  def exec_arithmetic_sub
    puts "exec_arithmetic_sub" if @out_op
    unless @is_make_table
      right_one = @stack.pop()
      left_one = @stack.pop()
      puts " " + left_one.to_s + "-" + right_one.to_s if @out_op
      @stack.push(left_one - right_one)
    end
  end

  def exec_arithmetic_mod
    puts "exec_arithmetic_mod" if @out_op
    unless @is_make_table
      right_one = @stack.pop()
      left_one = @stack.pop()
      puts " " + left_one.to_s + "%" + right_one.to_s if @out_op
      @stack.push(left_one % right_one)
    end    
  end
  
  def exec_arithmetic_mul
    print "exec_arithmetic_mul" if @out_op
    unless @is_make_table
      right_one = @stack.pop()
      left_one = @stack.pop()
      puts " " + left_one.to_s + "*" + right_one.to_s if @out_op
      @stack.push(left_one * right_one)
    end    
  end
  
  ###################### heap ##########################
  def exec_heap
    puts "heap" if OUT_OP_TYPE

    prev = nil
    case read_a_code()
      when SPACE
        exec_heap_store()
      when TAB
        exec_heap_retrieve()        
      when LF
        error()
    end
    
    return
  end
  
  def exec_heap_store
    puts "exec_heap_store " if @out_op
    unless @is_make_table
      val = @stack.pop()
      addr = @stack.pop()
      puts "(" + addr.to_s + "," + val.to_s + ")" if @out_op
      @heap.set(addr,val)
    end     
  end
  
  def exec_heap_retrieve
    puts "exec_heap_retrieve" if @out_op
    unless @is_make_table
      addr = @stack.pop()
      puts "(" + addr.to_s + ")" if @out_op
      @stack.push(@heap.get(addr))
    end      
  end
  
  ###################### flow ##########################
  def exec_flow()
    puts "flow" if OUT_OP_TYPE
    prev = nil
    while a_code = read_a_code()
      case a_code
        when SPACE
          if prev == nil
            prev = SPACE
          else
            case prev
              when SPACE
                exec_flow_mark_location()
              when TAB
                exec_flow_jmp_eq_zero()
              when LF
                error()
            end
            return
          end
        when TAB
          if prev == nil
            prev = TAB
          else
            case prev
              when TAB
                exec_flow_jmp_if_neg()
              when SPACE
                exec_flow_call_subroutine()
              when LF
                error()
            end
            return
          end        
        when LF
          if prev == nil
            prev = LF
          else
            case prev
              when SPACE
                exec_flow_jmp_to_label()
              when TAB
                exec_flow_ret()
              when LF
                exec_flow_exit()
            end
            return
          end        
      end
    end
  end

  def exec_flow_mark_location
    print "exec_flow_mark_location" if @out_op
    @label_table[read_a_label()] = @pc
  end
  
  def exec_flow_call_subroutine
    print "exec_flow_call_subroutine" if @out_op
    label = read_a_label()
    unless @is_make_table
      @call_stack.push(@pc)
      @pc = @label_table[label]
    end
  end
  
  def exec_flow_jmp_if_neg
   print "exec_flow_jmp_if_neg" if @out_op
    label = read_a_label()
    unless @is_make_table
      check_val = @stack.pop()
      if check_val < 0
        puts " HIT" if @out_op    
        @pc = @label_table[label]
      else
        puts " NOT HIT" if @out_op
      end
    end
  end

  def exec_flow_jmp_eq_zero
    print "exec_flow_jmp_eq_zero" if @out_op
    label = read_a_label()
    unless @is_make_table
      check_val = @stack.pop()
      if check_val == 0
        puts " HIT" if @out_op
        @pc = @label_table[label]
      else
        puts " NOT HIT" if @out_op
      end
    end  
  end

  def exec_flow_jmp_to_label
    print "exec_flow_jmp_to_label" if @out_op
    label = read_a_label()
    @pc = @label_table[label] unless @is_make_table
  end
  
  def exec_flow_ret
    puts "exec_flow_ret" if @out_op
    @pc = @call_stack.pop() unless @is_make_table
  end
  
  def exec_flow_exit
    puts "exec_flow_exit" if @out_op

    if @is_make_table == false
      puts ""
      puts "INTERPRETER: interpretation ended."    
      exit()
    end
  end
  
  ###################### io ##########################
  def exec_io
    puts "io" if OUT_OP_TYPE

    prev = nil
    while a_code = read_a_code()
      case a_code
        when SPACE
          if prev == nil
            prev = SPACE
          else
            case prev
              when SPACE
                exec_io_out_a_char()
              when TAB
                exec_io_read_a_char_to_heap()
              when LF
                error()          
            end
            return
          end
        when TAB
          if prev == nil
            prev = TAB
          else
            case prev
              when SPACE
                exec_io_out_a_number()
              when TAB
                exec_io_read_a_number_to_heap()
              when LF
               error()         
            end
            return
          end          
        when LF
          error()
      end
    end
  end
  
  def exec_io_out_a_char
    puts "exec_io_out_a_char" if @out_op
    unless @is_make_table
      print sprintf("%c",@stack.pop())
    end
  end
  
  def exec_io_read_a_char_to_heap
    puts "exec_io_read_a_char_to_heap" if @out_op
    unless @is_make_table
      read_data = STDIN.read(1)
      #末尾の[0]は文字コード化
      @heap.set(@stack.get_top(),read_data[0])      
    end
  end
  
  def exec_io_out_a_number
    puts "exec_io_out_a_number" if @out_op
    print sprintf("%d",@stack.pop()) unless @is_make_table
  end
  
  def exec_io_read_a_number_to_heap
    puts "exec_io_read_a_number_to_heap" if @out_op
    unless @is_make_table
      read_data = STDIN.scanf("%d")
      @heap.set(@stack.get_top(),read_data[0])
    end
  end
  
  ####################################################
  
  def error
    puts "error"
    exit()
  end
  
  def read_a_number
    print "read num" if IS_DEBUG
    num = nil

    for_sign = read_a_code()
    while a_code = read_a_code()
      case a_code
        when SPACE
          if num == nil
            num = 0
          else
            num <<= 1
          end
        when LF
          if for_sign == TAB
            num = -1 * num 
          end
          puts " " + num.to_s if @out_op
          return num
        when TAB
          if num == nil
            num = 1
          else
            num <<= 1
            num += 1
          end
      end
    end
  end
  
  #intで返す
  def read_a_label
    print "read label" if IS_DEBUG

    label_num = nil
    while a_code = read_a_code()
      case a_code
        when SPACE
          if label_num == nil
            label_num = 0
          else
            label_num <<= 1
          end
        when LF
          puts " " + label_num.to_s if @out_op
          return label_num
        when TAB
          if label_num == nil
            label_num = 1
          else
            label_num <<= 1
            label_num += 1
          end
      end
    end
  end
  
  def read_a_code
    if @pc < @source.length()
      a_code = sprintf("%c",@source[@pc])
      @pc += 1
    else
      puts "source file ended." if IS_DEBUG
      return nil      
    end
          
    if a_code && ((a_code == SPACE) || (a_code == LF) || (a_code == TAB))
      if OUT_CODE
        case a_code
          when TAB
            puts "TAB"
          when SPACE
            puts "SPACE"
          when LF
            puts "LF"
        end
      end
      return a_code      
    else
      puts "other code found." if IS_DEBUG
      return read_a_code()    
    end
  end
end

class Heap
  
  def initialize
    @space = []
  end
  
  def set(index,value)
    @space[index]=value
  end

  def get(index)
    return @space[index]
  end
  
end

class Stack

  def initialize
    @stack = []
    @sp = 0    
  end
  
  def push(obj)
    @stack[@sp] = obj
    @sp += 1
  end
  
  def pop
    @sp -= 1
    return @stack[@sp]
  end
  
  #0を渡すと一番上
  def get_from_top(n)
    return @stack[@sp - n - 1]
  end
  
  def get_top
    return @stack[@sp -1]
  end
  
  def slide_nth_items_keeping_top(n)
    @stack[(@sp-2-n)..(@sp-2)] = nil
  end
  
end

interpreter = Interpreter.new
interpreter.main()
