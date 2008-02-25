steps_for(:database) do
    Given "no item $item exists" do |item_name|
      Item.destroy_all(:name => item_name)
      Item.find_by_name(item_name).should be_nil
    end
  end
end
