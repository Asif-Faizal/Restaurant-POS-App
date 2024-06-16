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


// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
