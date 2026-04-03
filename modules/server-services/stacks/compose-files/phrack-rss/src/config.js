const path = require('path');

// settings
exports.PORT = 8099;
exports.RESCAN_INTERVAL = 10 * 1000; // 10 secs
exports.FEED_LENGTH = 20;

// file locations
exports.DATA_DIR = path.join(__dirname, '..', 'data');
exports.DB_FILE = path.join(exports.DATA_DIR, 'data.json');
exports.FEED_ATOM_FILE = path.join(exports.DATA_DIR, 'feed.atom');
exports.FEED_RSS_FILE = path.join(exports.DATA_DIR, 'feed.xml');

// phrack
exports.PHRACK_URL = 'http://www.phrack.org/';
exports.PHRACK_LOGO_URL = `${exports.PHRACK_URL}images/phrack-logo.jpg`;
exports.PHRACK_ISSUE_ARCHIVE_URL = `${exports.PHRACK_URL}archives/issues/`;
exports.PHRACK_ISSUE_URL = `${exports.PHRACK_URL}issues/`;
exports.PHRACK_PAPER_URL = `${exports.PHRACK_URL}papers/`;
exports.PHRACK_AUTHOR_URL = `${exports.PHRACK_URL}author_`;
exports.PHRACK_FIRST_PAPER_URL = `${exports.PHRACK_PAPER_URL}attacking_javascript_engines.html`;
