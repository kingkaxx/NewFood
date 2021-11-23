//this is mongodb connection
var mongo = require('mongodb');
var MongoClient = require('mongodb').MongoClient;
var objectId = require('mongodb').ObjectID;
var url = "mongodb+srv://kaxx:kaxxmongodb@appdata-y3lol.gcp.mongodb.net/test";

MongoClient.connect(url, {
   useUnifiedTopology: true
}, function (err, client) {
   if (err) throw err;
   var collection = client.db("test2").collection("newdevices");
   //var data = {name:"kaxx",email:"kaxx@ScopedCredentialInfo.com"}
   //collection.insertOne(data,function(err,res){
   //if (err) throw err;
})
//client.close();



const express = require('express');
const app = express();
var router = express.Router();
var path = require('path');
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
require('dotenv').config()
var mongoose = require('mongoose');
mongoose.connect('mongodb+srv://kaxx:kaxxmongodb@appdata-y3lol.gcp.mongodb.net/test2')
var Grid = require('gridfs-stream');
const JSON = require('circular-json');
var fs = require('fs');
var conn = mongoose.connection;
var imgPath = path.join(__dirname, '/uploads/food2.png');
const bodyParser = require("body-parser");
/** bodyParser.urlencoded(options)
 * Parses the text as URL encoded data (which is how browsers tend to send form data from regular forms set to POST)
 * and exposes the resulting object (containing the keys and values) on req.body
 */
app.use(bodyParser.urlencoded({
   extended: true
}));

//bodyParser.json(options)
//Parses the text as JSON and exposes the resulting object on req.body.
app.use(bodyParser.json());
//connect gridfs and mongo
Grid.mongo = mongoose.mongo;

app.post('/imgUpload', function () {

   var gfs = Grid(conn.db);
   var writeImg = gfs.createWriteStream({
      filename: 'food.png'
   });
   fs.createReadStream(imgPath).pipe(writeImg);
   writeImg.on('close', function (file) {
      console.log("Written to db");
   })
})


app.post('/download', function (req, res) {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");
      var query = db.filename
      dbo.collection('fs.files').findOne(query, function (err, result) {
         if (err) throw err;
         var json = JSON.stringify(result);
         console.log(json);
         console.log("read from db");
         return (res.send(result));
      });
   });

})

app.post('/getCatList', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");
      var catCollection = req.body.catName;

      dbo.collection(catCollection).find({}).toArray(function (err, result) {
         if (err) throw err;

         var json = JSON.stringify(result);
         console.log(json);
         return (res.json(result));
      });
   });
})

app.post('/getCityList', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");
      var cityCollection = req.body.cityName;

      dbo.collection(cityCollection).find({}).toArray(function (err, result) {
         if (err) throw err;

         var json = JSON.stringify(result);
         console.log(json);
         return (res.json(result));
      });
   });
})
app.post('/cart', (req, res) => {
   MongoClient.connect(url, {
         useUnifiedTopology: true
      },
      function (err, db) {
         if (err) throw err;
         var dbo = db.db("test2");

         var usernameCart = req.body.loggedName

         dbo.collection(usernameCart).insert({
            CartItem: {
               fooditemName: req.body.fooditemName,
               foodQty: req.body.foodQty,
               foodPrice: req.body.foodPrice,
               itemCount: req.body.itemCount,
            }
         }, function (err, res) {
            if (err) throw err;
            console.log("Added")
         })
      });
})

app.post('/emptyCart', (req, res) => {
   MongoClient.connect(url, {
         useUnifiedTopology: true
      },
      function (err, db) {
         if (err) throw err;
         var dbo = db.db("test2");

         var usernameCart = req.body.loggedName

         dbo.createCollection(usernameCart, function (err, result) {
            if (err) throw err;
            console.log("Collection created!");

         });
      });
})

app.post('/nested', (req, res) => {
   MongoClient.connect(url, {
         useUnifiedTopology: true
      },
      function (err, db) {
         if (err) throw err;
         var dbo = db.db("test2");

         var usernameCart = req.body.loggedName

         dbo.collection(usernameCart).insert({
            name: "username",
            city: {
               cityname: "Main"
            }
         }, function (err, res) {
            if (err) throw err;
            console.log("nested done!")
         })
      });
})
app.post('/getNested', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");
      var usernameCart = req.body.loggedName

      dbo.collection('kaustu').find(

         {
            name: {
               $exists: true
            }
         }

      ).toArray(function (err, result) {
         if (err) throw err;
         console.log(result)
         var json = JSON.stringify(result);
         console.log(json);
         return (res.json(result));
      });
   });
})



app.post('/getCart', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");
      var usernameCart = req.body.loggedName

      dbo.collection(usernameCart).find({
         CartItem: {
            $exists: true
         }
      }).toArray(function (err, result) {
         if (err) throw err;

         var json = JSON.stringify(result);
         console.log(json);
         return (res.json(result));
      });
   });
})


app.post('/updateCart', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var fooditemName =
         req.body.fooditemName

      var usernameCart = req.body.loggedName
      //make changes like this in other parts as well
      var dbo = db.db("test2");
      dbo.collection(usernameCart).update({
         "CartItem.fooditemName": fooditemName
      }, {
         $inc: {
            "CartItem.itemCount": 1
         }

      }, function (err, result) {
         if (err) throw err;
         var json = JSON.stringify(result);
         console.log(json);
         return (res.json(result));
      });
   })
})

app.post('/updateNegativeCart', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var fooditemName =
         req.body.fooditemName

      var usernameCart = req.body.loggedName
      var dbo = db.db("test2");
      dbo.collection(usernameCart).update({
         "CartItem.fooditemName": fooditemName
      }, {

         $inc: {
            "CartItem.itemCount": -1
         }
      }, function (err, result) {
         if (err) throw err;
         var json = JSON.stringify(result);
         console.log(json);
         return (res.json(result));
      });
   })
})

app.post('/deleteCartItem', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var fooditemName =
         req.body.fooditemName

      var usernameCart = req.body.loggedName
      var dbo = db.db("test2");
      dbo.collection(usernameCart).deleteOne({
            "CartItem.fooditemName": fooditemName
         },
         function (err, result) {
            if (err) throw err;
            var json = JSON.stringify(result);
            console.log(result);
            return (res.json(result));

         });
   })
})


app.post('/favItem', (req, res) => {
   MongoClient.connect(url, {
         useUnifiedTopology: true
      },
      function (err, db) {
         if (err) throw err;
         var dbo = db.db("test2");

         var usernameCollection = req.body.loggedName;

         dbo.collection(usernameCollection).insert({
            FavItem: {
               foodName: req.body.foodName,
               foodPrice: req.body.foodPrice,
            }
         }, function (err, res) {
            if (err) throw err;
            console.log("Fav item added to list");
         })
      });
})

app.post('/getfavItem', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");
      var usernameCollection = req.body.loggedName;
      dbo.collection(usernameCollection).find({
         FavItem: {
            $exists: true
         }
      }).toArray(function (err, result) {
         if (err) throw err;

         var json = JSON.stringify(result);
         console.log(json);
         return (res.json(result));
      });
   });
})

app.post('/deleteFavItem', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var foodName =
         req.body.foodName

      var usernameCart = req.body.loggedName
      var dbo = db.db("test2");
      dbo.collection(usernameCart).deleteOne({
            "FavItem.foodName": foodName
         },
         function (err, result) {
            if (err) throw err;
            var json = JSON.stringify(result);
            console.log("Removed from fav list");
            return (res.json(result));

         });
   })
})

app.post('/checkFavItem', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");
      var usernameCart = req.body.loggedName
      var foodName =
         req.body.foodName

      dbo.collection(usernameCart).findOne({
         "FavItem.foodName": foodName
      }, function (err, result) {
         if (err) throw err;
         var json = JSON.stringify(result);
         console.log(json);
         return (res.json(result));
      });
   });
})

app.post('/getFamous', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");

      dbo.collection('popularitem').find({}).toArray(function (err, result) {
         if (err) throw err;

         var json = JSON.stringify(result);
         console.log(json);
         return (res.json(result));
      });
   });
})

app.post('/searchItem', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");
      var item = req.body.fooditemName
      //upper and lower case matters RN..... do the changes.
      dbo.collection('test2').find({
         "fooditemName": item,
      }).toArray(
         function (err, result) {
            if (err) throw err;

            var json = JSON.stringify(result);
            console.log(json);
            return (res.json(result));
         });
   });
})

app.post('/userInfo', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");
      var username = req.body.loggedName
      dbo.collection(username).find({
         User: {
            $exists: true
         }
      }).toArray(function (err, result) {
         if (err) throw err;

         var json = JSON.stringify(result);
         console.log(json);
         return (res.json(result));
      });
   });
})

app.post('/addAddress', (req, res) => {
   MongoClient.connect(url, {
      useUnifiedTopology: true
   }, function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");
      var username = req.body.loggedName

      if (dbo.collection(username).insertOne({
            Address: {
               name: req.body.name,
               contactNo: req.body.contactNo,
               pincode: req.body.pincode,
               city: req.body.city,
               state: req.body.state,
               flatNo: req.body.flatNo,
               street: req.body.street,
               landmark: req.body.landmark
            }
         }, function (err, result) {
            if (err) throw err;
            console.log("Address added");
         }));
   })
})
//<------------------------------------------------->
//this is remaining
app.post('/editAddress', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;

      var address = {
         name: req.body.name,
         contactNo: req.body.contactNo,
         pincode: req.body.pincode,
         city: req.body.city,
         state: req.body.state,
         flatNo: req.body.flatNo,
         street: req.body.street,
         landmark: req.body.landmark
      }
      console.log(address)
      //make changes like this in other parts as well
      var dbo = db.db("test2");
      dbo.collection('Address').update({
         address
      }, {
         $set: {
            address
         }
      }, function (err, result) {
         if (err) throw err;
         var json = JSON.stringify(result);
         console.log(json);
         return (res.json(result));
      });
   })
})
//<------------------------------------------------>
app.post('/addressList', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");
      var username = req.body.loggedName
      dbo.collection(username).find({
         Address: {
            $exists: true
         }
      }).toArray(function (err, result) {
         if (err) throw err;

         var json = JSON.stringify(result);
         console.log(json);
         return (res.json(result));
      });
   });
})

app.post('/deleteAddress', (req, res) => {
   MongoClient.connect(url, function (err, db) {
      if (err) throw err;
      var name = req.body.name;
      console.log(name)
      var username = req.body.loggedName
      var dbo = db.db("test2");
      dbo.collection(username).deleteOne({
            "Address.name": name
         },
         function (err, result) {
            if (err) throw err;
            var json = JSON.stringify(result);
            console.log(result);
            return (res.json(result));

         });
   })
})






app.get('/', (req, res) => {
   res.send("Homepage");
});

//register
app.post('/reg', async (req, res) => {
   MongoClient.connect(url, {
      useUnifiedTopology: true
   }, async function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");
      //console.log(await bcrypt.genSalt())
      //fixed salt is 
      const salt = "$2b$10$b.sx25mcBQvZqkUvkdQO1u"
      const hashedPassword = await bcrypt.hash(req.body.password, salt)

      console.log(hashedPassword)

      var username = req.body.username

      dbo.collection(username).insert({
         User: {
            fullname: req.body.fullname,
            username: req.body.username,
            email: req.body.email,
            password: hashedPassword,
            mobile: req.body.MobileNo
         }
      }, function (err, res) {
         if (err) throw err;

      })
      // for future use
      // const accessToken = jwt.sign(dataEntry, process.env.ACCESS_TOKEN_SECRET)
      // res.send({
      //    accessToken: accessToken
      // });
      console.log("user entered");

   });
});

app.post('/checkUser', (req, res) => {
   MongoClient.connect(url, {
      useUnifiedTopology: true
   }, function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");

      dbo.listCollections().toArray(function (err, result) {
         if (err) throw err;
         console.log(res)
         var json = JSON.stringify(result)
         return (res.json(result))


      })
   });
});



//Login
app.post('/login', (req, res) => {

   MongoClient.connect(url, {
      useUnifiedTopology: true
   }, async function (err, db) {
      if (err) throw err;
      var dbo = db.db("test2");
      var username = req.body.username;
      const salt = "$2b$10$b.sx25mcBQvZqkUvkdQO1u"
      const hashedPassword = await bcrypt.hash(req.body.password, salt)
      console.log(hashedPassword)
      dbo.collection(username).find({
         "User.password": hashedPassword
      }).toArray(
         function (err, result) {
            if (err) throw err;
            var json = JSON.stringify(result)
            console.log(json)
            res.json(result)
            // if (await bcrypt.compare(req.body.password, "$2b$10$iFxOPDP/IwKf7hImxlRoQOw0hoH22zcWXwnGW1LhKdxg2sVQ8g7ee")) {
            //    res.json("Successful")
            //    console.log("Done")
            // } else {
            //    res.json(null)
            //    console.log("not done")
            // }
         })
      //for future use
      // const accessToken = jwt.sign(query, process.env.ACCESS_TOKEN_SECRET)
      // res.send({
      //    accessToken: accessToken
      // });
   })
});


app.post('/jwt', authenticateToken, (req, res) => {
   res.send(req.query)
})

app.post('/jwt2', authenticateToken, (req, res) => {
   res.send(req.dataEntry)
})

function authenticateToken(req, res, next) {
   const authHeader = req.headers['authorization']
   const token = authHeader && authHeader.split(' ')[1]
   if (token == null) return res.sendStatus(401)

   jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, query) => {
      if (err) return res.sendStatus(403)
      req.query = query
      next()

   })
}





const server = app.listen(process.env.PORT || 8080, () => {
   const host = server.address().address;
   const port = server.address().port;
   console.log('This works fine!!!! fuck yeahh!! at http://%s:%s', host, port);

})