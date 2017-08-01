require 'minitest/autorun'
require 'minitest/pride'
require './lib/pantry'

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
end
# pantry.restock("Cheese", 10)
# pantry.stock_check("Cheese")
# # => 10
#
# pantry.restock("Cheese", 20)
# pantry.stock_check("Cheese")
# # => 30
# ```
# ### Iteration 2: Unit Conversions
#
# So far our Pantry and Recipes have used a 1-tier unit scale -- the tried-and-true UNIVERSAL UNIT. But this becomes somewhat cumbersome for a busy chef in their kitchen. No one wants to try to measure out .0001 Universal Units.
#
# Let's add a feature to our Pantry tracker that lets us output recipes with more readable unit conversions thrown in.
#
# We'll introduce these units:
#
# * Centi-Units -- Equals 100 Universal Units
# * Milli-Units -- Equals 1/1000 Universal Units
#
# Then, we'll add a new method, `convert_units`, which takes a `Recipe` and outputs updated units for it following these rules:
#
# 1. If the recipe calls for more than 100 Units of an ingredient, convert it to Centi-units
# 2. If the recipe calls for less than 1 Units of an ingredient, convert it to Milli-units
#
# Follow this interaction pattern:
#
# ```ruby
# # Building our recipe
# r = Recipe.new("Spicy Cheese Pizza")
# r.add_ingredient("Cayenne Pepper", 0.025)
# r.add_ingredient("Cheese", 75)
# r.add_ingredient("Flour", 500)
#
# pantry = Pantry.new
#
# # Convert units for this recipe
#
# pantry.convert_units(r)
#
# => {"Cayenne Pepper" => {quantity: 25, units: "Milli-Units"},
#     "Cheese"         => {quantity: 75, units: "Universal Units"},
#     "Flour"          => {quantity: 5, units: "Centi-Units"}}
# ```
#
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
