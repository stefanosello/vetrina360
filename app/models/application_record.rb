class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  connects_to shards: {
    default: { writing: :primary, reading: :primary },
    exampleretailcompany: { writing: :primary_exampleretailcompany, reading: :primary_exampleretailcompany },
    anotherretailcompany: { writing: :primary_anotherretailcompany, reading: :primary_anotherretailcompany }
  }
end
