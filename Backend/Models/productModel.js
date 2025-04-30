// import db from './db.js'; // Import the database connection

// // Create the product model functions
// const createProduct = (name, description, category, price, quantity, image_url, farmer_id) => {
//   const query = `
//     INSERT INTO products (name, description, category, price, quantity, image_url, farmer_id)
//     VALUES (?, ?, ?, ?, ?, ?, ?)
//   `;
//   console.log('INSERT QUERY:', query);
//   return db.query(query, [name, description, category, price, quantity, image_url, farmer_id]);
// };

// const getAllProducts = () => {
//   const query = 'SELECT * FROM products';
//   return db.query(query);
// };

// const getProductById = (id) => {
//   const query = 'SELECT * FROM products WHERE id = ?';
//   return db.query(query, [id]).then(([results]) => results[0]); // Return the first product if found
// };

// const getProductsByFarmerId = (farmer_id) => {
//   const query = 'SELECT * FROM products WHERE farmer_id = ?';
//   return db.query(query, [farmer_id]);
// };

// const updateProduct = (id, name, description, category, price, quantity, image_url) => {
//   const query = `
//     UPDATE products
//     SET name = ?, description = ?, category = ?, price = ?, quantity = ?, image_url = ?
//     WHERE id = ?
//   `;
//   return db.query(query, [name, description, category, price, quantity, image_url, id]);
// };

// const deleteProduct = (id) => {
//   const query = 'DELETE FROM products WHERE id = ?';
//   return db.query(query, [id]);
// };

// // Export the functions as the default export
// export default {
//   createProduct,
//   getAllProducts,
//   getProductById,
//   getProductsByFarmerId,
//   updateProduct,
//   deleteProduct
// };



/*  new code */
import db from './db.js'; // Import the database connection

const createProduct = async (name, description, category, price, quantity, image_url, farmer_id) => {
  const query = `
    INSERT INTO products (name, description, category, price, quantity, image_url, farmer_id)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;
  const [result] = await db.query(query, [
    name,
    description,
    category,
    price,
    quantity,
    image_url,
    farmer_id,
  ]);
  return result;
};

const getAllProducts = async () => {
  const [results] = await db.query('SELECT * FROM products');
  return results;
};

const getProductById = async (id) => {
  const [results] = await db.query('SELECT * FROM products WHERE id = ?', [id]);
  return results[0] || null;
};

const getProductsByFarmerId = async (farmer_id) => {
  const [results] = await db.query('SELECT * FROM products WHERE farmer_id = ?', [farmer_id]);
  return results;
};

const updateProduct = async (id, name, description, category, price, quantity, image_url) => {
  const query = `
    UPDATE products
    SET name = ?, description = ?, category = ?, price = ?, quantity = ?, image_url = ?
    WHERE id = ?
  `;
  const [result] = await db.query(query, [
    name,
    description,
    category,
    price,
    quantity,
    image_url,
    id,
  ]);
  return result;
};

const deleteProduct = async (id) => {
  const [result] = await db.query('DELETE FROM products WHERE id = ?', [id]);
  return result;
};

export default {
  createProduct,
  getAllProducts,
  getProductById,
  getProductsByFarmerId,
  updateProduct,
  deleteProduct,
};
