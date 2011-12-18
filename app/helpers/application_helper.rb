module ApplicationHelper
  def avatar_url(user, options = {})
    options[:size] ||= 48
    link_to image_tag(user.gravatar_url(:size => options[:size]), :alt => "#{user.name}'s gravatar"), user_url(user.id), :title => "#{user.name}"
  end

  def gravta(email)
    gravatar_image_tag(email,:gravatar => { :size => 48 })
  end
end
