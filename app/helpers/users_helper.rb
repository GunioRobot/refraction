module UsersHelper
  def display_remote_user_name(id,base_uri)
    result=HTTParty.get base_uri+'/users/'+id+'.xml'
    link_to result['user']['name'], base_uri+'/users/'+id
  end

  def gravta(id,base_uri)
    result=HTTParty.get base_uri+'/users/'+id+'.xml'
    gravatar_image_tag(result['user']['email'],:gravatar => { :size => 40 })
  end
end
