class HomeController < ApplicationController
	def home
	end

	def feed
		if current_user
			@graph = Koala::Facebook::API.new(current_user.token)		
		else
			redirect_to '/'
		end

		api_key = '91cef335b0f2f621'

		@weather = Wunderground.new(api_key)
		@forecast = @weather.forecast_for("MI","Ann%20Arbor")

		@highC = @forecast["forecast"]["simpleforecast"]["forecastday"].first["high"]["celsius"]
		@highF = @forecast["forecast"]["simpleforecast"]["forecastday"].first["high"]["fahrenheit"]

		@lowC = @forecast["forecast"]["simpleforecast"]["forecastday"].first["low"]["celsius"]
		@lowF = @forecast["forecast"]["simpleforecast"]["forecastday"].first["low"]["fahrenheit"]

	end
end
