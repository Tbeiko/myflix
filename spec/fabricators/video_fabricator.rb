Fabricator(:video) do 
  title { Faker::Lorem.words(5).join(" ") }
  description { Faker::Lorem.paragraphs(2).join(" ") } 
end