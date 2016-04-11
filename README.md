[![Build Status](https://travis-ci.org/livingbio/django-template.svg?branch=master)](https://travis-ci.org/livingbio/django-template)

# Django Template for GliaCloud

This is a django template for gliacloud

## INSTALLATION & SETTINGS

### Install Django

To install django, type the following command

    sudo pip install django

### Create Django project from the template

To create the project, run the following command and please replace your_project_name to what you like :

    django-admin.py startproject --template=https://github.com/livingbio/django-template/archive/master.zip --extension=py,md,yml,ini your_project_name

### Setting Virtualenv

At first, you should make sure you have [virtualenv](http://www.virtualenv.org/) installed.

after that, just cd to your_project_name:

    cd your_project_name

Then create your virtualenv:

    virtualenv venv

Second, you need to enable the virtualenv by

    source venv/bin/activate

Install all dependencies:

    pip install -r requirements.txt

### Setting up local environment variables

Settings are stored in environment variables via [django-environ](http://django-environ.readthedocs.org/en/latest/). The quickiest way to start is to copy and rename `local.sample.env` into `local.env`:

    cp src/demo_docker/settings/local.sample.env src/demo_docker/settings/local.env

Then edit the SECRET_KEY in local.env file, replace `g!!3v$af1jdyc4!92aoi&a^%_^4b2=)m=pyl1-b1xc5cd99_@i` into any [Django Secret Key](http://www.miniwebtool.com/django-secret-key-generator/), for example:

    SECRET_KEY=twvg)o_=u&@6^*cbi9nfswwh=(&hd$bhxh9iq&h-kn-pff0&&3


### Run web server

After that, just cd to `src` folder:

    cd src

And run migrate and http server:

    python manage.py migrate
    python manage.py runserver

### Documentation

You can use [mkdocs](http://www.mkdocs.org/) to write beatuiful documentations. By typing:

    mkdocs serve

Then you can see your document in http://localhost:8001/

### Detailed instructions

Take a look at the docs for more information.

