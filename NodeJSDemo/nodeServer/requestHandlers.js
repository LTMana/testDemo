//好用的非阻塞操作
var exec = require('child_process').exec;
var querystring = require('querystring');
var formidable = require('formidable');

var fs = require('fs');

function start(res){

console.log("Request handler 'start' was called.");

//js没有sleep需自己添加
// function sleep(milliSeconds){
// 	var startTime = new Date().getTime();
// 	while (new Date().getTime() < startTime + milliSeconds);

// }

// sleep(10000);
//return "hello start";

/**
经典的异步错误
var content = "empty";
exec("find /", function(error,stdout,atderr){
	content = stdout;
})
return content;
*/

 // var body = '<html>'+
 //    '<head>'+
 //    '<meta http-equiv="Content-Type" content="text/html; '+
 //    'charset=UTF-8" />'+
 //    '</head>'+
 //    '<body>'+
 //    '<form action="/upload" method="post">'+
 //    '<textarea name="text" rows="20" cols="60"></textarea>'+
 //    '<input type="submit" value="Submit text" />'+
 //    '</form>'+
 //    '</body>'+
 //    '</html>';

   var body = '<html>'+
    '<head>'+
    '<meta http-equiv="Content-Type" content="text/html; '+
    'charset=UTF-8" />'+
    '</head>'+
    '<body>'+
    '<form action="/upload" enctype="multipart/form-data" '+
    'method="post">'+
    '<input type="file" name="upload" multiple="multiple">'+
    '<input type="submit" value="Upload file" />'+
    '</form>'+
    '</body>'+
    '</html>';




//exec("find /" , function(err,stdout,stderr){

  res.writeHead(200 ,{"Content-Type" : "text/html"});
  res.write(body);
  res.end();
 //});



}


function upload(res,req){
 console.log("Request handler 'upload' was called.");
 

var form = new formidable.IncomingForm();
console.log("about to parse");
form.parse(req,function(err,fields,files){
console.log("parse done");

 
 console.log(files.upload.path);
 
fs.renameSync(files.upload.path,"/tmp/test.png");

 res.writeHead(200 ,{"Content-Type" : "text/html"});
  //res.write("you've sent:" + querystring.parse(postData).text);
  res.write("received image:<br/>");
    res.write("<img src='/show' />");
  res.end();


});




 
 
}


function show(res){
 console.log("Request handler 'show' was called.");
 
fs.readFile('/tmp/test.png','binary',function(err,file){
if (err) {
	  res.writeHead(500, {"Content-Type": "text/plain"});
      res.write(err + "\n");
      res.end();

}else{
	 res.writeHead(200, {"Content-Type": "image/png"});
	 res.write(file , 'binary');
	 res.end();


}



});

  
 
}


exports.start = start;
exports.upload = upload;
exports.show = show;