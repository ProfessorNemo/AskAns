# Ask-Ans

###### Ruby: `3.0.3` Rails: `6.1.6` Yarn: `3.2.1` Nodejs: `12.22.9` Node: `17.1.0` Language: `Russian/English`
###### Application screenshots are located in the "screenshots" directory

### About:

Ask-me is an application where you can ask each other any questions and get answers, similar to the well-known ask.fm.
On the user page, you can leave questions and answer them.

### For avatars:

The avatar for the user is added using a third-party global avatars service https://en.gravatar.com/site/implement/images/
Register on the site https://en.gravatar.com/. Upload your avatar under the email that you are going to use on other sites.
And then this avatar follows you on all sites where you register with the same email, unless of course these sites support gravatar.

### For hashtags:

When adding a question, the algorithm looks for hashtags starting with "#", changes color and makes them clickable. Clicking on a hashtag will take you to a page with questions from all users with that hashtag. The hashtags of all users are displayed on the main page (Solutions like "tom-select" and "ajax" are used here.
(ajax - an asynchronous request to be sent here "/api/hashtags" and to pull out only those hashtags from here that match the user's criteria, i.e. based on what the user types)

### Аuthentication and registration:

All logic related to authentication, registration, password creation and change
done with a manual approach (without the use of libraries such as "device") !

### Spam Protection:

[`reCAPTCHA`](https://www.google.com/recaptcha/about/) is used for spam protection.

### Administration:

Created a separate page for the administrator.
An administrator can upload zipped Excel files and create multiple users with a single request.

### API:
All users except guests have access to API. To access the API, which provides a response in JSON format, you need to generate an `api-token` on the user page, which will then be displayed on the profile edit page.

```
- users_api: http://127.0.0.1:3000/api/v1/users?api_token=************
- questions_api (for a specific username): http://127.0.0.1:3000/api/v1/users/username/questions?api_token=************
- hashtags_api: http://127.0.0.1:3000/api/v1/hashtags?api_token=****************
```

### Authorization:

Authorization (separation of access rights) in the application is implemented using the Pundit solution, policies are created, and a "guest user" service object is created. Access to the hashtag controller (as an experiment) is allowed only to the administrator...
A test archive with users for loading into the application is located in the directory "lib/zipusers.zip".

### Tasks running in the background:

The process of sending emails (in our case to the administrator), as well as importing and exporting users, runs in the background. The archive is saved using ActiveStorage (see config/storage.yml) to itself locally in the “storage” directory and then work is performed with this archive in ActiveJob. Tasks are performed with the support of the Sidekiq adapter. He knows how to interact with RoR, because RoR has ActiveJob - a functionality that allows us to submit our tasks for execution in the background. Sidekiq uses Redis, which is a SQL database for storing task information.
To install Redis, follow the link:

https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-20-04-en

Sidekiq has an interface that allows you to see what broke, how many tasks were completed, when it happened, how many connections, what version of Redis has, how much memory Redis is using, etc. To connect this interface in the address bar, write:
http://127.0.0.1:3000/sidekiq. Only the administrator has access to it.

The application is covered with tests...

### Frontend:
Made a migration from `Webpacker` to `Esbuild`.


### Sending letters:
In development, mail is sent using a solution such as `letter_opener`, while in production it is `Mailjet`.


### Installation:

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

4. Install and update all dependencies in "package.json" file
```
$ yarn install
```

5. Generate `master.key` and credentials file (at first remove old file `config/credentials.yml.enc`)
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
  secret_key: **************************************
api_token: ******************************************
```

5. Start server:
```
$ bin/dev
```

### Additional Information:

When executing the `make initially` console command to the application from the file "db/users.xlsx"
several test users and one more user with a built-in avatar are loaded from the file "db/seeds.rb".
After that, you need to appoint an admin. To do this, run the `make c` command in the console, and then write:

```
user = User.find_by id: ...
user.update role: 'admin'
user.reload
exit
```
Now you will have administrator rights to download, upload, delete, edit
and blocking users, as well as `http://127.0.0.1:3000/sidekiq`.
Test archive with users - "lib/zipusers.zip"

You can then run the tests with the `make rspec` command.

Ask a few questions and save to the database to generate hashtags for the address
`http://127.0.0.1:3000/api/v1/hashtags?api_token=****************`, which can only be accessed by the admin. From everyone question, 3 random hashtags are taken and entered into the database. Hashtags sorted alphabetically order and do not repeat. It should be noted that hashtags are generated only by questions,
set by registered users.

The `.env` file must contain the following information:
email, password, test user nickname, private and public key
Recaptcha and fake test token:

```
TEST_EMAIL=elizabeth-olsen@gmail.com
TEST_PASSWORD=Elizabeth1989!
TEST_USERNAME=Scarlet_Witch
FAKE_TOKEN=VX1wGmO7YJWfW8XL3PY4JtUOm4VpQDc6lXywhnh%2FrYnBtq0wKPnbbYAvSIy87cknI7hv
MAILJET_API_KEY = '**********************'
MAILJET_SECRET_KEY = '**************************'
MAILJET_SENDER = 'example@example.ru'
```

### Some used gems:

- [`rails-i18n`](https://github.com/svenfuchs/rails-i18n) to internationalization.
- [`pundit`](https://github.com/varvet/pundit) is a solution for creating a simple, reliable and scalable authorization system.
- [`blueprinter`](https://github.com/procore/blueprinter) is a JSON Object Presenter for Ruby that takes business objects and breaks them down into simple hashes and serializes them to JSON.
- [`bullet`](https://github.com/flyerhzm/bullet) this is a solution to improve the performance of an application by reducing the number of requests it makes.
- [`roo`](https://github.com/roo-rb/roo) for importing data from .xlsx to the database.
- [`rspec-rails`](https://github.com/rspec/rspec-rails) for tests.
- [`webmock`](https://github.com/bblimke/webmock) this is a library for stubbing and setting expectations on HTTP requests in Ruby.
- [`vcr`](https://github.com/vcr/vcr) record your test suite's HTTP interactions and replay them during future test runs for fast, deterministic, accurate tests.
- [`factory_bot_rails`](https://github.com/thoughtbot/factory_bot_rails)
- [`letter_opener`](https://github.com/ryanb/letter_opener) to send emails in the development.
- [`mailjet`](https://github.com/mailjet/mailjet-gem) This is a transactional and marketing email service.
- [`pagy`](https://github.com/ddnexus/pagy) gem for separating content into pages.
- [`bcrypt`](https://github.com/bcrypt-ruby/bcrypt-ruby) easy way to keep your users' passwords secure (use Active Model has_secure_password).
- [`dry-transaction`](https://github.com/dry-rb/dry-transaction) This is a library provides an easy way to define a complex business .transaction that involves multi-stage processing and many different objects, in particular to capture and return errors at any stage of the transaction.
- [`valid_email2`](https://github.com/micke/valid_email2) to check the correctness of the entered email.
- [`where_exists`](https://github.com/EugZol/where_exists) Rails way to harness the power of SQL EXISTS condition.
- [`rubyzip`](https://github.com/rubyzip/rubyzip) this is a solution that allows you to work with .zip archives.
- [`caxlsx`](https://github.com/caxlsx/caxlsx) this is a solution that allows you to create .xlsx files.
- [`caxlsx_rails`](https://github.com/caxlsx/caxlsx_rails) this is a solution that allows you to work with templates.
- [`activerecord-import`](https://github.com/zdennis/activerecord-import) this is a solution that allows you to import many records into the database in one query.
- [`rubyXL`](https://github.com/weshatheleopard/rubyXL) this is a solution that allows you to read and modify .xlsx files.
- [`Sidekiq`](https://github.com/mperham/sidekiq) uses threads to handle many jobs at the same time in the same process.

### Сommands to run tests:
```
$ make rspec
```

Open `localhost:3000` in browser.

