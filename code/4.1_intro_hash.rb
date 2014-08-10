#!/usr/bin/env ruby
#-------------------------------------------------------------------------#
#  Esercitazioni in Laboratorio per il Corso di                           #
#  Fondamenti di Informatica e Calcolo Numerico, AA 2013/2014             #
#                                                                         #
#  Autori:   Enrico Bertolazzi e Carlos Maximiliano Giorgio Bort          #
#            Dipartimento di Ingeneria Industriale, Universita` di Trento #
#  Sito web: http://www.ing.unitn.it/~bertolaz/                           #
#                                                                         #
#  Contatti: enrico.bertolazzi@unitn.it, cm.giorgiobort@unitn.it          #
#                                                                         #
#  Copyright (c) 2014 E.Bertolazzi e C.M. Giorgio Bort                    #
#-------------------------------------------------------------------------#

# una hash e` un Array indicizzato, nel quale per accedere ad ogni elemento
# non uso il numero dell'indice corrispondente, bensì una chiave. 
# Quest'ultima tipicamente e` un Symbol.

### I SIMBOLI
# i Symbol rappresentano nomi all'interno dell'interprete di Ruby. sono così definiti:
s = :a 

# posso ottenere simboli a partire da stringhe, convertendo una stringa in un simbolo
str = "simbolo"
sym1 = str.to_sym
puts sym1
#oppure, in modo equivalente
sym2 = str.intern
puts sym2
# questo secondo metodo rende più chiaro che si sta cercando la
# rappresentazione interna all'interprete di 'str' se la mia stringa
# comprende anche spazi bianchi, il simbolo che ottengo diventa:
str = 'il mio simbolo'
sym = str.to_sym
puts sym
# però vedo che il mio simbolo non e` elegante, in quanto a causa 
# degli spazi bianchi nella stringa, Ruby mantiene le virgolette
# Se ho una stringa con spazi bianchi e la voglio convertire in 
# un simbolo la cui rappresentazione sia più elegante e comprensibile
#  posso fare in modo di mettere degli 'underscore' al posto degli spazi bianchi
sym = str.gsub(/\s+/, "_").downcase.to_sym
puts sym
# il comando '.gsub(/\s+/, "_")' sostituisce gli spazi bianchi nella 
# stringa con degli underscore "_". Questa operazione e` effettuata 
# ricorrendo alle espressioni regolari (le vedremo più avanti).
# Per il momento vi basti sapere che nell'esempio qui mostrato
# l'espressione regolare e` '/\s+/' e mi permette di trovare tutti
# gli spazi bianchi nella stringa.

# Posso anche convertire i numeri in simboli.
# Tuttavia, non esiste un metodo .to_sym per i numeri,
# infatti Ruby mi da un errore se scrivo:
a = 3
a.to_s.to_sym # oppure a.intern
puts a
# quello che devo fare e` prima rappresentare 'a' come una
# stringa ('to_s') e poi come un simbolo ('to_sym'):
a = 3
puts a.to_s.to_sym
# questo e` necessario perche` i simboli sono il modo con cui
# l'interprete di Ruby rappresenta i NOMI (i.e. le stringhe).
# Per i numeri la logica interna di rappresentazione e` diversa.
# Per questo motivo in generale non ha mai senso convertire numeri a simboli.


### LE HASH
# Definisco una hash in Ruby 1.8.7
cane = { :nome => "Rex", :anni => 7} # noi useremo sempre questa notazione
# definisco una hash in Ruby > 2.0.0
gatto = { nome: "Cesar", anni: 3}

# posso aggiungere dinamicamente chiavi alla mia hash
cane[:razza] = :dalmata
# in una hash posso mettere anche degli Array
cane[:colore] = ["nero", "bianco"]
puts cane

# Posso anche creare una hash vuota e aggiungere dinamicamente elementi
io = {}
io[:nome]  = "Maximiliano"
io[:sesso] = :maschio

# La hash può avere delle chiavi che puntano ad altre hash
io[:animali] = {:c => cane, :g => gatto}
puts io

# in questo caso, per sapere quanti anni ha il mio cane dovrò digitare
io[:animali][:c][:anni]





# Fino ad ora abbiamo visto che le chiavi sono dei Simboli,
# tuttavia posso definire come chiavi qualsiasi cosa:
h = {
  :sym        => "simbolo",
  3           => 33       ,
  "stringa"   => true,
  [1,2,3]     => ["uno", "due", "tre", "quattro"],
  {:a => 'a'} => "hash nella hash"
}
# ma la maggior parte delle volte usare chiavi che non sono
# simboli e` molto scomodo e può portare ad errori:
puts h[:sym]
puts h[3]
puts h[2] # questo mi da nil perche` non ho nessuna chiave pari a '2'
puts h['stringa']
puts h[ [1,2,3] ]
puts h[ {:a => 'a'} ]



### ITERARE IN UNA HASH
# Per ottenere il numero degli elementi nella hash, posso usare '.size' o '.length'
puts cane.size

# se ho hash annidate, il metodo '.size' (o '.length')
#  mi restituisce il numero degli elementi nella hash "radice"
puts io.size

# Dal momento che non posso accedere agli elementi della hash
# con degli indici interi, non posso iterare nella hash con un ciclo FOR.
# Per iterare nella hash sono costretto ad usare il metodo '.each'
cane.each do |chiave, valore|
  puts "#{chiave} corrisponde a #{valore}"
end
# in modo compatto:
cane.each{ |chiave, valore| puts "#{chiave} corrisponde a #{valore}" }

# posso iterare soltanto nelle chiavi della hash:
cane.each_key do |k|
  puts "#{k} e` una chiave di 'cane'"
end

# oppure posso iterare soltanto nei valori della hash
cane.each_value{ |v| puts "#{v} e` un valore della hash 'cane'" }

# tutti gli altri metodi delle hash sono visibili con il solito comando:
puts cane.methods.sort


