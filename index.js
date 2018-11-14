const goodreads = require('goodreads');
const parseString = require('xml2js').parseString;

const gr = new goodreads.client({
    'key': 'GbOjze9tMkWgYYTuKHrDtA',
    'secret': 'VUmugs2TnBzxnZqzURRd9rockt6HE5kyO3DgWnzQ'
});
const userID = 88771324;

gr.getSingleShelf({
    'userID': userID,
    'shelf': 'currently-reading',
    'page': 1,
    'per_page': 200
}, res => {
    console.log(res.html.body);
    parseString(res.html, function (err, result) {
        console.dir(result);
    });
});
