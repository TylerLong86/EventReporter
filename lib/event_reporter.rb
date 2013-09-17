require 'csv'

class EventReporter

  attr_reader :csv

  def initialize
    @csv = nil
  end

  def run
    command = ''
    while command != 'quit'
      puts "What would you like to do"
      command = gets.chomp
     execute_command(command)
   end
 end

   def execute_command(command)
    command_parts = command.split(' ')
    
    command_valid(command_parts) ? run_valid_command(command_parts) : (puts "Sorry, I don't have a #{command_parts[0]} function")
    puts command_parts
  end


 def command_valid(command)
   valid_commands = ['load', 'help', 'queue', 'find']
   valid_commands.include?(command_parts[0])
 end

 def run_valid_commands(parts_array)
  case parts_array[0]
  when 'load' then load_method(parts_array[1..-1])
  when 'help' then help_method(parts_array[1..-1])
  when 'queue' then queue_method(parts_array[1..-1])
  when 'find' then find_method(parts_array[1..-1])
  end
 end

 def load_method(options)
  options.length == 1 ? load(options[0]) : (puts "Sorry, the correct load syntax is 'load <filename>'")
end

def load(filename)
  @csv = CSV.open filename, headers: true, header_converters: :symbol
end

def help(options=nil)
  options.nil? ? ['load', 'queue', 'find'] : describe_command(options[1])
  end

def describe_commands(command)
  command_valid(command) ? output_help(command) : puts "Sorry, but #{command} is not valid"


def queue(options)
 end

def find(options)
  end

end



 #e = EventReporter.new
 #e.run
