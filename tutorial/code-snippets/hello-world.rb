require 'pp'

a = [0, 1, 2, 5, 7].to_a

puts '==========='

class Fixnum
  def div_3?
    self % 3 == 0
  end

  def neg
    self * -1
  end
end

pp a.product(a)
  .product(a)
  .map(&:flatten)
  .map(&:join)
  .map(&:to_i)
  .find_all(&:div_3?)
  .sort_by(&:neg)

pp a.product(a)
  .product(a)
  .map { |i| i.flatten }
  .map { |i| i.join }
  .map { |i| i.to_i }
  .find_all { |i| i.div_3? }
  .sort_by { |i| i.neg }
