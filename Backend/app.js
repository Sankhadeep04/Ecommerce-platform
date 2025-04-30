  import express from 'express';
  import mysql from 'mysql2';  // Import mysql2 package
  import bodyParser from 'body-parser';  // Express built-in JSON parser

  import authRoutes from './Routes/authRoutes.js';
  import farmerRoutes from './Routes/farmerRoutes.js';
  import consumerRoutes from './Routes/consumerRoutes.js';
  import orderRoutes from './Routes/orderRoutes.js';

  import dotenv from 'dotenv';
  dotenv.config();

  const app = express();

  // Middleware for JSON parsing
  app.use(express.json());  // Replaces body-parser.json()

  // MySQL Database connection
  const db = mysql.createConnection({
    host: 'localhost',
    user: 'sankha',  // Replace with your MySQL username
    password: 'SANKHADEEp@04',  // Replace with your MySQL password
    database: 'ecommerce'  // Replace with your MySQL database name
  });

  db.connect((err) => {
    if (err) {
      console.error('Database connection failed:', err);
    } else {
      console.log('Connected to MySQL database');
    }
  });

  // Routes
  app.use('/api', authRoutes);

  
  app.use('/api', farmerRoutes);
  app.use('/api', consumerRoutes);
  app.use('/api', orderRoutes);

  const PORT = 3000;
  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });

