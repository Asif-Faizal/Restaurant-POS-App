const express = require('express');
const sql = require('mssql/msnodesqlv8');
const app = express();
const port = 3000;
const cors = require('cors');

app.use(cors());
app.use(express.json());

// Database configuration
const config = {
    server: "(local)",
    database: "RestaurantDB",
    driver: "msnodesqlv8",
    options: {
        trustedConnection: false
    },
    user: "RestaurantDB",
    password: "RestaurantDB",
    pool: {
        max: 10, // maximum number of connection pools
        min: 0,  // minimum number of connection pools
        idleTimeoutMillis: 30000 // how long a connection is allowed to be idle before being released
    }
};

// Initialize MSSQL connection pool
const poolPromise = new sql.ConnectionPool(config)
    .connect()
    .then(pool => {
        console.log('Connected to MSSQL database');
        return pool;
    })
    .catch(err => {
        console.error('Database connection failed:', err);
        process.exit(1); // Exit the process if unable to connect to the database
    });

// Login endpoint
app.post('/login', async (req, res) => {
    const { username, password } = req.body;
    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('username', sql.NVarChar, username)
            .input('password', sql.NVarChar, password)
            .query('SELECT * FROM Login WHERE username = @username AND password = @password');
        if (result.recordset.length === 0) {
            res.status(401).send('Invalid username or password');
        } else {
            res.send('Login successful');
        }
    } catch (err) {
        console.error('Error executing login query:', err);
        res.status(500).send('Error executing login query');
    }
});

// Get all categories
app.get('/category', async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query('SELECT * FROM Category');
        res.json(result.recordset);
    } catch (err) {
        console.error('Error getting categories:', err);
        res.status(500).send('Error getting categories');
    }
});

// Add a new category
app.post('/category', async (req, res) => {
    const { pdtfilter, SERorGOODS, image } = req.body;
    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('pdtfilter', sql.NVarChar, pdtfilter)
            .input('SERorGOODS', sql.NVarChar, SERorGOODS)
            .input('image', sql.NVarChar, image)
            .query('INSERT INTO Category (pdtfilter, SERorGOODS, image) VALUES (@pdtfilter, @SERorGOODS, @image)');
        res.send('Category added successfully');
    } catch (err) {
        console.error('Error adding category:', err);
        res.status(500).send('Error adding category');
    }
});

// Update a category
app.put('/category/:id', async (req, res) => {
    const { id } = req.params;
    const { pdtfilter, SERorGOODS, image } = req.body;
    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('id', sql.Int, id)
            .input('pdtfilter', sql.NVarChar, pdtfilter)
            .input('SERorGOODS', sql.NVarChar, SERorGOODS)
            .input('image', sql.NVarChar, image)
            .query('UPDATE Category SET pdtfilter = @pdtfilter, SERorGOODS = @SERorGOODS, image = @image WHERE id = @id');
        res.send('Category updated successfully');
    } catch (err) {
        console.error('Error updating category:', err);
        res.status(500).send('Error updating category');
    }
});

// Delete a category
app.delete('/category/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('id', sql.Int, id)
            .query('DELETE FROM Category WHERE id = @id');
        res.send('Category deleted successfully');
    } catch (err) {
        console.error('Error deleting category:', err);
        res.status(500).send('Error deleting category');
    }
});

//FOOD

app.get('/api/mainstockdupe', async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query('SELECT TOP 10000000 * FROM [dbo].[MainStockDupe]');
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

app.get('/api/mainstockdupe/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('Id', sql.Int, id)
            .query('SELECT * FROM [dbo].[MainStockDupe] WHERE Id = @Id');
        res.json(result.recordset[0]);
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

app.post('/api/mainstockdupe', async (req, res) => {
    const { codeorSKU, category, pdtname, puramntwithtax, saleamnt, tax, totalstock, Date, SERorGOODS, itemMRP, image } = req.body;
    try {
        const pool = await poolPromise;
        await pool.request()
            .input('codeorSKU', sql.NVarChar, codeorSKU)
            .input('category', sql.NVarChar, category)
            .input('pdtname', sql.NVarChar, pdtname)
            .input('puramntwithtax', sql.Decimal, puramntwithtax)
            .input('saleamnt', sql.Decimal, saleamnt)
            .input('tax', sql.Decimal, tax)
            .input('totalstock', sql.Int, totalstock)
            .input('Date', sql.DateTime, Date)
            .input('SERorGOODS', sql.NVarChar, SERorGOODS)
            .input('image', sql.NVarChar, image)
            .input('itemMRP', sql.Decimal, itemMRP)
            .query(`INSERT INTO [dbo].[MainStockDupe] (codeorSKU, category, pdtname, puramntwithtax, saleamnt, tax, totalstock, Date, SERorGOODS, itemMRP, image)
                    VALUES (@codeorSKU, @category, @pdtname, @puramntwithtax, @saleamnt, @tax, @totalstock, @Date, @SERorGOODS, @itemMRP, @image)`);
        res.status(201).send({ message: 'Record added successfully' });
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

app.put('/api/mainstockdupe/:id', async (req, res) => {
    const { id } = req.params;
    const { codeorSKU, category, pdtname, puramntwithtax, saleamnt, tax, totalstock, Date, SERorGOODS, itemMRP, image } = req.body;
    try {
        const pool = await poolPromise;
        await pool.request()
            .input('Id', sql.Int, id)
            .input('codeorSKU', sql.NVarChar, codeorSKU)
            .input('category', sql.NVarChar, category)
            .input('pdtname', sql.NVarChar, pdtname)
            .input('puramntwithtax', sql.Decimal, puramntwithtax)
            .input('saleamnt', sql.Decimal, saleamnt)
            .input('tax', sql.Decimal, tax)
            .input('totalstock', sql.Int, totalstock)
            .input('Date', sql.DateTime, Date)
            .input('SERorGOODS', sql.NVarChar, SERorGOODS)
            .input('itemMRP', sql.Decimal, itemMRP)
            .input('image', sql.NVarChar, image)
            .query(`UPDATE [dbo].[MainStockDupe]
                    SET codeorSKU = @codeorSKU, category = @category, pdtname = @pdtname, puramntwithtax = @puramntwithtax, saleamnt = @saleamnt, tax = @tax, totalstock = @totalstock, Date = @Date, SERorGOODS = @SERorGOODS, itemMRP = @itemMRP, image = @image
                    WHERE Id = @Id`);
        res.send({ message: 'Record updated successfully' });
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

app.delete('/api/mainstockdupe/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const pool = await poolPromise;
        await pool.request()
            .input('Id', sql.Int, id)
            .query('DELETE FROM [dbo].[MainStockDupe] WHERE Id = @Id');
        res.send({ message: 'Record deleted successfully' });
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

// Get item by name endpoint
app.get('/api/mainstockdupe/name/:name', async (req, res) => {
    const { name } = req.params;
    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('name', sql.NVarChar, name)
            .query('SELECT * FROM [dbo].[MainStockDupe] WHERE pdtname = @name');

        if (result.recordset.length === 0) {
            res.status(404).send({ message: 'Item not found' });
        } else {
            res.json(result.recordset);
        }
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});


// Get item by Category endpoint
app.get('/api/mainstockdupe/category/:category', async (req, res) => {
    const { category } = req.params;
    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('category', sql.NVarChar, category)
            .query('SELECT * FROM [dbo].[MainStockDupe] WHERE category = @category');

        if (result.recordset.length === 0) {
            res.status(404).send({ message: 'Item not found' });
        } else {
            res.json(result.recordset);
        }
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

// Add a new item to OrderItemDetailsDetails table
const crypto = require('crypto');
function generateShortId(length) {
    return crypto.randomBytes(length).toString('base64').replace(/[^A-Z0-9]/g, '').substring(0, length);
}

app.post('/api/order-details', async (req, res) => {
    const {
        UserId, UserName, CustomerId, CustomerName, TableName,
        StartDateTime, ItemCode, ItemName, salePrice, Qty, TotalsalePrice,
        GST, GSTAmount, inclusiceSaleprice, ActiveInnactive
    } = req.body;

    let OrderNumber;
    let KOTNo;

    try {
        const pool = await poolPromise;

        // Check if an order with the same CustomerName already exists
        const existingOrder = await pool.request()
            .input('CustomerName', sql.NVarChar, CustomerName)
            .query('SELECT TOP 1 OrderNumber, KOTNo FROM [RestaurantDB].[dbo].[OrderItemDetailsDetails] WHERE CustomerName = @CustomerName');
        if (existingOrder.recordset.length > 0) {
            // Use existing OrderNumber and KOTNo
            OrderNumber = existingOrder.recordset[0].OrderNumber;
            KOTNo = existingOrder.recordset[0].KOTNo;
        } else {
            // Generate new OrderNumber and KOTNo
            const shortId = generateShortId(3); // Generate a 6-character unique identifier
            OrderNumber = `ORD${shortId}`;
            KOTNo = `KOT${shortId}`;
        }

        await pool.request()
            .input('OrderNumber', sql.NVarChar, OrderNumber)
            .input('UserId', sql.Int, UserId)
            .input('UserName', sql.NVarChar, UserName)
            .input('CustomerId', sql.Int, CustomerId)
            .input('CustomerName', sql.NVarChar, CustomerName)
            .input('TableName', sql.NVarChar, TableName)
            .input('StartDateTime', sql.DateTime, StartDateTime)
            .input('ItemCode', sql.NVarChar, ItemCode)
            .input('ItemName', sql.NVarChar, ItemName)
            .input('salePrice', sql.Decimal, salePrice)
            .input('Qty', sql.Int, Qty)
            .input('TotalsalePrice', sql.Decimal, TotalsalePrice)
            .input('GST', sql.Decimal, GST)
            .input('GSTAmount', sql.Decimal, GSTAmount)
            .input('inclusiceSaleprice', sql.Decimal, inclusiceSaleprice)
            .input('ActiveInnactive', sql.NVarChar, ActiveInnactive)
            .input('KOTNo', sql.NVarChar, KOTNo)
            .query(`INSERT INTO [RestaurantDB].[dbo].[OrderItemDetailsDetails]
                    (OrderNumber, UserId, UserName, CustomerId, CustomerName, TableName, StartDateTime, ItemCode, ItemName, salePrice, Qty, TotalsalePrice, GST, GSTAmount, inclusiceSaleprice, ActiveInnactive, KOTNo)
                    VALUES (@OrderNumber, @UserId, @UserName, @CustomerId, @CustomerName, @TableName, @StartDateTime, @ItemCode, @ItemName, @salePrice, @Qty, @TotalsalePrice, @GST, @GSTAmount, @inclusiceSaleprice, @ActiveInnactive, @KOTNo)`);

        res.status(201).send({ message: 'Record added successfully', OrderNumber, KOTNo });
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

// Get an item from OrderItemDetailsDetails table by OrderNumber
app.get('/api/order-details/:orderNumber', async (req, res) => {
    const { orderNumber } = req.params;

    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('OrderNumber', sql.NVarChar, orderNumber)
            .query('SELECT * FROM [RestaurantDB].[dbo].[OrderItemDetailsDetails] WHERE OrderNumber = @OrderNumber');

        if (result.recordset.length > 0) {
            res.status(200).send(result.recordset);
        } else {
            res.status(404).send({ message: 'Record not found' });
        }
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

// Update ActiveInnactive status to 'Innactive' for a given OrderNumber
app.put('/api/order-details/:orderNumber', async (req, res) => {
    const { orderNumber } = req.params;

    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('OrderNumber', sql.NVarChar, orderNumber)
            .query('UPDATE [RestaurantDB].[dbo].[OrderItemDetailsDetails] SET ActiveInnactive = \'Innactive\' WHERE OrderNumber = @OrderNumber AND ActiveInnactive = \'Active\'');

        if (result.rowsAffected[0] > 0) {
            res.status(200).send({ message: 'Status updated to Innactive successfully' });
        } else {
            res.status(404).send({ message: 'No active records found with the specified OrderNumber' });
        }
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

// Get all active orders
app.get('/api/order-item/active', async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .query('SELECT * FROM [RestaurantDB].[dbo].[OrderItemDetailsDetails] WHERE ActiveInnactive = \'Active\'');

        if (result.recordset.length > 0) {
            res.status(200).send(result.recordset);
        } else {
            res.status(404).send({ message: 'No active records found' });
        }
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

// Get all inactive orders
app.get('/api/order-item/inactive', async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .query('SELECT * FROM [RestaurantDB].[dbo].[OrderItemDetailsDetails] WHERE ActiveInnactive = \'Innactive\'');

        if (result.recordset.length > 0) {
            res.status(200).send(result.recordset);
        } else {
            res.status(404).send({ message: 'No inactive records found' });
        }
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

// Delete an item from OrderItemDetailsDetails table by OrderNumber
app.delete('/api/order-details/:orderNumber', async (req, res) => {
    const { orderNumber } = req.params;

    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('OrderNumber', sql.NVarChar, orderNumber)
            .query('DELETE FROM [RestaurantDB].[dbo].[OrderItemDetailsDetails] WHERE OrderNumber = @OrderNumber');

        if (result.rowsAffected[0] > 0) {
            res.status(200).send({ message: 'Record deleted successfully' });
        } else {
            res.status(404).send({ message: 'Record not found' });
        }
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

// Generate unique BillNumber function
async function generateBillNumber() {
    try {
        const pool = await poolPromise;
        // Query to get the latest BillNumber and generate a new one
        const result = await pool.request()
            .query('SELECT TOP 1 BillNumber FROM OrderMainDetails ORDER BY Id DESC');
        let lastBillNumber = result.recordset.length > 0 ? result.recordset[0].BillNumber : 'INV0';
        let lastNumber = parseInt(lastBillNumber.substr(3)); // Extract numeric part and convert to integer
        let newBillNumber = `INV${lastNumber + 1}`;

        return newBillNumber;
    } catch (err) {
        console.error('Error generating BillNumber:', err);
        throw err;
    }
}

// Add Order endpoint
app.post('/api/orders', async (req, res) => {
    const {
        OrderNumber, UserId, UserName, CustomerId, CustomerName,
        TableName, TaxableAmount, TotalAmount, ActiveInnactive, CreditOrPaid
    } = req.body;

    try {
        const pool = await poolPromise;
        // Generate unique BillNumber
        const BillNumber = await generateBillNumber();

        // Set EntryDate as current datetime
        const EntryDate = new Date();

        // Insert into database
        await pool.request()
            .input('OrderNumber', sql.NVarChar, OrderNumber)
            .input('EntryDate', sql.DateTime, EntryDate)
            .input('UserId', sql.Int, UserId)
            .input('UserName', sql.NVarChar, UserName)
            .input('CustomerId', sql.Int, CustomerId)
            .input('CustomerName', sql.NVarChar, CustomerName)
            .input('TableName', sql.NVarChar, TableName)
            .input('TaxableAmount', sql.Decimal, TaxableAmount)
            .input('TotalAmount', sql.Decimal, TotalAmount)
            .input('ActiveInnactive', sql.NVarChar, ActiveInnactive)
            .input('CreditOrPaid', sql.NVarChar, CreditOrPaid)
            .input('BillNumber', sql.NVarChar, BillNumber)
            .query(`INSERT INTO OrderMainDetails (OrderNumber, EntryDate, UserId, UserName, CustomerId, CustomerName, TableName, TaxableAmount, TotalAmount, ActiveInnactive, CreditOrPaid, BillNumber)
                    VALUES (@OrderNumber, @EntryDate, @UserId, @UserName, @CustomerId, @CustomerName, @TableName, @TaxableAmount, @TotalAmount, @ActiveInnactive, @CreditOrPaid, @BillNumber)`);

        res.status(201).json({
            message: 'Order added successfully',
            BillNumber: BillNumber
        });
    } catch (err) {
        console.error('Error adding order:', err);
        res.status(500).send('Internal server error');
    }
});

// Update ActiveInnactive status to 'Inactive' for a given OrderNumber
app.put('/api/orders/:orderNumber', async (req, res) => {
    const { orderNumber } = req.params;

    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('OrderNumber', sql.NVarChar, orderNumber)
            .query('UPDATE OrderMainDetails SET ActiveInnactive = \'Inactive\' WHERE OrderNumber = @OrderNumber AND ActiveInnactive = \'Active\'');

        if (result.rowsAffected[0] > 0) {
            res.status(200).send({ message: 'Status updated to Inactive successfully' });
        } else {
            res.status(404).send({ message: 'No active records found with the specified OrderNumber' });
        }
    } catch (err) {
        console.error('Error updating order status:', err);
        res.status(500).send('Internal server error');
    }
});

// Get all active orders
app.get('/api/orders/active', async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .query('SELECT * FROM OrderMainDetails WHERE ActiveInnactive = \'Active\'');

        if (result.recordset.length > 0) {
            res.status(200).send(result.recordset);
        } else {
            res.status(404).send({ message: 'No active orders found' });
        }
    } catch (err) {
        console.error('Error fetching active orders:', err);
        res.status(500).send('Internal server error');
    }
});

// Get all inactive orders
app.get('/api/orders/inactive', async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .query('SELECT * FROM OrderMainDetails WHERE ActiveInnactive = \'Inactive\'');

        if (result.recordset.length > 0) {
            res.status(200).send(result.recordset);
        } else {
            res.status(404).send({ message: 'No inactive orders found' });
        }
    } catch (err) {
        console.error('Error fetching inactive orders:', err);
        res.status(500).send('Internal server error');
    }
});

// Print KOT API endpoint
app.post('/print-kot', async (req, res) => {
    try {
        const { KOTNo } = req.body;
        const KOTDate = new Date();

        if (!KOTNo) {
            return res.status(400).send('KOTNo is required');
        }

        const pool = await poolPromise; // Get the connection pool
        const request = pool.request(); // Use the pool's request object
        const query = `INSERT INTO [dbo].[KOTNo] (KOTNo, KOTDate) VALUES (@KOTNo, @KOTDate)`;

        request.input('KOTNo', sql.VarChar, KOTNo);
        request.input('KOTDate', sql.DateTime, KOTDate);

        await request.query(query);

        res.status(201).send({
            message: 'KOT added successfully',
            data: {
                KOTNo,
                KOTDate
            }
        });
    } catch (err) {
        console.error('Error adding KOT:', err);
        res.status(500).send('Internal server error');
    }
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
