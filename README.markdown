# Herogit: Git Love for Heroku

This plugin allows Heroku config information (credentials and
app/branch mapping) to be stored in Git's config files. It brutally
monkeypatches `Heroku::Command::Auth` and `Heroku::Command::Base`, so
I'd **love some help** from anybody with experience writing
better-behaved Heroku plugins.

## Credentials

I have a couple of personal Heroku projects, plus a fair number for
work. I'm sick of editing `~/.heroku/credentials` when I switch
personas. Let's fix that. In your project repo:

    git config --add heroku.email jbarnette@gmail.com
    git config --add heroku.password 0mgponies

If these two git config entries exist, they'll be used instead of
`~/.heroku/credentials`.

## Apps

I have two Heroku apps for a single work project; one for `next`
(staging) and one for `master` (production). Since I also have
multiple remotes pointing at Heroku, the command-line tool gets confused and asks me to supply `--app` manually.

    $ heroku config
    No app specified.
    Run this command from app folder or set it adding --app <app name>

Lame. Let's fix it:

    git config --add heroku.app.next myapp-next
    $ heroku config # totally works!

Add a `heroku.app.<branchname>` config entry for each branch you want
to strongly associate with a Heroku app. Specifing `--app` still
overrides this, natch.

## Installation

    heroku plugins:install git://github.com/jbarnette/herogit.git

## License

This work is hereby placed in the public domain.
