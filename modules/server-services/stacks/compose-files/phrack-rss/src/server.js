const compression = require('compression');
const express = require('express');
const { PORT, FEED_RSS_FILE, FEED_ATOM_FILE } = require('./config');

const handleError = (res, err) => console.error(err) || res.send(`Error: ${err.message || err}`);

express()
  .use(compression())
  .get('/feed.atom', (req, res) => {
    res.set('Content-Type', 'application/atom+xml');
    res.sendFile(FEED_ATOM_FILE);
  })
  .get('/feed.xml', (req, res) => {
    res.set('Content-Type', 'application/rss+xml');
    res.sendFile(FEED_RSS_FILE);
  })
  .use((req, res, next) => next(`Page not found ${req.url}`))
  .use((err, req, res) => handleError(res, err))
  .listen(PORT, () => console.log(`server started on: http://localhost:${PORT}`));
