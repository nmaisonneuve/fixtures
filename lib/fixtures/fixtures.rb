class ActiveRecord::Base

#require 'yaml'
require 'digest/md5'
require 'fileutils'

def to_hash
  hash = {}; self.attributes.each { |k,v| hash[k.to_sym] = v }
  return hash
end

def to_fixtures
  hash = self.to_hash
  md5 = Digest::MD5.hexdigest(hash.to_s)
  table_name = self.class.table_name
  id= "#{table_name}:\n" 
  string = 
  hash.each do |key,value|
    value.gsub!("\n","\n"+" "*4) if value.class == String
    string += " "*2 + "#{key.to_s}: #{value}\n" unless value.nil?
  end
  string += "\n"
  path=FixtureGenerator.current_dir
  FileUtils.mkpath path unless File.directory? path
  file_name = table_name + ".yml"
  File.open("#{path}/#{file_name}", 'a') do |out|
    out.write(string)
  end
end


end
