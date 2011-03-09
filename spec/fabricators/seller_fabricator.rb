Fabricator(:seller, :class_name => 'kosher/seller') do
  merchant_id Faker::Amazon.merchant_id
end

Fabricator(:new_seller, :from => :seller) do
  average_rating 0.0
end

Fabricator(:good_seller, :from => :seller) do
  average_rating 5.0
end

Fabricator(:bad_seller, :from => :seller) do
  average_rating 4.5
end
