class WeatherConditionsController < ApplicationController
  def index
    # Choose the URL to visit
    @app_url = params[:url] || "http://api.openweathermap.org/data/2.5/weather?q=London,uk"
    # Ensure that the url starts with http
    @app_url = "http://#{@app_url}" unless @app_url.starts_with?("http")

    # Set weather_conditions variable equal to the return value of the get method
    # which is a JSON String retrieved from the specified API
    @weather_conditions = HTTParty.get(@app_url)
    # Set the variable data equal to the parsed body result of weather_conditions
    # this is a now a JSON object
    data = JSON.parse(@weather_conditions.body)

    # Assign instance variables to each JSON data object that needs to be rendered
    # in the index.html.erb template
    @location_name = data['name']
    @location_country = data['sys']['country']
    @longitude = data['coord']['lon']
    @latitude = data['coord']['lat']
    # Time.at converts unixtime to standard date time
    @date_time = Time.at(data['dt'])
    @current_conditions = data['weather'][0]['description'].titlecase
    @current_conditions_icon = data['weather'][0]['icon']
    # Convert the numeric values to Floats, some require conversion
    # Temperature values require conversion from degrees Kelvin to Celsius
    @current_temp = data['main']['temp'].to_f - 273.15
    @max_temp = data['main']['temp_max'].to_f - 273.15
    @min_temp = data['main']['temp_min'].to_f - 273.15
    @pressure = data['main']['pressure'].to_f
    @humidity = data['main']['humidity'].to_f
    # Convert meters per second to miles per hour
    @wind_speed = data['wind']['speed'].to_f * 2.23693629
    @wind_dir = data['wind']['deg'].to_f
  end

  def search
    @query = params[:query]
    respond_to do |format|
      format.js
    end       
  end
end
