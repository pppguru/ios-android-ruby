# Shared by models that have an affiliation (Company, User)
module HasAffiliation
  extend ActiveSupport::Concern

  included do
    belongs_to :affiliation, optional: true
  end
end
