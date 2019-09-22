# seed timezone and regions

# Asia
TZInfo::Timezone.all.select{ |zone| zone.name.start_with? 'Asia' }.each do |timezone|
  Timezone.create!(name: timezone.name, world_region: :asia)
end

# Europe
TZInfo::Timezone.all.select{ |zone| zone.name.start_with? 'Europe' }.each do |timezone|
  Timezone.create!(name: timezone.name, world_region: :europe)
end

# US
TZInfo::Timezone.all.select{ |zone| zone.name.start_with? 'US' }.each do |timezone|
  Timezone.create!(name: timezone.name, world_region: :us)
end

puts "✅ Timezones populated"
