/* eslint-disable no-unused-expressions */
const { DB_FILE, FEED_LENGTH } = require('./config');
const { existsSync, readFileSync, writeFileSync, writeFile } = require('./filesystem');

!existsSync(DB_FILE) && writeFileSync(DB_FILE, '[]'); // create data file if none exists
const data = JSON.parse(readFileSync(DB_FILE)); // always returns an array

exports.getLocalIssueNumbers = () => (
  data
    .filter(item => item.type === 'issue')
    .map(item => item.issueNumber)
    .filter((item, idx, items) => items.indexOf(item) === idx)
    .sort((a, b) => parseInt(a, 10) - parseInt(b, 10))
);

exports.getLocalPapersTitleSlug = () => (
  data
    .filter(item => item.type === 'paper')
    .map(item => item.titleSlug)
);

exports.getNewestItems = () => data.slice(-FEED_LENGTH).reverse();

exports.addItems = async (items) => {
  if (!items.length) {
    return false;
  }

  data.push(...items);

  data.sort((a, b) => {
    if (a.date < b.date) {
      return -1;
    } else if (a.date > b.date) {
      return 1;
    }

    // date is the same

    if (a.type === 'issue' && b.type === 'paper') {
      return -1;
    } else if (a.type === 'paper' && b.type === 'issue') {
      return 1;
    }

    // both items are paper or issue

    // multiple PAPERS can never be from the same day so they both need to be ISSUE

    if (a.issueNumber < b.issueNumber) {
      return -1;
    } else if (a.issueNumber > b.issueNumber) {
      return 1;
    }

    // the same issue

    if (a.articleNumber < b.articleNumber) {
      return -1;
    } else if (a.articleNumber > b.articleNumber) {
      return 1;
    }

    return 0;
  });

  await writeFile(DB_FILE, JSON.stringify(data, null, 4));

  return true;
};
