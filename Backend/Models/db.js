// Models/db.js
import mysql from 'mysql2/promise';

const db = await mysql.createConnection({
  host: 'localhost',
  user: 'sankha',
  password: 'SANKHADEEp@04', // replace with your actual password if needed
  database: 'ecommerce'
});

console.log('✅ Connected to MySQL with user:', db.config.user);
console.log('✅ Connected to database:', db.config.database);
console.log('✅ On host:', db.config.host);

export default db;
