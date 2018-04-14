# DayBreakers.co Backend

This is the backend part of the DayBreakers.co app.
It's a Rails (API) app that exposes two endpoints, `/graphql` for graphql queries and `/photos` to upload photos.

Requirements:

* MongoDB

Installation:

** This app has to run on port 3001, as the frontend app already runs on 3000**

* Clone the repo: `git clone git@github.com:daybreakers-co/backend.git`
* Install gems: `bundle install`
* Start MongoDB and webserver: `bundle exec foreman start`
* Run the webserver: `rails s -p 3001`
