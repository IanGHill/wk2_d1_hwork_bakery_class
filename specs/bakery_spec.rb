require('minitest/autorun')
require('minitest/reporters')
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative('../bakery.rb')

class BakeryTest < Minitest::Test

  def setup

    recipes = [
      {
        name: "crusty rolls",
        flour: 3.5,
        yeast: 0.15,
        salt: 0.05,
        units_per_batch: 50,
        sale_price_each: 0.5,
        stock_at_hand: 0
      },
      {
        name: "rye loaf",
        flour: 3.6,
        yeast: 0.2,
        salt: 0.07,
        units_per_batch: 12,
        sale_price_each: 3.5,
        stock_at_hand: 12
      },
      {
        name: "sourdough",
        flour: 4.0,
        yeast: 0,
        salt: 0.08,
        units_per_batch: 12,
        sale_price_each: 4,
        stock_at_hand: 24
      }

    ]

    raw_materials = [
      {
        name: "flour",
        stock: 10,
        cost_per_kg: 1.5
      },
      {
        name: "yeast",
        stock: 0.5,
        cost_per_kg: 7.5
      },
      {
        name: "salt",
        stock: 0.5,
        cost_per_kg: 0.50
      }
    ]

    @new_recipe = {
      name: "batch loaf",
      flour: 3.7,
      yeast: 0.1,
      salt: 0.06,
      units_per_batch: 15,
      sale_price_each: 2.5,
      stock_at_hand: 0
    }

    @bakery = Bakery.new("Riddle-Me-Rye", 50, recipes, raw_materials)

  end

# Test to retrieve the bakery name
  def test_get_bakery_name
    assert_equal("Riddle-Me-Rye", @bakery.get_bakery_name)
  end

# Test to get the cash position
  def test_get_cash
    assert_equal(50, @bakery.get_cash)
  end

  # Test to update the cash position
  def test_update_cash
    assert_equal(60, @bakery.update_cash(10))
  end

# Test to get recipe by name - found
  def test_get_recipe_by_name
    assert_equal("sourdough", @bakery.get_recipe_by_name("sourdough")[:name])
  end

# Test to get recipe by name - not found
  def test_get_recipe_by_name__not_found
    assert_nil(@bakery.get_recipe_by_name("bloomer"))
  end

# Test to insert new recipe & then find by name
  def test_insert_new_recipe
    @bakery.insert_new_recipe(@new_recipe)
    assert_equal("batch loaf", @bakery.get_recipe_by_name("batch loaf")[:name])
  end

# Test to get loaf price
    def test_get_loaf_price
      assert_equal(4, @bakery.get_loaf_price("sourdough"))
    end

# Test to get loaf batch_size
    def test_get_loaf_batch_size
      assert_equal(12, @bakery.get_loaf_batch_size("sourdough"))
    end

# Test to get stock of unsold loaves remaining
  def test_get_loaf_stock
    assert_equal(24, @bakery.get_loaf_stock("sourdough"))
  end

# Test to update quantitiy of loaves in stock
  def test_update_loaf_stock
    assert_equal(28, @bakery.update_loaf_stock(4,"sourdough"))
  end

# Test to sell some loaves
  def test_sell_loaves
    @bakery.sell_loaves(4,"sourdough")
    assert_equal(20, @bakery.get_loaf_stock("sourdough"))
    assert_equal(66, @bakery.get_cash)
  end

# Test to get raw material by name
  def test_get_raw_material_by_name
    assert_equal("flour", @bakery.get_raw_material_by_name("flour")[:name])
  end

# Test to get raw material stock levels
  def test_get_raw_material_qty
    assert_equal(10, @bakery.get_raw_material_qty("flour"))
  end

# Test update of raw material stock levels
  def test_update_raw_material_qty
    assert_equal(15, @bakery.update_raw_material_qty(5,"flour"))
  end

# Test bake a batch of bread - rye
  def test_bake_loaves
    @bakery.bake_loaves(1, "rye loaf")
    assert_equal(24, @bakery.get_loaf_stock("rye loaf"))
    assert_equal(6.4, @bakery.get_raw_material_qty("flour"))
    assert_equal(0.3, @bakery.get_raw_material_qty("yeast"))
    assert_equal(0.43, @bakery.get_raw_material_qty("salt"))
  end
end
