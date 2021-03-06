require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:peter)
  end

  test "profile displays correctly" do
    # visit user's profile
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do  |micropost|
      assert_match micropost.content, response.body
    end
    # test the stats
    assert_select 'div.stats'
    assert_select "a[href=?]", following_user_path(@user)
    assert_select "a[href=?]", followers_user_path(@user)
    assert_match @user.following.count.to_s, response.body
    assert_match @user.followers.count.to_s, response.body
    assert_select "a>strong.stat[id=?]", "following"
    assert_select "a>strong.stat[id=?]", "followers"
  end
end
