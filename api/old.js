// const express = require('express');
// const sql = require('mssql/msnodesqlv8');
// const bcrypt = require('bcrypt');
// const app = express();
// const port = 3000;
// const cors = require('cors');

// app.use(cors());
// app.use(express.json());

// var config = {
//     server: "MSI\\SQLEXPRESS",
//     database: "food",
//     driver: "msnodesqlv8",
//     options: {
//         trustedConnection: true
//     }
// };

// sql.connect(config, function (err) {
//     if (err) {
//         console.log(err);
//         return;
//     }
//     app.get('/category', (req, res) => {
//         var request = new sql.Request();
//         request.query("SELECT * FROM caterogries", function (err, records) {
//             if (err) {
//                 console.log(err);
//                 res.status(500).send('Error executing query');
//             } else {
//                 res.json(records.recordset);
//             }
//         });
//     });

//     // ADD CATEGORY
//     app.post('/category-add', (req, res) => {
//         const { id, name, image } = req.body;
//         if (!id || !name || !image) {
//             return res.status(400).send('Missing required fields');
//         }
//         var request = new sql.Request();
//         const query = `INSERT INTO caterogries (id, name, image) VALUES (@id, @name, @image)`;
//         request.input('id', sql.Int, id);
//         request.input('name', sql.NVarChar, name);
//         request.input('image', sql.NVarChar, image);
//         request.query(query, function (err) {
//             if (err) {
//                 console.log(err);
//                 res.status(500).send('Error executing query');
//             } else {
//                 res.status(201).send('Category added successfully');
//             }
//         });
//     });

//     //SEARCH FOR CATEGORY
//     app.post('/category-query', (req, res) => {
//         const { id } = req.body;
//         if (!id) {
//             return res.status(400).send('Missing ID field');
//         }
//         var request = new sql.Request();
//         const query = `SELECT * FROM caterogries WHERE id = @id`;
//         request.input('id', sql.Int, id);
//         request.query(query, function (err, records) {
//             if (err) {
//                 console.log(err);
//                 res.status(500).send('Error executing query');
//             }else {
//                 res.json(records.recordset[0]);
//             }
//         });
//     });

//     //FETCH ALL FOODS
//     app.get('/foods', (req, res) => {
//         var request = new sql.Request();
//         request.query("SELECT * FROM foods", function (err, records) {
//             if (err) {
//                 console.log(err);
//                 res.status(500).send('Error executing query');
//             } else {
//                 res.json(records.recordset);
//             }
//         });
//     });

//     // ADD FOODS
//     app.post('/foods-add', (req, res) => {
//         const { id, name, image, price, extraslist, categoryid } = req.body;
//         if (!id || !name || !image || !price || !extraslist || !categoryid) {
//             return res.status(400).send('Missing required fields');
//         }
//         var request = new sql.Request();
//         const query = `INSERT INTO foods (id, name, image, price, extraslist, categoryid) VALUES (@id, @name, @image, @price, @extraslist, @categoryid)`;
//         request.input('id', sql.Int, id);
//         request.input('name', sql.NVarChar, name);
//         request.input('image', sql.NVarChar, image);
//         request.input('price', sql.Int, price);
//         request.input('extraslist', sql.NVarChar, extraslist);
//         request.input('categoryid', sql.Int, categoryid);
//         request.query(query, function (err) {
//             if (err) {
//                 console.log(err);
//                 res.status(500).send('Error executing query');
//             } else {
//                 res.status(201).send('Food added successfully');
//             }
//         });
//     });

//     //SEARCH FOODS BY ID, NAME, CATEGORY
//     app.post('/foods-query', (req, res) => {
//         const { id, name, categoryid } = req.body;
//         var request = new sql.Request();
//         var query = `SELECT * FROM foods WHERE 1=1`;
//         if (id) {
//             query += ` AND id = @id`;
//             request.input('id', sql.Int, id);
//         }
//         if (name) {
//             query += ` AND name = @name`;
//             request.input('name', sql.NVarChar, name);
//         }
//         if (categoryid) {
//             query += ` AND categoryid = @categoryid`;
//             request.input('categoryid', sql.Int, categoryid);
//         }
//         request.query(query, function (err, records) {
//             if (err) {
//                 console.log(err);
//                 res.status(500).send('Error executing query');
//             } else {
//                 res.json(records.recordset);
//             }
//         });
//     });

//     //FETCH ALL Extras
//     app.get('/extras', (req, res) => {
//         var request = new sql.Request();
//         request.query("SELECT * FROM extras", function (err, records) {
//             if (err) {
//                 console.log(err);
//                 res.status(500).send('Error executing query');
//             } else {
//                 res.json(records.recordset);
//             }
//         });
//     });

//     //FETCH EXTRAS BY FOOD ID
//     app.post('/extras-query', (req, res) => {
//         const { foodid } = req.body;
//         if (!foodid) {
//             return res.status(400).send('Missing required field: foodid');
//         }
//         var request = new sql.Request();
//         const query = `SELECT * FROM extras WHERE foodid = @foodid`;
//         request.input('foodid', sql.Int, foodid);
//         request.query(query, function (err, records) {
//             if (err) {
//                 console.log(err);
//                 res.status(500).send('Error executing query');
//             } else {
//                 res.json(records.recordset);
//             }
//         });
//     });

//     // Add order item
//     app.post('/cart-add', (req, res) => {
//         const { order_id, food_id, food_name, food_image, food_price, quantity, extras_name, extras_price, table_id, sub_total } = req.body;
//         if (!order_id || !food_id || !food_name || !food_image || !food_price || !quantity || !table_id || !sub_total) {
//             return res.status(400).send('Missing required fields');
//         }
//         var request = new sql.Request();
//         const query = `INSERT INTO orderitems (order_id, food_id, food_name, food_image, food_price, quantity, extras_name, extras_price, table_id, sub_total) VALUES (@order_id, @food_id, @food_name, @food_image, @food_price, @quantity, @extras_name, @extras_price, @table_id, @sub_total)`;
//         request.input('order_id', sql.Int, order_id);
//         request.input('food_id', sql.Int, food_id);
//         request.input('food_name', sql.NVarChar, food_name);
//         request.input('food_image', sql.NVarChar, food_image);
//         request.input('food_price', sql.Int, food_price);
//         request.input('quantity', sql.Int, quantity);
//         request.input('extras_name', sql.NVarChar, extras_name);
//         request.input('extras_price', sql.Int, extras_price);
//         request.input('table_id', sql.Int, table_id);
//         request.input('sub_total', sql.Int, sub_total);
//         request.query(query, function (err) {
//             if (err) {
//                 console.log(err);
//                 res.status(500).send('Error executing query');
//             } else {
//                 res.status(201).send('Item added to cart successfully');
//             }
//         });
//     });

//     // View all order items
//     app.get('/cart/:table_id', (req, res) => {
//         const { table_id } = req.params;
//         var request = new sql.Request();
//         const query = `SELECT * FROM orderitems WHERE table_id = @table_id`;
//         request.input('table_id', sql.Int, table_id);
//         request.query(query, function (err, records) {
//             if (err) {
//                 console.log(err);
//                 res.status(500).send('Error executing query');
//             } else {
//                 res.json(records.recordset);
//             }
//         });
//     });

//     // Remove specific orderitem
//     app.delete('/cart-remove/:table_id/:food_id/:extras_name', (req, res) => {
//         const { food_id, extras_name , table_id} = req.params;
//         var request = new sql.Request();
//         const query = `DELETE FROM orderitems WHERE table_id = @table_id AND food_id = @food_id AND extras_name = @extras_name`;
//         request.input('table_id', sql.Int, table_id);
//         request.input('food_id', sql.Int, food_id);
//         request.input('extras_name', sql.NVarChar, extras_name);
//         request.query(query, function (err) {
//         if (err) {
//             console.log(err);
//             res.status(500).send('Error executing query');
//         } else {
//             res.status(200).send('Item removed from cart successfully');
//         }
//         });
//     });

//     // PLACE ORDER
//     app.post('/place-order', (req, res) => {
//     const { table_id, customer_name, customer_number, total_amount, is_delivered } = req.body;
//     if (!table_id || !customer_name || !customer_number || !total_amount || is_delivered === undefined) {
//         return res.status(400).send('Missing required fields');
//     }
//     var request = new sql.Request();
//     const query = `INSERT INTO allorder (table_id, customer_name, customer_number, total_amount, is_delivered) VALUES (@table_id, @customer_name, @customer_number, @total_amount, @is_delivered)`;
//     request.input('table_id', sql.Int, table_id);
//     request.input('customer_name', sql.NVarChar, customer_name);
//     request.input('customer_number', sql.NVarChar, customer_number);
//     request.input('total_amount', sql.Decimal, total_amount);
//     request.input('is_delivered', sql.Bit, is_delivered);
//     request.query(query, function (err) {
//         if (err) {
//             console.log(err);
//             res.status(500).send('Error executing query');
//         } else {
//             res.status(201).send('Order placed successfully');
//         }
//     });
// });

// // MARK ORDER AS DELIVERED
// app.put('/mark-delivered/:order_id', (req, res) => {
//     const { order_id } = req.params;
//     if (!order_id) {
//         return res.status(400).send('Missing required field: order_id');
//     }
//     var request = new sql.Request();
//     const query = `UPDATE allorder SET is_delivered = 1 WHERE order_id = @order_id`;
//     request.input('order_id', sql.Int, order_id);
//     request.query(query, function (err) {
//         if (err) {
//             console.log(err);
//             res.status(500).send('Error executing query');
//         } else {
//             res.status(200).send('Order marked as delivered successfully');
//         }
//     });
// });
// //undo marked delivered
// app.put('/ummark-delivered/:order_id', (req, res) => {
//     const { order_id } = req.params;
//     if (!order_id) {
//         return res.status(400).send('Missing required field: order_id');
//     }
//     var request = new sql.Request();
//     const query = `UPDATE allorder SET is_delivered = 0 WHERE order_id = @order_id`;
//     request.input('order_id', sql.Int, order_id);
//     request.query(query, function (err) {
//         if (err) {
//             console.log(err);
//             res.status(500).send('Error executing query');
//         } else {
//             res.status(200).send('Order marked as delivered successfully');
//         }
//     });
// });
// // DELETE ORDER
// app.delete('/delete-order/:order_id', (req, res) => {
//     const { order_id } = req.params;
//     if (!order_id) {
//         return res.status(400).send('Missing required field: order_id');
//     }
//     var request = new sql.Request();
//     const query = `DELETE FROM allorder WHERE order_id = @order_id`;
//     request.input('order_id', sql.Int, order_id);
//     request.query(query, function (err) {
//         if (err) {
//             console.log(err);
//             res.status(500).send('Error executing query');
//         } else {
//             res.status(200).send('Order deleted successfully');
//         }
//     });
// });

// // FETCH ALL ORDERS BASED ON DELIVERY STATUS
// app.get('/orders', (req, res) => {
//     const { is_delivered } = req.query;
//     if (is_delivered === undefined || (is_delivered !== '0' && is_delivered !== '1')) {
//         return res.status(400).send('Invalid value for is_delivered');
//     }
//     var request = new sql.Request();
//     const query = `
//         SELECT *
//         FROM allorder
//         WHERE is_delivered = @is_delivered
//     `;
//     request.input('is_delivered', sql.Bit, parseInt(is_delivered));
//     request.query(query, function (err, records) {
//         if (err) {
//             console.log(err);
//             res.status(500).send('Error executing query');
//         } else {
//             res.json(records.recordset);
//         }
//     });
// });

// //FETCH IMAGES
// app.get('/images/:table_id', (req, res) => {
//     const { table_id } = req.params;
//     var request = new sql.Request();
//     const query = `
//         SELECT oi.food_image
//         FROM orderitems oi
//         INNER JOIN foods f ON oi.food_id = f.id
//         WHERE oi.table_id = @table_id
//     `;
//     request.input('table_id', sql.Int, table_id);
//     request.query(query, function (err, records) {
//         if (err) {
//             console.log(err);
//             res.status(500).send('Error executing query');
//         } else {
//             const foodImages = records.recordset.map(record => record.food_image);
//             res.json(foodImages);
//         }
//     });
// });
//     //PASSCODE
//     // SET PASSCODE

//     app.post('/set-passcode', (req, res) => {
//         const { id, passcode } = req.body;
//         if (!id || !passcode) {
//             return res.status(400).send('Missing required fields');
//         }
//         var request = new sql.Request();
//         const query = `INSERT INTO users (id, passcode) VALUES (@id, @passcode)`;
//         request.input('id', sql.Int, id);
//         request.input('passcode', sql.NVarChar, passcode);
//         request.query(query, function (err) {
//             if (err) {
//                 console.log(err);
//                 res.status(500).send('Error executing query');
//             } else {
//                 res.status(201).send('User added successfully');
//             }
//         });
//     });

//     //AUTHENTICATE WITH PASSCODE
//     app.post('/authenticate', (req, res) => {
//         const { id, passcode } = req.body;
//         if (!id || !passcode) {
//             return res.status(400).json({ message: 'Missing required fields' });
//         }
//         var request = new sql.Request();
//         const query = `SELECT * FROM users WHERE id = @id`;
//         request.input('id', sql.Int, id);
//         request.query(query, function (err, records) {
//             if (err) {
//                 console.log(err);
//                 res.status(500).json({ message: 'Error executing query' });
//             } else if (records.recordset.length === 0) {
//                 res.status(404).json({ message: 'User not found' });
//             } else {
//                 const user = records.recordset[0];
//                 if (user.passcode === passcode) {
//                     res.status(200).json({ authenticated: true });
//                 } else {
//                     res.status(401).json({ authenticated: false, message: 'Incorrect passcode' });
//                 }
//             }
//         });
//     });

//     app.listen(port, () => {
//         console.log(`Server is running on http://localhost:${port}`);
//     });
// });