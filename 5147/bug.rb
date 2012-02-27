require 'test/unit'
require 'ruby-debug'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table :parents, :force => true do |t|
    t.timestamps
  end

  create_table :children, :forcer => true do |t|
    t.integer :parent_id
    t.timestamps
  end
end

class Parent < ActiveRecord::Base
  has_many :children, dependent: :destroy
end

class Child < ActiveRecord::Base
  belongs_to :parent
  
  def destroy
    false
  end
end

class BugTest < Test::Unit::TestCase
  def test_parent_destroyed
    parent = Parent.create
    child = Child.create(parent: parent)
    parent.destroy
    assert !parent.destroyed?
    assert_nothing_raised ActiveRecord::RecordNotFound do
      parent.reload
    end
  end

  def test_child_not_destroyed
    parent = Parent.create
    child = Child.create(parent: parent)
    parent.destroy
    assert_nothing_raised ActiveRecord::RecordNotFound do
      child.reload
    end
  end
end