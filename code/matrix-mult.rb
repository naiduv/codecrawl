#!/usr/bin/env ruby

# 1. Summation and element-wise multiplication of arrays

# We want to implement matrices in Ruby as arrays of arrays. These
# matrices can be used for modeling systems which require operations
# from linear algrebra. For starters, we may want to implement matrix
# multiplication. 

# ******** TASK ***********  
# To this end, we need to summarize the element-wise multiplications
# of arrays in some convenient way. Therefore, you need to implement a
# method sum in the Array class that sums all the elements of an
# array.

# Also, you provide a method for doing element-wise multiplication
# (element_multiply)
# ******** TASK ***********
  
class Array

  def sum
    inject(0) {|elt,sum| elt+sum}
  end
      
  # You may find it useful to use collect_with_index for
  # element_multiply. This method is a combination of the standard
  # methods each_with_index and collect

  def collect_with_index
    i=-1
    collect {|elt| i+=1;yield(elt,i)}
  end
  
  def element_multiply(a)
    # ...
  end
end


# Test:

# irb> [1,2,3].sum 
# 6
# irb> [1,2,3].element_multiply([3,3,3])
# [3,6,9]


# 2. Matrix transposition and multiplication

# we assume that arrays are used to implement matrices in this form:

# [[1,0,0],
# [0,1,-1],
# [0,-1,1]]

# That is, the elements of the matrix array are rows, which are in
# turn arrays.

# Introduce a new class Matrix to represent the concept of matrices.

class Matrix

  def initialize(array)
    # We use the instance variable @matrix to store the array
    @matrix=array
  end
  
  # ******** TASK ***********
  # 2.1 Implement transpose which transposes the matrix (rows become
  # columns)
  # ******** TASK ***********
  # ALREADY GIVEN

  def transpose
    transposed_matrix=[]
    0.upto(@matrix[0].size-1) do |col_num| 
      transposed_matrix[col_num] ||= []
      0.upto(@matrix.size-1) do |row_num|
        transposed_matrix[col_num][row_num]=@matrix[row_num][col_num]
      end
    end
    Matrix.new(transposed_matrix)
  end
  
  def row_rank
    @matrix.size
  end
  
  def column_rank
    @matrix[0].size
  end
  
  def [](row)
    return @matrix[row]
  end
  
  # ******** TASK ***********
  # 2.2 Implement multiplication that multiplies a matrix with
  # another, as defined in linear algebra.
  # ******** TASK ***********

  def *(matrix)
    raise Exception("Rank mismatch") unless column_rank == matrix.row_rank
    transposed_matrix=matrix.transpose
    # ...
  end
  
end

# 3. Trick question

# ******** TASK ***********
# This code allows you to create matrices using a different
# syntax. Which?
# ******** TASK ***********
  
class << Matrix
  
  def [](*arr)
    Matrix.new(arr)
  end
  
end
