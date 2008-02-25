steps_for(:item_submit) do
  When "clicks on '$link'" do |link|
    clicks_link link
  end

  When "selects $field as '$option'" do |field, option|
    selects option, :from => field
  end
end
