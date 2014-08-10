require "matrix"
require "mathn" 
# 2006. 10. 5 

# from http://www.freesearch.pe.kr
# �߼� ���ޱⰣ���� �ɽ��ؼ� ���� PageRank �˰��� �Դϴ�.
# ���� ó�� ¥���� ���α׷��̶� �� �Žñ� ������ ���� �� ���ư��׿�.
# �����Ͻô� �е鿡�� ���� ������ �Ǳ� �ٶ��ϴ�.


# 2006. 10.21 
# makePersonalizationVector �޼��� �߰� 
# Personalization Vector���� ���� �Է��� �� �ְ� ����

class GooglePageRank

    def initialize(dim, alpha, epsilon)
        @dim = dim
        @epsilon = epsilon
        @noOfIter = 0
        @alpha = alpha
        @HMatrix = nil
        @pi = nil
        @time = nil
        makePersonalizationVector
    end

    def makeInitialPi
        #����� ������ ����ȭ�� �ο� ���͸� �����.
        @pi0 = Matrix.column_vector([1/@dim] * @dim)
    end
    
    def makeSparseMatrix
        inputlist = Array.new()
        @dim.times do |count| 
            print "#{count+1}��° ��庤���� outlink ���� �Է�(��ü 3���ǳ�� ����� �� : 0,1,0) : \n"
            a = gets 
            a.chop!
            inputlist[count] = a.split(/,\s*/)  if a.split(/,\s*/).length == @dim
            retry if a.split(/,\s*/).length != @dim
            inputlist[count].collect! {|a| a.to_i}
        end
        #outlink�� �ϳ��� ���°͵鿡 ���� ����ȭ ������ ����
        danglingNode = []
        inputlist.each do |vector|
            noOfNum = 0
            vector.each {|num| noOfNum += 1 if num > 0}

            if noOfNum == 0
                danglingNode.push(1)
            else
                danglingNode.push(0)
            end
            next if noOfNum == 0
            vector.collect! {|num| num / noOfNum if noOfNum != 0 }
        end
        @danglingnode = Matrix.column_vector(danglingNode)
        @HMatrix = Matrix.rows(inputlist)
    end

    def executePageRank
        @noOfIter = 0
        residual = 1
        pi = @pi0.dup
        yield @noOfIter, pi
        while residual >= @epsilon
            prevpi = pi
            @noOfIter += 1
            #PageRank Power method
            # personalVector = (1/@dim) * Matrix.column_vector([1] * @dim).t )
            pi = @alpha * pi.t * @HMatrix + ((@alpha * (pi.t * @danglingnode)[0,0] + (1.0 - @alpha)) * (@PersonalVector))
            pi = pi.t
            residual = (pi - prevpi).column_vectors()[0].r
            yield @noOfIter, pi
        end
        @pi = pi
    end
    
    #personalization Vector ���� �Է��ϴ� �κ� 
    def makePersonalizationVector
        inputlist = Array.new()
        totalNum = 0
        @dim.times{ |i|
            puts "#{(i+1).to_s}��° �������� ��ȣ���� ���ڷ� �Է��Ͻÿ�! (1~10)"
            inNum = (gets.chop!).to_i
            totalNum += inNum
            inputlist << inNum.to_f
        }
        inputlist.each_index{ | i |
            inputlist[i] = inputlist[i] / totalNum.to_f
        }
        @PersonalVector = Matrix.column_vector(inputlist).t
    end

    def RankSort
        rankArray = @pi.column_vectors()[0].to_a
        rankHash = Hash.new()
        i = 1
        rankArray.each{ |rank|
            rankHash[i] = rank
            i += 1
        } 
        rankArray = rankHash.sort {|x,y| y[1] <=> x[1] }
        yield rankArray
    end
end





#�ʿ� ���� �Է�
#����� ������ �Է� �޴´�.
print "�� ����� ������ �Է¹ٶ� : " 
noOfNode = gets.chop!

if noOfNode.empty? or noOfNode.to_i == 0
    puts "������ �־� �ֽñ� �ٶ��ϴ�!"
    exit 1
end

print "scaling Parameter�� �Է� �ٶ�(1~0 float��) : "
alpha = gets.chop!

if alpha.empty? or alpha.to_f == 0.0
    puts "float ������ �־� �ֽñ� �ٶ��ϴ�!"
    exit 1
end

print "Iteration ���е��� ���� �Ӱ谪 ����(���� pi���Ϳ� �� pi������ ��Ŭ����� �Ÿ�) : "
dist = gets.chop!

if dist.empty? or dist.to_f == 0.0
    puts "float ������ �־� �ֽñ� �ٶ��ϴ�!"
    exit 1
end

inputlist = Array.new()

noOfNode = noOfNode.to_i
alpha = alpha.to_f
dist = dist.to_f

PageRank = GooglePageRank.new(noOfNode, alpha, dist)

#����� �Է����� ��ũ ��Ʈ������ ����
PageRank.makeSparseMatrix 

#�ʱ� pi���� �����
PageRank.makeInitialPi

#�Ӱ谪�� �������� ������ ��ũ�� Iteration ����Ѵ�.
PageRank.executePageRank do |noOfIter, pi| 
    if noOfIter == 0
        puts "�ʱ� PageRank Vector : " + pi.to_s
    elsif noOfIter > 0
        puts "\n\n#{noOfIter} ��° �ݺ�"
        puts "���ŵ� PageRank Vector : \n#{pi.to_s}\n"
    end
end

PageRank.RankSort do |RankArray|
    puts "\n\nPageRank Result!\n\n"
    RankArray.each{|rank| puts rank[0].to_s + "�� ��� \nscore : " + rank[1].to_s + "\n"}
end



