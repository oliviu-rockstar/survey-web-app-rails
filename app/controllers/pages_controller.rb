class PagesController < ApplicationController
	def lbstatus
		render :text => 'ok', :layout => false
	end

  def splash
    @beta_user = BetaUser.new
  end

  def about
  end

  def news
  end

  def contact
  end
end
