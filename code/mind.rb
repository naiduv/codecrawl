#the mind produces personality,
#and down that road, everything
#is just ideas that don't work.

require "e2mmap.rb"

module ExceptionForMind
  extend Exception2MessageMapper
  def_exception("EmptyMindException", "An empty mind occurred. Success, that is?")
end

class Mind
  include ExceptionForMind

  def initialize
    @thoughts = ["hu!", "vaad?", "um."]
  end

  def personality(human)
    mood = @thoughts.shift
    if mood != nil
      yield mood + human.body
    else
      raise EmptyMindException
    end
  end
end

class Human
  def initialize
    @mind = Mind.new
    @body = 'X'
  end

  def body
    return @body
  end

  def act
    while true
      @mind.personality(self) {|person| 
        puts person
      } 
    end
  end
end

human = Human.new
human.act

#12:02 < antont> .. illalla myöhään umpiväsyneenä saunan jälkeen samalla kun puoleksi seuras sitä jotain hupsua elokuvaa telkkarista (siitä on osa tuota mottoa :)

