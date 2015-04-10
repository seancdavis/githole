Githole
================

Githole is a wrapper for a specific versioning workflow using [Git](http://git-
scm.com/).

The Workflow
----------------

The workflow is designed to help you develop on several, concurrent
develop/release branches.

I'm working on an article to better explain this. In the meantime, here's an
overview.

The workflow is similar to [Vincent Driessen's popular git branching
model](http://nvie.com/posts/a-successful-git-branching-model/), with a few key
differences:

### 1: No `develop` Branch

There is no `develop` branch. Instead, the idea of develop, release and hotfix
branches are rolled into one. In other words, every remote branch (other than
master) reflects the bleeding edge relevant to the version after which that
branch is named.

### 2: No Merging to Master

There should be no commits to the master branch. Ever.

Instead, version branches get merged into master (via a pull/merge request) and
then deleted. You'll need to use a git application (like
[GitHub](https://github.com/), [Bitbucket](https://bitbucket.org/),
[GitLab](https://about.gitlab.com/), etc.) to use this method.

Pull/merge requests are nice because they encourage you to look through your
code one more time before bringing into the stable (production-ready) branch.

### 3: Keeping History Clean

To bring a feature branch up to date (required before you merge into version
branch), you need to bring in changes from master and the remote version branch
that you might not have.

Instead of *merging* these branches, I *rebase* them. This keeps your commit
history nice and clean (it's not littered with all these *Merged branch ...*
commits).

Installation
----------------

Since you're likely to use Githole globally on your machine, you'll want to
install it globally.

```text
$ gem install githole
```

Usage
----------------

A `githole` command looks like this:

```text
$ githole [action] [version]
```

The actions are explained below. For the version, I recommend you use
[Semantic Versioning](http://semver.org/). You'd simply pass the version you
want as your second argument.

Here's an example:

```text
$ githole add v1.4.1
```

### Add

`add` sets up your version and feature branches. It will check for local
version branches and figure out if it needs to pull or not.

Let's say you're going to work on v1.4.1. You would set it up by running:

```text
$ githole add v1.4.1
```

This creates a *version branch* -- `v1.4.1` -- and a *local feature branch* --
`local-v1.4.1`.

> **This workflow is specifically designed so you do not work in feature
> branches. You only merge into them after you have rebased them to your loacl
> branch.**

This command runs the following commands:

```text
$ git checkout -b v1.4.1
$ git pull origin v1.4.1 # if remote branch already exists
$ git push origin v1.4.1
$ git checkout -b local-v1.4.1
```

> There are a few checks worked in here so we don't try to create branches that
> already exist.

### Update

You should run update if you want to bring in changes that others have pushed
to origin.

While you can run this command at any time, I recommend at least doing it when
you begin a dev session.

```text
$ githole update v1.4.1
```

This runs the following commands

```text
$ git checkout master
$ git pull origin master
$ git checkout local-v1.4.1
$ git rebase master
$ git checkout v1.4.1
$ git pull origin v1.4.1
$ git checkout local-v1.4.1
$ git rebase v1.4.1
```

> There are a few checks worked in here to ensure these branches exist before
> we try to do anything with them.
>
> If they don't exist, we create and update them. In that way, it also
> encompasses `add` (but don't use it as a replacement).

### Push

Push first runs the update action, then pushes up to origin. Therefore, *you
don't have to run `update` before you run `push`.*

```text
$ githole push v1.4.1
```

In addition to the update commands, we run:

```text
$ git checkout v1.4.1
$ git merge local-v1.4.1
$ git push origin v1.4.1
$ git checkout local-v1.4.1
```

### Remove

Remove will simply delete your local branches when you're done. I suggest you
delete remote branches through your app's UI, just so you can use it as another
way to check yourself.

```text
$ githole remove v1.4.1
```

The remove action runs these commands:

```text
$ git checkout master
$ git branch -D v1.4.1
$ git branch -D local-v1.4.1
```

### Tag

Tag will pull and tag the `master` branch of your current repo, then *push all
tags* to origin.

This is a separate action because it has to happen **after the merge/pull
request is accepted.**

```text
$ githole tag v1.4.1
```

The tag action runs these commands:

```text
$ git checkout master
$ git pull origin master
$ git tag -a v1.4.1 -m "v1.4.1"
$ git push origin --tags
```

### Release

The `release` branch is used to maintain the latest stable (as `master` *could*
be used for testing scenarios you can't test on the version branch).

> `release` is to be used **in replacement to** `tag`, as it will also run
> `tag`.

The command is:

```text
$ githole release v1.4.1
```

In addition to the `tag` commands, this will run:

```text
$ git checkout [-b] release
$ git pull origin release
$ git merge master
$ git push origin release
$ git checkout master
```

Contributing
----------------

1. Fork it ( https://github.com/[my-github-username]/githole/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Changelog
----------------

* **v1.2.0**: Remove the auto "v" prefix from the branch and tag names
* **v1.1.2**: Never rebase onto a branch tracking a remote repository; always
  rebase onto a local-only branch
* **v1.1.1**: Switch to master before fetching
* **v1.1.0**: Add a `tag` action that pulls and tags master, then pushes tag
