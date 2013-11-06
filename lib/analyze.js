var _ = require('underscore');
var fs = require('fs');

var filenames = _.filter(fs.readdirSync('../data/citations'), function(f) {
  return f !== 'parse.js';
});

var unflattenedCitations = _.map(filenames, function(filename) {
  var path = '../data/citations/' + filename;
  var citations = require(path);
  return citations;
});

var citations = _.flatten(unflattenedCitations);

var grouped = _.groupBy(citations, function(citation) {
  return citation['usc']['title'];
});

console.log(grouped["47"]);