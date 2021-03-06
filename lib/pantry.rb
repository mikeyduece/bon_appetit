require './lib/recipe'
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
    cookbook.each do |item, ing|
      ing.each_pair do |k,v|
        stock.each_pair do |key,val|
          if k==key && val >= v
            things << item
          end
          require "pry"; binding.pry
        end
      end
      #i want to use the recipe.amount_required
    end
    things.uniq
  end

end
