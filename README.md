# tn-carto Project

This is a web project for integrating with Carto for geo-visualization.  Currently this covers targeting.

## Development

If you want to perform development and run this locally, you'll need to perform the following.

### Setup

* Determine how you want to setup a python application locally, the recommendation is creating a virtualenv or pipenv
(http://docs.python-guide.org/en/latest/dev/virtualenvs/) but this can also be done by updating/installing libraries 
globally.
* Perform a `pip install -r requirements.txt` to install all python packages/libraries from the root folder that this
project is setup


### Running

Just run the following command from the root folder:

`DEBUG=true python application.py`

The above puts the application into debug mode and allows hot reloading (changes get reflected immediately in the
rendered page with a refresh of the page.

The app will automatically un on port 8080; however, you can update the port number to another port number if you have
conflicts on that port.  This can be done by prefixing the running of the webserver with the `PORT` environment
variable.

Example:

`PORT=9000 python application.py`


The above two environment variables can also be combined:

`DEBUG=true PORT=9000 python application.py`


### Making changes to the source

This is now a Flask-based Python application using template-based code.  The actual source lives in the `login.html` and
the `index.html` within the `templates` folder.  Most changes should be made to the `index.html` for new features.

It also requires that you login before you can make changes, the default credentials (not what we
use in production) are USERNAME=`admin`, PASSWORD=`thinknear`.
