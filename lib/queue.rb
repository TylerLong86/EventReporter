require 'csv'
require './lib/attendee.rb'
require './lib/phone_number.rb'
require './lib/zipcode.rb'
require './lib/city.rb'

class Queue

  attr_reader :attendees

  def initialize(filename)
    @attendees = create_attendees_array filename
  end

  def create_attendees_array(filename)
    csv = CSV.open filename, headers: true, header_converters: :symbol 
    csv.collect do |row|
      arguments_hash = {}
      arguments_hash[:regdate] = clean_date row[:regdate]
      arguments_hash[:first_name] = row[:first_name]
      arguments_hash[:last_name] = row[:last_name]
      arguments_hash[:email_address] = row[:email_address]
      arguments_hash[:homephone] = clean_phone row[:homephone]
      arguments_hash[:street] = row[:street].nil? ? "no street" : row[:street]
      arguments_hash[:city] = clean_city row[:city]
      arguments_hash[:state] = row[:state].nil? ? "no state" : row[:state]
      arguments_hash[:zipcode] = clean_zipcode row[:zipcode]
      Attendee.new arguments_hash
    end
  end

  def count
    @attendees.count
  end

  def clear
    @attendees.clear
  end

  def clean_date(date_string)
    DateTime.strptime(date_string, "%m/%d/%y %H:%M")
  end

  def clean_phone(phone_string)
   PhoneNumber.new phone_string
  end

  def clean_city(city_string)
    city_string.nil? ? City.new : City.new(city_string)
  end


  def clean_zipcode(zip_string)
   zip_string.nil?  ? Zipcode.new : Zipcode.new(zip_string)
  end

  def print(att=nil)
    return_string =  ''.rjust(155, '-') + "\n" 
    return_string += 'LAST NAME'.ljust(15, " ") 
    return_string += 'FIRST NAME'.ljust(15, " ") 
    return_string += 'EMAIL ADDRESS'.ljust(35, ' ') 
    return_string += 'ZIPCODE'.ljust(10, " ") 
    return_string += 'CITY'.ljust(20, ' ') 
    return_string += 'STATE'.ljust(10, ' ')
    return_string += 'ADDRESS'.ljust(35, " ")
    return_string += 'PHONE'.ljust(15, ' ') + "\n"
    return_string += ''.rjust(155, '-') + "\n"

     attendees_to_print = att.nil? ? @attendees : att 

     attendees_to_print.each do |attendee|
      return_string += attendee.last_name.ljust(15, " ")
      return_string += attendee.first_name.ljust(15, " ")
      return_string += attendee.email_address.ljust(35, ' ')
      return_string += attendee.zipcode.digits.ljust(10, ' ')
      return_string += attendee.city.city_name.ljust(20, " ") 
      return_string += attendee.state.ljust(10, ' ')
      return_string += attendee.street.ljust(35, ' ')
      return_string += attendee.homephone.digits.ljust(15, ' ') +"\n"
    end
    return_string
  end

  def sort_by(attribute)
    sorted_attendees = @attendees.sort_by {|attendee| attendee.send("#{attribute}")}
  end

  def print_by_attribute(attribute)
    print sort_by(attribute)
  end
  def print_find(attribute, value)
    print find_by_attribute(attribute, value)
  end

  def find_by_attribute(attribute, value)
    case attribute
    when 'first_name' then @attendees.find_all {|attendee| attendee.first_name == value}
    when 'last_name' then @attendees.find_all {|attendee| attendee.last_name == value}
    when 'email_address' then @attendees.find_all {|attendee| attendee.email_address == value}
    when 'zipcode' then @attendees.find_all {|attendee| attendee.zipcode.digits == value}
    when 'city' then @attendees.find_all {|attendee| attendee.city == value}
    when 'state' then @attendees.find_all {|attendee| attendee.state == value}
    when 'address' then @attendees.find_all {|attendee| attendee.street == value}
    when 'phone' then @attendees.find_all {|attendee| attendee.homephone.digits == value}
    end
  end

end
