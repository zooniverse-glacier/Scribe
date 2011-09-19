# Welcome to Scribe

Scribe is a framework for generating crowd sources transcriptions of image based documents.
It provides a system for generating templates which combined with a magnification tool guide 
a user through the process of transcribing an asset (an image). 

## Getting Started

1. We first need to install a mongodb server. This is then specified in config/mongodb.yml. Since databases are created lazily in MongoDB just specify the database name you want to use there.

2. Site settings (config/site_settings.hudson.yml) contains the application name and other detail about the project. You should rename site_settings.hudson.yml to site_settings.yml

3. To generate the templates for the project look at the lib/tasks/old_weather_bootstrap.rake file. You need to specify each entity type you wish transcribed and its fields along with help text for the user for each.

  Run:

  `bundle exec rake old_weather_bootstrap`

4. Run a webserver by typing:

  `bundle exec rails server`

5. profit!

## Assets

Assets are the objects which you wish to have the user transcribe. They contain a link to the image file to be shown, a desired width to be displayed at and a template_id to be applied to them

Assets can optionally be organised in to asset_collections. These are linear (with the order being determined by asset.order) collections of assets which the user will look through in turn.

## Classification rules

Classification rules are set up in asset.rb. The classificaiton_limit method can be altered to change the number of classifications an asset required before it is "done". 

## Interface

The main interface element is a JQuery UI plugin annotate.jquery.js . This plugin takes a template in json format, an asset location and display options and will generate transcriptions based on the user interaction. At the end of transcription the results will be posted back as json to the specified end point. More details can be found in (need to write more documents).

## API endpoints

- `/templates/:template_id` returns JSON for a given template
- `/assets/:asset_id` returns JSON for a given asset
- `/transcription/new` will save valid transcriptions which are POSTed to it.