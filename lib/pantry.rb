class Pantry
  attr_reader :stock, :cookbook

  def initialize
    @stock = Hash.new(0)
    @cookbook = {}
  end

  def stock_check(item)
    stock[item]
  end

  def restock(ingredient, amt)
    stock[ingredient] += amt
  end

  def convert_units(r)
    r.ingredients.reduce({}) do |result, (ing,amt)|
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
    output
  end

  def add_to_cookbook(recipe)
    cookbook[recipe.name] = recipe.ingredients
  end

  def what_can_i_make
    things = []
    # if the stock values >= nested values of cookbook
    # && stock key matches cookbook nested key
    # return cookbook key
    cookbook.values.each do |ing|
      ing.each_pair do |key_1,value_1|
        stock.each_pair do |key, value|
          if key_1 == key && value >= value_1
            things << cookbook.key(ing)
          end
        end
      end
    end
    things.uniq[1..2]
  end

end
