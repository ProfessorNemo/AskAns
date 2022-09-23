# Ask-Ans

###### Ruby: `3.0.3` Rails: `6.1.6.` Language `Russian/English`

### About

Ask-me is an application where you can ask each other any questions and get answers, similar to the well-known ask.fm. The avatar for the user is added using a third-party global avatars service https://en.gravatar.com/site/implement/images/
The user can also change the background color of the profile. On the user page, you can leave questions and answer them. When adding a question, the algorithm looks for hashtags starting with "#", changes color and makes them clickable. Clicking on a hashtag will take you to a page with questions from all users with that hashtag. The hashtags of all users are displayed on the main page (Solutions like "tom-select" and "ajax" are used here.

(ajax - an asynchronous request to be sent here "/api/hashtags" and to pull out only those tags from here that match the user's criteria, i.e. based on what the user types)

For avatars:

Register on the site https://en.gravatar.com/.
Upload your avatar under the email that you are going to use on other sites. And then this avatar follows you on all sites where you register with the same email, unless of course these sites support gravatar.

[`reCAPTCHA`](https://www.google.com/recaptcha/about/) is used for spam protection.

A "manual approach" was used to authenticate and register users in the application
(without the use of libraries such as "device") !

Created a separate page for the administrator.
The administrator can upload the archived Excel file and create multiple users with a single request.

### Installation

1. Clone repo
```
$ git clone git@github.com:ProfessorNemo/AskAns.git
$ cd AskAns
```

2. Install gems
```
$ bundle
```

3. Create database and run migrations (At the same time, test users are loaded into applications from the users .xlsx file located in the "db" directory)
```
$ make initially
```

4. Generate `master.key` and credentials file (at first remove old file `config/credentials.yml.enc`)
```
$ EDITOR=nano rails credentials:edit
```

Set your `reCAPTCHA` keys if needed at `credentials.yml.enc`
```
recaptcha:
  site_key: <your site key>
  secret_key: <your secret key>
```
# Setting environment variables:

1st way:
```
$ nano ~/.bash_profile
export RECAPTCHA_ASKANS_PUBLIC_KEY="***************************************"
export RECAPTCHA_ASKANS_PRIVATE_KEY="**************************************"
```

2nd way:
```
$ EDITOR=vim rails credentials:edit
recaptcha:
  site_key: **************************************
  secret_key: ************************************
```

5. Start sever
```
$ bin/dev
```
### Some used gems

- [`rails-i18n`](https://github.com/svenfuchs/rails-i18n) to internationalization
- [`blueprinter`](https://github.com/procore/blueprinter) is a JSON Object Presenter for Ruby that takes business objects and breaks them down    into simple hashes and serializes them to JSON
- [`roo`](https://github.com/roo-rb/roo) for importing data from .xlsx to the database
- [`rspec-rails`](https://github.com/rspec/rspec-rails) for tests
- [`factory_bot_rails`](https://github.com/thoughtbot/factory_bot_rails)
- [`letter_opener`](https://github.com/ryanb/letter_opener) to send emails in the development
- [`pagy`](https://github.com/ddnexus/pagy) gem for separating content into pages
- [`bcrypt`](https://github.com/bcrypt-ruby/bcrypt-ruby) easy way to keep your users' passwords secure (use Active Model has_secure_password)
- [`valid_email2`](https://github.com/micke/valid_email2) to check the correctness of the entered email
- [`rubyzip`](https://github.com/rubyzip/rubyzip) this is a solution that allows you to work with .zip archives
- [`caxlsx`](https://github.com/caxlsx/caxlsx) this is a solution that allows you to create .xlsx files
- [`caxlsx_rails`](https://github.com/caxlsx/caxlsx_rails) this is a solution that allows you to work with templates
- [`activerecord-import`](https://github.com/zdennis/activerecord-import) this is a solution that allows you to import many records into the database in one query
- [`rubyXL`](https://github.com/weshatheleopard/rubyXL) this is a solution that allows you to read and modify .xlsx files
- to be continued...

Open `localhost:3000` in browser.
