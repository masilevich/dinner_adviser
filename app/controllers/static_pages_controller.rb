class StaticPagesController < ApplicationController
	#before_filter :authenticate_user!, only: [:about]

  def home
  	if signed_in?
  		redirect_to advice_path()
  	end
  end

  def about
  end

  def contact
  end
end
