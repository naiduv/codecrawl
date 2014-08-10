require "matrix"
require "mathn" 
# 2006. 10. 5 

# from http://www.freesearch.pe.kr
# 추석 연휴기간동안 심심해서 만들어본 PageRank 알고리즘 입니다.
# 루비로 처음 짜보는 프로그램이라서 좀 거시기 하지만 나름 잘 돌아가네요.
# 공부하시는 분들에게 많은 도움이 되길 바랍니다.


# 2006. 10.21 
# makePersonalizationVector 메서드 추가 
# Personalization Vector값을 직접 입력할 수 있게 했음

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
        #노드의 갯수로 정규화된 로우 벡터를 만든다.
        @pi0 = Matrix.column_vector([1/@dim] * @dim)
    end
    
    def makeSparseMatrix
        inputlist = Array.new()
        @dim.times do |count| 
            print "#{count+1}번째 노드벡터의 outlink 정보 입력(전체 3개의노드 존재시 예 : 0,1,0) : \n"
            a = gets 
            a.chop!
            inputlist[count] = a.split(/,\s*/)  if a.split(/,\s*/).length == @dim
            retry if a.split(/,\s*/).length != @dim
            inputlist[count].collect! {|a| a.to_i}
        end
        #outlink가 하나도 없는것들에 대한 정규화 수행을 위함
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
    
    #personalization Vector 값을 입력하는 부분 
    def makePersonalizationVector
        inputlist = Array.new()
        totalNum = 0
        @dim.times{ |i|
            puts "#{(i+1).to_s}번째 페이지의 선호도를 숫자로 입력하시오! (1~10)"
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





#필요 인자 입력
#노드의 갯수를 입력 받는다.
print "총 노드의 갯수를 입력바람 : " 
noOfNode = gets.chop!

if noOfNode.empty? or noOfNode.to_i == 0
    puts "정수를 넣어 주시기 바랍니다!"
    exit 1
end

print "scaling Parameter를 입력 바람(1~0 float형) : "
alpha = gets.chop!

if alpha.empty? or alpha.to_f == 0.0
    puts "float 형으로 넣어 주시기 바랍니다!"
    exit 1
end

print "Iteration 정밀도를 위한 임계값 설정(이전 pi벡터와 현 pi벡터의 유클리드언 거리) : "
dist = gets.chop!

if dist.empty? or dist.to_f == 0.0
    puts "float 형으로 넣어 주시기 바랍니다!"
    exit 1
end

inputlist = Array.new()

noOfNode = noOfNode.to_i
alpha = alpha.to_f
dist = dist.to_f

PageRank = GooglePageRank.new(noOfNode, alpha, dist)

#사용자 입력으로 링크 메트릭스를 구현
PageRank.makeSparseMatrix 

#초기 pi값을 만들고
PageRank.makeInitialPi

#임계값을 기준으로 페이지 랭크를 Iteration 계산한다.
PageRank.executePageRank do |noOfIter, pi| 
    if noOfIter == 0
        puts "초기 PageRank Vector : " + pi.to_s
    elsif noOfIter > 0
        puts "\n\n#{noOfIter} 번째 반복"
        puts "갱신된 PageRank Vector : \n#{pi.to_s}\n"
    end
end

PageRank.RankSort do |RankArray|
    puts "\n\nPageRank Result!\n\n"
    RankArray.each{|rank| puts rank[0].to_s + "번 노드 \nscore : " + rank[1].to_s + "\n"}
end



