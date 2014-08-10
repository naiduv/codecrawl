require 'rubygems'
require 'sdl'
require 'complex'

Taille=400
Amin=-1.25
Amax=1.25
Bmin=-1.25
Bmax=1.25

def convert(x,y)
  return Complex.new(x*(Amax-Amin)/Taille+Amin, y*(Bmax-Bmin)/Taille+Bmin)
end

def iterations(m,c)
  u=m
  for i in 1..100
    u=u**2+c
    return i if u.abs>=2
  end
  return -1
end

def trace(screen,c)
  for i in 0..(Taille-1)
    for j in 0..(Taille-1)
      m=convert(i,j)
      n=iterations(m,c)
      if n==-1
        screen[i,j]=[0,0,0]
      else 
        screen[i,j]=[(4*n)%256,2*n,(6*n)%256] 
      end
    end
    screen.flip
  end 
end

SDL.init( SDL::INIT_VIDEO )
screen = SDL::Screen.open(Taille,Taille,24,SDL::SWSURFACE)
trace(screen,Complex.new(-0.5,0.6))

while SDL::Event.poll.class!=SDL::Event::Quit
end
