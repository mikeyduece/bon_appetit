require 'minitest/autorun'
require 'minitest/pride'
require './lib/pantry'
require './lib/recipe'

class PantryTest < Minitest::Test
  attr_reader :pantry

  def setup
    @pantry = Pantry.new
  end

  def test_it_exists
    assert_instance_of Pantry, pantry
  end

  def test_stock_is_empty_hash_at_start
    expected = {}
    assert_equal expected, pantry.stock
  end

  def test_stock_it_default_zero_for_given_item
    assert_equal 0, pantry.stock_check("Cheese")
  end

  def test_pantry_can_be_restocked
    pantry.restock("Cheese",10)
    assert_equal 10, pantry.stock_check("Cheese")
  end

  def test_can_restock_more
    pantry.restock("Cheese",10)
    pantry.restock("Cheese", 20)
    assert_equal 30, pantry.stock_check("Cheese")
  end

  def test_it_can_convert_units
    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Cayenne Pepper", 0.025)
    r.add_ingredient("Cheese", 75)
    r.add_ingredient("Flour", 500)
    expected = {"Cayenne Pepper" => {quantity: 25, units: "Milli-Units"},
                "Cheese"         => {quantity: 75, units: "Universal Units"},
                "Flour"          => {quantity: 5, units: "Centi-Units"}}
    assert_equal expected, pantry.convert_units(r)
  end

  def test_can_recommend_recipe
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)
    pantry.add_to_cookbook(r1)

    r2 = Recipe.new("Brine Shot")
    r2.add_ingredient("Brine", 10)
    pantry.add_to_cookbook(r2)
    require "pry"; binding.pry
    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)
    pantry.add_to_cookbook(r3)

    pantry.what_can_i_make # => ["Brine Shot", "Peanuts"]

  end
end
# ### Iteration 3: What Can I Make?
#
# Add a feature to your pantry that can recommend recipes for us to cook based on what
# ingredients we currently have in stock.
#
# Support this interaction pattern:
#
# ```ruby
# pantry = Pantry.new
#
# # Building our recipe
# r1 = Recipe.new("Cheese Pizza")
# r1.add_ingredient("Cheese", 20)
# r1.add_ingredient("Flour", 20)
#
# r2 = Recipe.new("Brine Shot")
# r2.add_ingredient("Brine", 10)
#
# r3 = Recipe.new("Peanuts")
# r3.add_ingredient("Raw nuts", 10)
# r3.add_ingredient("Salt", 10)
#
# # Adding the recipe to the cookbook
# pantry.add_to_cookbook(r1)
# pantry.add_to_cookbook(r2)
# pantry.add_to_cookbook(r3)
#
# # Stock some ingredients
# pantry.restock("Cheese", 10)
# pantry.restock("Flour", 20)
# pantry.restock("Brine", 40)
# pantry.restock("Raw nuts", 20)
# pantry.restock("Salt", 20)
#
# # What can i make?
# pantry.what_can_i_make # => ["Brine Shot", "Peanuts"]
#
# # How many can i make?
# pantry.how_many_can_i_make # => {"Brine Shot" => 4, "Peanuts" => 2}
# ```
#
# #### Iteration 4
#
# This works well as long as all of our units are evenly divisible, but lets see if we can handle mixed units.
#
# ```ruby
# # Building our recipe
# r = Recipe.new("Spicy Cheese Pizza")
# r.add_ingredient("Cayenne Pepper", 1.025)
# r.add_ingredient("Cheese", 75)
# r.add_ingredient("Flour", 550)
#
# pantry = Pantry.new
#
# # Convert units for this recipe
#
# pantry.convert_units(r)
#
# => {"Cayenne Pepper" => [{quantity: 25, units: "Milli-Units"},
#                          {quantity: 1, units: "Universal Units"}],
#     "Cheese"         => [{quantity: 75, units: "Universal Units"}],
#     "Flour"          => [{quantity: 5, units: "Centi-Units"},
#                          {quantity: 50, units: "Universal Units"}]}
# ```
#
