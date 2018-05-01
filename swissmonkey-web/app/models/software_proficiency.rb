# == Schema Information
#
# Table name: software_proficiencies
#
#  id         :integer          not null, primary key
#  name       :string(250)      not null
#  value      :string(250)
#  status     :string(1)
#  parent_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

# Represents a software application in the dental space that a user can indicate proficiency in
class SoftwareProficiency < ApplicationRecord
  belongs_to :parent, class_name: 'SoftwareProficiency'
  has_many :children, foreign_key: :parent_id, class_name: 'SoftwareProficiency', dependent: :nullify

  scope :top_level, -> { where parent_id: nil }
  scope :with_parents, -> { where.not parent_id: nil }
  scope :with_children, -> { where(id: with_parents.map(&:parent_id).uniq) }
  scope :without_children, -> { where('parent_id IS NULL AND id NOT IN (?)', with_parents.map(&:parent_id).uniq) }

  def name_with_children(skills)
    return unless skills.include?(id)

    calc_name = name
    if children.any?
      sub_names = []
      children.each do |child|
        sub_names << child.name if skills.include?(child.id)
      end
      calc_name += "(#{sub_names.join(', ')})" if sub_names.any?
    end
    calc_name
  end

  def to_h
    {
      id: id,
      name: name,
      value: value,
      status: status,
      child: SoftwareProficiency.where(parent_id: id).map(&:to_h)
    }
  end

  def self.ordered_skills
    all # .map(&:to_h)
  end
end
