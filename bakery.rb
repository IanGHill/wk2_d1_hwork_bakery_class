class Bakery

  def initialize(bakery_name, cash, recipes, raw_materials)
    @bakery_name = bakery_name
    @cash = cash
    @recipes = recipes
    @raw_materials = raw_materials
  end

  def get_bakery_name
    return @bakery_name
  end

  def get_cash
    return @cash
  end

  def update_cash(adjustment)
    return @cash += adjustment
  end

  def get_recipe_by_name(recipe_to_find)
    return @recipes.find {|recipe| recipe[:name]  == recipe_to_find}
  end

  def insert_new_recipe(new_recipe)
    @recipes << new_recipe
  end

  def get_loaf_price(loaf_name)
    return get_recipe_by_name(loaf_name)[:sale_price_each]
  end

  def get_loaf_batch_size(loaf_name)
    return get_recipe_by_name(loaf_name)[:units_per_batch]
  end

  def get_loaf_stock(loaf_name)
    return get_recipe_by_name(loaf_name)[:stock_at_hand]
  end

  def update_loaf_stock(quantity,loaf_name)
    get_recipe_by_name(loaf_name)[:stock_at_hand] += quantity
  end

  def sell_loaves(quantity, loaf_name)
    if get_loaf_stock(loaf_name) >= quantity
      update_cash(get_loaf_price(loaf_name) * quantity)
      update_loaf_stock(quantity*-1,loaf_name)
    end
  end

  def get_raw_material_by_name(raw_material_name)
    return @raw_materials.find {|raw_material| raw_material[:name]  == raw_material_name}
  end

  def get_raw_material_qty(raw_material_name)
    return get_raw_material_by_name(raw_material_name)[:stock]
  end

  def update_raw_material_qty(amount,raw_material_name)
    get_raw_material_by_name(raw_material_name)[:stock] += amount
  end

  def bake_loaves(batches, loaf_name)
    recipe = get_recipe_by_name(loaf_name)
    flour_rqd = recipe[:flour] * batches
    yeast_rqd = recipe[:yeast] * batches
    salt_rqd = recipe[:salt] * batches

    if flour_rqd <= get_raw_material_qty("flour") &&
       yeast_rqd <= get_raw_material_qty("yeast") &&
       salt_rqd <= get_raw_material_qty("salt")

        batch_size = get_loaf_batch_size(loaf_name) * batches
        update_loaf_stock(batch_size, loaf_name)

        update_raw_material_qty(flour_rqd*-1,"flour")
        update_raw_material_qty(yeast_rqd*-1,"yeast")
        update_raw_material_qty(salt_rqd*-1,"salt")

    end

  end

end
