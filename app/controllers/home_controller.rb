class HomeController < ApplicationController
	def home
	end

	def feed
		if current_user
			@graph = Koala::Facebook::API.new(current_user.token)		
		else
			redirect_to '/'
		end

		# Weather Stuff ==============================
		api_key = '637b5c553f2006b7'
		@weather = Wunderground.new(api_key)
		@forecast = @weather.forecast_for("MI","Ann%20Arbor")
		@highC = @forecast["forecast"]["simpleforecast"]["forecastday"].first["high"]["celsius"]
		@highF = @forecast["forecast"]["simpleforecast"]["forecastday"].first["high"]["fahrenheit"]
		@lowC = @forecast["forecast"]["simpleforecast"]["forecastday"].first["low"]["celsius"]
		@lowF = @forecast["forecast"]["simpleforecast"]["forecastday"].first["low"]["fahrenheit"]

		# Stories ===========================
		@stories = @graph.fql_query("SELECT post_id, actor_id, target_id, message FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = 'newsfeed') AND type=46 LIMIT 25")


		# Events =============================
		@events = @graph.get_connections("me", "events")
		@events_attending = []

		@events.each do |event|
			if event["rsvp_status"] == "attending"
				@events_attending << event
			end
		end
		@events_attending.sort! {|a,b| a[3] <=> b[3]}
		@events_attending.reverse!
		# =======================================

		# Sentiment analysis for individual stories ========================
		require 'open-uri' # uri-encoding
		alchemykey = "ee22e9e992f73d817539a187c1c406806dac81e4"

		@sentiments = []
		alchemycall = JSON.parse(open("http://access.alchemyapi.com/calls/text/TextGetTextSentiment?apikey=#{alchemykey}&outputMode=json&text=#{textinput}").read())

=begin
		counter = 0
		@stories.each do |s|
			if s["message"] != ""
				textinput = URI::encode(s["message"])
				
				if alchemycall["docSentiment"]["type"] != "neutral" 
					@sentiments[counter] = alchemycall["docSentiment"]["score"]
				else
					@sentiments[counter] = "neutral"
				end

			elsif
				@sentiments[counter] = ""
			end

			counter += 1
		end
		# ======================================================================

		# Overall sentiment =====================================================
		totalsentiments = 0
		sentimentsum = 0
		@sentiments.each do |s|
			unless s == ""
				unless s == "neutral"
					sentimentsum += s.to_f
				end
				totalsentiments += 1
			end
		end

		@overall_sentiment = sentimentsum / totalsentiments
		# ======================================================================
=end
	end


end
