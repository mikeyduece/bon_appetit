class Pantry
  attr_reader :stock

  def initialize
    @stock = Hash.new(0)
  end

  def stock_check(item)
    stock[item]
  end

  def restock(ingredient, amt)
    stock[ingredient] += amt
  end

  def convert_units(r)
    ingredients = r.ingredients
    ingredients.reduce({}) do |result, (ing,amt)|
      result.store(ing, conversion(amt))
      result
    end
  end

  def conversion(amt)
    output = {}
    if amt < 1
      output = {quantity: (amt*1000).to_i,units: "Milli-Units"}
    elsif amt > 100
      output = {quantity: (amt/100), units: "Centi-Units"}
    else
      output = {quantity: amt,units: "Universal Units"}
    end
    # case amt
    # when (amt > 100) then output = {quantity: (amt/100).to_i, units: "Centi-Units" }
    # when (amt < 1)   then output = {quantity: (amt*1000).to_i, units: "Milli-Units"}
    # else
    #   output = {quantity: amt, units: "Universal Units"}
    # end
    output
  end
end
