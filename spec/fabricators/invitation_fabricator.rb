Fabricator(:invitation) do 
  recipient_name  { Faker::Name.name }
  recipient_email { Faker::Internet.email }
  message         { "You should check out Myflix!" }
end