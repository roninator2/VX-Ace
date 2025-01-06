module InstanceManager
  class << self; alias r2_setup_item_random_food_quality setup_item_instance; end
  def self.setup_item_instance(obj)
    value = obj.food_quality + 1
    obj.food_quality = rand(value).to_i
    r2_setup_item_random_food_quality(obj)
  end
end
