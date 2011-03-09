Fabricator(:offer, :class_name => 'kosher/offer') do
  seller { Fabricate(:good_seller) }
  description Kosher::Description.new('')
  condition { Fabricate(:kosher_condition) }
  ships_free false
  ships_in 48
  cents 100
end
