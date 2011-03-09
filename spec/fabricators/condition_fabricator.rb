Fabricator(:kosher_condition, :class_name => 'kosher/condition') do
  grade 1
end

Fabricator(:unkosher_condition, :class_name => 'kosher/condition') do
  grade 5
end
