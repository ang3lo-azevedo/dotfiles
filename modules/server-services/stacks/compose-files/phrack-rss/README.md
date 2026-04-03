# Phrack RSS

![License](https://img.shields.io/github/license/rmi7/phrack-rss.svg?style=flat-square)

> Create RSS feed from Phrack.org

The wonderful website [Phrack.org](http://phrack.org) does not have an RSS feed.
This module will parse the entire website and create an RSS Feed which you can subscribe to.

- will include papers and issue/articles in the RSS feed
- will check for new papers + issue/articles every 10 seconds

## Prerequisites

Since it uses `async/await`, `node v8.x` is needed. (**TIP**: use [nvm](https://github.com/creationix/nvm))

## Setup

``` bash
npm install
```

## Run

```bash
npm start
```

## Bugs

- For some reason I cannot add the feed to Reeder for Mac/Safari.
  It works fine inside Firefox RSS reader, so did I forget some required headers?

## Todo

- [x] dockerize
