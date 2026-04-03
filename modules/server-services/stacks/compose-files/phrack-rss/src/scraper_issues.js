/* eslint-disable no-await-in-loop, no-loop-func, max-len */

const { PHRACK_AUTHOR_URL, PHRACK_ISSUE_ARCHIVE_URL, PHRACK_ISSUE_URL } = require('./config');
const { fetchPage, isInArr, getSlug } = require('./helpers');
const database = require('./database');

const parseIssuesPage = $ => (
  $('a')
    .map((idx, issueLink) => $(issueLink).attr('href')).get()
    .filter(issueLink => /[0-9]/.test(issueLink))
    .map(issueLink => parseInt(issueLink.replace(/\D/g, ''), 10))
    .sort((a, b) => a - b)
);

const parseIssuePage = (issueNumber, $) => (
  $('a')
    .map((idx, articleLink) => $(articleLink).attr('href')).get()
    .filter(articleLink => /[0-9]/.test(articleLink))
    .map(articleLink => articleLink.replace(/\D/g, ''))
    .sort((a, b) => parseInt(a, 10) - parseInt(b, 10))
    .map(articleNumber => ({
      number: parseInt(articleNumber, 10),
      link: `${PHRACK_ISSUE_URL}${issueNumber}/${articleNumber}.html`,
    }))
);

const parseArticlePage = (issueNumber, articleThumb, $) => (
  $('.opt,.opt-bottom')
    .map((idx, el) => $(el).text()).get()
    .reduce((memo, text, idx) => {
      switch (idx) {
        // somehow the below vertical line before Editor is not the one on the keyboard
        case 0: return {
          ...memo,
          date: text.split('Release date : ')[1].split(' | Editor')[0],
        };
        case 1: {
          const title = text.split(' : ')[1];
          return {
            ...memo,
            title,
            titleSlug: getSlug(title),
          };
        }
        case 2: {
          const authorName = text.split(' : ')[1];
          return {
            ...memo,
            authorName,
            authorLink: `${PHRACK_AUTHOR_URL}${encodeURIComponent(authorName)}.html`,
          };
        }
        default: return memo;
      }
    }, {
      link: articleThumb.link,
      type: 'issue',
      articleNumber: parseInt(articleThumb.number, 10),
      issueNumber: parseInt(issueNumber, 10),
    })
);

module.exports = async () => {
  const webIssueNumbers = parseIssuesPage(await fetchPage(PHRACK_ISSUE_ARCHIVE_URL));
  const localIssueNumbers = database.getLocalIssueNumbers();
  const newIssueNumbers = webIssueNumbers.filter(issueNumber => !isInArr(localIssueNumbers, issueNumber));

  const articles = [];

  /* eslint-disable no-restricted-syntax */
  for (const issueNumber of newIssueNumbers) {
    const fetchedIssue = await fetchPage(`${PHRACK_ISSUE_ARCHIVE_URL}${issueNumber}/`);
    const articleThumbs = parseIssuePage(issueNumber, fetchedIssue);

    for (const articleThumb of articleThumbs) {
      const fetchedArticle = await fetchPage(articleThumb.link);
      const articleInfo = parseArticlePage(issueNumber, articleThumb, fetchedArticle);
      console.log('added issue %d, article "%s"', articleInfo.issueNumber, articleInfo.title);
      articles.push(articleInfo);
    }
  }

  /* eslint-enable no-restricted-syntax */

  return articles;
};
