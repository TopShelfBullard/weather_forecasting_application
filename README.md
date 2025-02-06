# Weather Forecast Application

Here are the instructions for using this weather forecaster.
* Click on the signup link and sign up with an email.
* Once you are signed in, you will find yourself on an empty dashboard page that allows you to add a street address, a zip code, or an IP address into a text field.
* Enter one of these to get a forecast, and if your input is valid, the forecast for that location will be added to your dashboard.
* You can add as many locations as you want, and the app allows you to delete them and edit the title for each forecasted location.
* You are also able to log in and out from the dashboard page.

## Setup Notes
This app uses the Geocode.xyz API in order to retrieve the latitude and longitude of street addresses and zipcodes. Results will be throttled if an API key is not used.
* Sign up for a free account at https://geocode.xyz, and get your API key
* This API key should be added to the `config/credentials.yml.enc` file:
```yaml
geocode_api_key: your-api-key
```
