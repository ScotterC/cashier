require 'redis'
require 'benchmark'
$: << File.join(File.dirname(__FILE__), '..')
require 'cashier'
ENV['RAILS_ENV'] = 'test'
require 'spec/dummy/config/environment'

Cashier::Adapters::RedisStore.redis = Redis.new :host => '127.0.0.1'

Dir.chdir(File.join(File.dirname(__FILE__)))
lowerarr = File.readlines('lowercase.txt')
upperarr = File.readlines('uppercase.txt')
mixedarr = File.readlines('mixedcase.txt')

puts "STORAGE"
['lowerarr', 'upperarr', 'mixedarr'].each do |arr_name|
  arr = eval(arr_name)
  totaltime = 0
  for i in 0..99 do
    Cashier::Adapters::RedisStore.redis.flushdb
    Rails.cache.clear
    time = Benchmark.realtime do
      arr.each do |tag|
        Cashier.store_fragment('foo', tag)
      end
    end
    totaltime += time
  end
  puts "#{arr_name}: average #{totaltime*10} milliseconds"
end

puts "\nRETRIEVAL"
['lowerarr', 'upperarr', 'mixedarr'].each do |arr_name|
  arr = eval(arr_name)
  totaltime = 0
  for i in 0..99 do
    Cashier::Adapters::RedisStore.redis.flushdb
    Rails.cache.clear
    arr.each do |tag|
      Cashier.adapter.store_fragment_in_tag(tag, 'foo')
    end
    Cashier.adapter.store_tags(arr)
    time = Benchmark.realtime do
      Cashier.keys_for('foo')
    end
    totaltime += time
  end
  puts "#{arr_name}: average #{totaltime*10} milliseconds"
end