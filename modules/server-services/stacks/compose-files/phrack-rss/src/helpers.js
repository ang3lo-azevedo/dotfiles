const request = require('request-promise-any');
const cheerio = require('cheerio');

exports.convertToNumericDate = (() => {
  const monthMap = {
    January: '01',
    February: '02',
    March: '03',
    April: '04',
    May: '05',
    June: '06',
    July: '07',
    August: '08',
    September: '09',
    October: '10',
    November: '11',
    December: '12',
  };

  return (str) => {
    const [month, day, year] = str.replace(',', '').split(' ');

    return `${year}-${monthMap[month]}-${day}`;
  };
})();

exports.convertToDate = (str) => {
  const [year, month, day] = str.split('-');

  return new Date(year, parseInt(month.replace(/^0/, ''), 10) - 1, day);
};

exports.getSlug = str => str
  .replace(/\W+/g, ' ')
  .replace(/ {2}/g, ' ')
  .replace(/ /g, '_')
  .toLowerCase();

exports.isInArr = (arr, target) => arr.includes(target);

exports.fetchPage = uri => request({ uri, transform: body => cheerio.load(body) });
