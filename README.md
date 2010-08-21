# Huffman Encoding in Ruby

        require 'huffman.rb'

        puts encoding = "Hello Huff".huffman

> 1101010000100010110011111111

        encoding.lookup.each do |code, char|
          puts "#{code} : #{char}"
        end

> 00 : l
> 010 :  
> 110 : H
> 011 : u
> 111 : f
> 100 : o
> 101 : e

Unit tests coming soon...

