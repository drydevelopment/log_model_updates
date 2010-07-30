require File.dirname(__FILE__) + '/test_helper.rb'

class User < ActiveRecord::Base
end

class Post < ActiveRecord::Base
  include LogModelUpdates
end

class RowUpdate < ActiveRecord::Base
end

class LogModelUpdatesTest < Test::Unit::TestCase
  load_schema
  
  def test_row_updates_object
    r = RowUpdate.new
    assert_equal true, r.is_a?(RowUpdate)
  end

  def test_schema_has_loaded_correctly
    Post.delete_all if !Post.all.empty?
    RowUpdate.delete_all if !RowUpdate.all.empty?
    
    assert_equal [], Post.all
    assert_equal [], RowUpdate.all
  end
  
  def test_posts_class_methods
    assert_equal false, Post.respond_to?("current_user")
    assert_equal false, Post.respond_to?("row_updates")
  end
  
  def test_posts_instance_methods
    post = Post.new
    assert_equal true, post.respond_to?("current_user")
    assert_equal true, post.respond_to?("row_updates")
  end
  
  def test_current_user
    user = User.new(:email => 'test@test.com')
    post = Post.new(:title => "Title", :body => "Post body test.", :current_user => user)
    assert_equal user.email, post.current_user.email
  end
  
  def test_posts_insert_and_update
    User.delete_all if !User.all.empty?
    Post.delete_all if !Post.all.empty?
    RowUpdate.delete_all if !RowUpdate.all.empty?
    
    user = User.new(:email => 'test@test.com')
    user.save!
    
    post = Post.new(:title => "Title", :body => "Post body test.", :current_user => user)
    post.save!
    
    assert_equal 1, RowUpdate.all.size

    post.attributes = { :title => "XXX", :body => "XXX" }
    post.save!
    
    assert_equal 3, RowUpdate.all.size
  end
end
