var http = require('http');
var url = require('url');


function start (route , handle){

http.createServer(function(req,res){

//var postData = '';

var pathname  = url.parse(req.url).pathname;

//req.setEncoding('utf8');

// req.addListener('data',function(postDataChunk){

//  postData += postDataChunk;
//  console.log("Received POST data chunk '"+
//       postDataChunk + "'.");
 
// });

//req.addListener('end',function(){

	route(handle,pathname,res,req);

//});

console.log('Request for' +pathname + 'received');

 

}).listen(1737);
console.log('server has starts');

}



exports.start = start;