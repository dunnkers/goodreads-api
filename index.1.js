const goodreads = require('goodreads-api-node');

const userID = 88771324;
const myCredentials = {
    key: 'GbOjze9tMkWgYYTuKHrDtA',
    secret: 'VUmugs2TnBzxnZqzURRd9rockt6HE5kyO3DgWnzQ'
};

const gr = goodreads(myCredentials);
gr.initOAuth('https://www.periodpoint.nl/');

gr.getRequestToken().then(url => {
    console.log(url);

    return gr.getAccessToken();

}).then((hm) => {
    console.log(hm);
    return gr.getBooksOnUserShelf(userID, 'currently-reading');
}).then(current => {
    console.log(current);
}).catch(err => {
    console.warn(err.message);
});


// gr.getUsersShelves(userID).then(shelves => {

//     shelves.user_shelf.forEach(shelf => {
//         console.log(shelf.name);
//     });
// });
