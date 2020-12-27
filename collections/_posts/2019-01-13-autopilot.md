---
layout: post
title: "The cold-start problem in productivity"
---

How is it that some people just "get stuff done" while others get stuck on the first step?

There's more complexity than we think in day-to-day activities, and if you're starting "cold" on an activity - even one 
you've done before - then your excitement and motivation can be extinguished by a simple task you've forgotten how to do.

This is a special case of the "not knowing what you don't know" problem, and it can be paralyzing. My solution is to
keep playbooks - miniature guides that get you over that motivation-killing hump at the beginning of a project.

For example, this blog isn't easy to operate/ It's a Jekyll website hosted on Github Pages, hooked up to my domain. If
I spent time away from it then I'll quickly forget how to operate it, and that blocker can be enough to dampen my 
motivation to post after a break.

There's only 2-3 things to remember in order to operate this website, so if I can write them down (or better yet, 
encapsulate them in a script) then the return on that time-investment could be measured in tens or dozens of blog posts.

There's a great CLU tool called [tldr](https://tldr.sh/) which applies this philosophy to the myriad CLI tools found on
Linux.

Anyway, here's an intro to my approach to identifying blockers, writing mini-guides ("Playbooks"), and making those guides easily
accessible.


## <center>Analysis</center>

To analyze how I use my time, I started keeping a time journal. This is just a section of my regular daily journal where 
I write down the time of everything I do each day. The goal is to answer two questions "how long do I spend making 
decisions about boring stuff?", and "how often do I switch contexts?".

<img src="{{ site.url }}/static/time-journal.jpg" width="800" height="300" style="object-fit: cover;">

Once you have tracked a few weeks of this data, you can spot interesting developments.

Some of the things I looked at were: the average time I spent on an "important" task before switching to something else, \
the number of times I picked up my smartphone (wow!), the number of context-switches I made, and the total # of hours 
I spent per day on high-priority tasks.

Turns out, I spend a lot less time on important tasks than I thought I did, and a lot of the time I spend "doing" 
something is actually spent thinking about it rather than doing it. 

For me, there was a lot of friction involved in getting stuff done.

- 15 minutes looking up a recipe because I forgot, again.
- 30 minutes trying to re-learn to steps to update an AWS Lambda function.
- 20 minutes worrying about how to start marketing a blog on the internet.
- 35-minute attention span, on average.
- 10+ context switches in a day.

These are the kinds of insights you can get from analyzing your time effectively, and it's really eye-opening. Even when 
we feel productive, we probably aren't. And we don't figure it out until the debt builds up high enough to be noticeable.

For me, the two biggest factors I noticed were:

1. Not knowing how to do something.
2. Not feeling like I'm making progress, and therefore losing interest.

My struggles can be split into two categories: __complex things__, and __annoying things__.

## <center>Plan</center>

My strategy for improving this situation is to create recipes for completing complex and/or annoying tasks.

Think about what a recipe looks like for something like spaghetti carbonara:

1. Chop a small onion, some garlic, and pancetta bacon.
2. Mix up 2x egg yolks, and 1x full egg in a glass
3. Add pepper, salt, and parmesan cheese to the egg mixture
4. Put spaghetti into boiling salted water
5. Fry the pancetta until golden, add the onion and garlic
6. Move the spaghetti directly from the water into the pan and mix
7. Add spaghetti and mix around for 30 seconds
8. Serve.

Recipes allow non-chefs to cook arbitrarily complex meals with minimal thought. This is exactly what I want, but for 
everything. After a while, they become habits.

<p class="quote">Playbooks become habits, and habits are frictionless</p>

Let's take this idea of recipes and apply it to something more relevant: setting up an AWS Lambda function to run once every 5 minutes.

1. Initialize
    1. `pip install zappa`
    2. `touch src/app.py`
    2. `zappa init`
    3. `zappa deploy`
2. Add database access
    1. Add `"aws_environment_variables": { ... }` to zappa config
    2. Populate it with values for `RDS_DB_NAME`, `RDS_USERNAME`, `RDS_PASSWORD`, `RDS_HOSTNAME`, and `RDS_PORT`
    3. Add `"vpn_config": { ... }` to zappa config
    4. Add `"SubnetIds": [ ... ]` for the RDS instance
    5. Add `"SecurityGroupIds": [ ... ]` for the RDS instance
3. Add a rule for executing every 5 minutes
    1. Add `events: [ ... ]` list, with one object which contains:
    2.  `"function": "src.app.lambda_handler"`, and `"expression": "rate(5 minutes)"`

This playbook has three effects on me. Firstly, it eliminates the fear of starting something new. Secondly, it cuts out "figuring it out" phase at the beginning, once I finally overcome that fear. Thirdly, it greatly reduces the chances that I'll forget something or get something wrong.

A scary, confusing, and risky task has suddenly become so easy that I can do it stress-free while listening to a podcast or watching YouTube videos - just like my experience cooking. This is what I want.

## <center>Action</center>

I've tried something like this before but failed because I simply didn't use the playbooks. I half-arsed the whole thing 
so they weren't accessible enough and I just didn't really follow-through. To fix that, I decided to make them accessible, 
memorable, and easy to use. Here's some of the ways that I'm doing that so far:

#### Website
I decided to make my playbooks available [here](http://rorys.life/playbooks/) on my website. It's a Jekyll website, so
all I have to do is add each new playbook as a YAML file.

#### JSON API

I also want to expose the playbooks via a JSON api. This isn't what Jekyll is designed to do, since it's a static 
website builder, but I found a [blog post](https://bilaw.al/building-apis-with-jekyll.html) about it.

The idea is to put the API data into a `_data` directory structure, then exposes it in a root-level `stuff.json` file 
which looks like this:

<code>
        {{ site.data.stuff | jsonify }}
</code>

This doesn't work for me, since I want to 1) automatically generate webpages for my playbooks, and 2) generate a 
`playbooks.json` file. Jekyll allows you to render each file once, only.

The way I finally found to do this was as follows:

1. Create a `collection` for my playbooks:  
   `<root>/collections/_playbooks/`
2. Configure my `_config.yml` to render those playbooks using a template:

        collections_dir: collections 
        collections:
            playbooks:
                output: true
                permalink: /playbooks/:path/

        defaults:
        -
            scope:
            path: ''
            type: playbooks
            values:
            layout: playbook-detail

   The `output: true` field asks Jekyll to render each item in the `playbooks` collection, and in `defaults` I
   set the layout as `playbook-detail`.

   So far, so good: I can add files to the `collections/_playbooks/` directory and they will be rendered using a template.
3. Next, I did something sneaky: I wrote the playbooks in YAML format but stored them as `.md` files in the collection directory.

   Since they're .md files, Jekyll will pick them up and process them using the template, but since they're YAML structure, 
   I can do the following:
4. Create a root-level `playbooks.json` file which looks like this:

        {% raw %}
        ---
        ---
        [
            {% for pb in site.playbooks %}
                {
                    "name":"{{ pb.name }}",
                    "identifier":"{{ pb.identifier }}",
                    "steps":{{ pb.steps | jsonify }}
                }{% if forloop.index0 == 0 %},{% else %}{% endif %}
            {% endfor %}
        ]

        {% endraw %}

   My `playbooks.json` file just loops through the structured YAML file to create a JSON file which is essentially my API. Job done!

I created a command-line tool to consume the API, available [here](https://github.com/synek/Playbook-Viewer).

I'm planning to do more stuff to make these playbooks accessible, and hopefully I can get to the point where they 
actually help me create new habits and get stuff done quickly and painlessly.
