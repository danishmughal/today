class HomeController < ApplicationController
	def home
	end

	def feed
		if current_user
			@graph = Koala::Facebook::API.new(current_user.token)		
		else
			redirect_to '/'
		end
	end
end
