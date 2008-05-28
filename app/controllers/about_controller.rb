class AboutController < ApplicationController
  def show
    @page = AboutPage.find_or_create_new
  end

  def edit
    @page = AboutPage.find_or_create_new
  end

  def update
    @page = AboutPage.find(:first)
    @page.content = params['about_page']['content']
    if @page.save && @page.editable_by?(current_user)
      flash[:notice] = 'Päivitys onnistui'
      redirect_to '/about'
    end
  end
end
