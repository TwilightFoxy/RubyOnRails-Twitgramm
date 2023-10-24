
FactoryBot.define do
  factory :post do
    description { "Test description" }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'sample.png'), 'image/png') }
    user
  end
end
