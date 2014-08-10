#!/usr/bin/ruby

# Takes a csv file then converts the data to PWL
# for use in DWM creation

def main

  if ARGV.length == 0 or ARGV[0] == "-h"
    puts "makePWLfromCSV <file> where
    each line is a csv file"
    exit
  end

  filename = ARGV[0]
  csvList = File.open(filename,"r")

  sample=1
  minRatio=0.0001

  while (!csvList.eof)
    line=csvList.gets.strip.chomp

    if line=~/^\#/ 
      #puts "comment:#{line}"
      next
    else
      #puts "processing:#{line}"
      filename=line
    end

    # 
    # assuming file name is 
    # config_process_voltage_temperature
    #
    base=File.basename(filename,".csv")
    arr=base.split(/_/)
    config=arr[1]
    process=arr[2]
    voltage=arr[3]
    temperature=arr[4]

    #arr.each{|item| puts item }
    #printf("%s,%s,%s\n",config,v,t)
    
    outFile = base + ".pwl"

    out = File.open(outFile,"w")
    csv = File.open(filename,"r")
    puts "opening " + filename

    timeCurrentArr=Array.new
    j=0

    imin=1e9
    imax=0

    # 
    # go through each line, store if
    # it is a line with comma and numbers
    #
    while (!csv.eof)
      data=csv.gets.strip.chomp
      #puts "data line: " + data

      if data=~/\,/ then
        (t,i)=data.split(/,/)

        if is_num(t) and is_num(i) then 
          #puts "#{t} #{i} are numbers" 

          t=t.to_f
          i=i.to_f

          timeCurrentArr[j]=Array.new
          timeCurrentArr[j][0]=t
          timeCurrentArr[j][1]=i

          if i.abs>imax then
            imax=i.abs
            tmax=t
            indexMax=j
          end

          if i.abs<imin then
            imin=i.abs
            tmin=t
            indexMin=j
          end

          j+=1

        else
          #puts "#{t} #{i} are not numbers"
        end

      end
    end

    csv.close

    arrSize = timeCurrentArr.length
    puts "arrSize: " + arrSize.to_s + " j:" + j.to_s
    puts "min: #{imin} at index #{indexMin}"
    puts "max: #{imax} at index #{indexMax}"

    pwlArray=Array.new
    c=0

    # need to normalize the time to 0 as some
    # sims are offset in time
    initialTime=timeCurrentArr[0][0]
    initialCurrent=timeCurrentArr[0][0]

    #PWL waveform: (5E-12, -6.89266E-05)
    out.printf("PWL waveform: ")

    0.upto(arrSize-1) do |j|

      check=(j.to_f/sample) 

      #check to see if element of the array
      #is divisible by the sample size

      if check==check.to_i
        pwlArray[c]=Array.new
        t=timeCurrentArr[j][0]-initialTime

        # negate the data as the current is peaking negative
        i=-1 * timeCurrentArr[j][1]

        # after max value time is reached, make
        # sure ratio of the data indicates the
        # data is not essentially zero
        
        ratio = i.abs/imax
        #puts "ratio: #{ratio} j:#{j} inxMax:#{indexMax} iabs:#{i.abs}"
        if j<=indexMax then

            pwlArray[c][0]=t
            pwlArray[c][1]=i

            printf("(%.3e,%.3e)\n",t,i)
            out.printf("(%.3e,%.3e) ",t,i)

            c+=1

        elsif j>indexMax 

          if ratio>minRatio then
            # keep on trucking
            #puts "ratio ok:#{ratio}"

            pwlArray[c][0]=t
            pwlArray[c][1]=i

            printf("(%.3e,%.3e)\n",t,i)
            out.printf("(%.3e,%.3e) ",t,i)

            c+=1
           else
            puts "ratio low:#{ratio} at time #{t}"
          end
        end
      end
    end
    
    out.printf("\n")
    out.close

    puts "See: #{outFile}"

  end

  csvList.close
end

def is_num(string)
  Float(string) rescue false
end

main
