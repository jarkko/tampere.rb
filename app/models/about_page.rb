class AboutPage < ActiveRecord::Base
  set_table_name 'about_page'
  validates_presence_of :content

  def editable_by?(user)
    user.admin?
  end

  def self.find_or_create_new
    page = self.find(:first) || self.new(:content => 'edit me')
    page.save if page.new_record?
    page
  end
end
