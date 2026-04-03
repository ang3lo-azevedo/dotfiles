/* eslint-disable no-await-in-loop, no-loop-func, max-len */

const { PHRACK_FIRST_PAPER_URL, PHRACK_PAPER_URL, PHRACK_AUTHOR_URL } = require('./config');
const { fetchPage, isInArr, convertToNumericDate, getSlug } = require('./helpers');
const database = require('./database');

const parsePapersPage = $ => (
  $('a')
    .map((idx, paperEl) => $(paperEl).attr('href')).get()
    .filter(paperLink => /papers/.test(paperLink))
    .filter((paperLink, idx, papers) => papers.indexOf(paperLink) === idx)
    .map(paperLink => paperLink.split('/').pop().split('.')[0])
    .map(paperTitleSlug => ({
      titleSlug: paperTitleSlug,
      link: `${PHRACK_PAPER_URL}${paperTitleSlug}.html`,
    }))
);

const parsePaperPage = (paperThumb, $) => (
  $('.opt,.opt-bottom')
    .map((idx, el) => $(el).text()).get()
    .map(text => text.split(' : ')[1])
    .reduce((memo, text, idx) => {
      switch (idx) {
        case 0: return {
          ...memo,
          title: text,
        };
        case 1: return {
          ...memo,
          authorName: text,
          authorLink: `${PHRACK_AUTHOR_URL}${encodeURIComponent(text)}.html`,
        };
        case 2: return {
          ...memo,
          date: convertToNumericDate(text),
        };
        default: return memo;
      }
    }, {
      link: paperThumb.link,
      titleSlug: paperThumb.titleSlug,
      type: 'paper',
    })
);

module.exports = async () => {
  const parsedPaperThumbs = parsePapersPage(await fetchPage(PHRACK_FIRST_PAPER_URL));
  const localPapersTitleSlug = database.getLocalPapersTitleSlug();
  const newPaperThumbs = parsedPaperThumbs.filter(thumb => !isInArr(localPapersTitleSlug, thumb.titleSlug));
  const papers = [];

  /* eslint-disable no-restricted-syntax */
  for (const paperThumb of newPaperThumbs) {
    const fetchedPaper = await fetchPage(paperThumb.link);
    const paper = parsePaperPage(paperThumb, fetchedPaper);
    console.log('added paper "%s""', paper.title);
    papers.push(paper);
  }

  /* eslint-enable no-restricted-syntax */

  return papers;
};
