import db from '../Models/db.js';  // Adjusted the import path to point to the Models folder
// Add a new product
export async function addProductProcessor(data, farmer_id) {
  try {
    const { name, description, category, price, quantity, image_url } = data;
    const query = `INSERT INTO products (name, description, category, price, quantity, image_url, farmer_id) 
                   VALUES (?, ?, ?, ?, ?, ?, ?)`;
    const [result] = await db.execute(query, [name, description, category, price, quantity, image_url, farmer_id]);
    return { insert_id: result.insertId };
  } catch (err) {
    console.error("Error in addProductProcessor:", err);
    throw err; // or handle however you want
  }
}

// Get products by farmer ID
export async function getFarmerProductsProcessor(farmer_id) {
  try {
    const query = 'SELECT * FROM products WHERE farmer_id = ?';
    const [results] = await db.execute(query, [farmer_id]);
    return results;
  } catch (err) {
    console.error("Error in getFarmerProductsProcessor:", err);
    throw err;
  }
}

// Update a product
export async function updateProductProcessor(product_id, data) {
  try {
    const { name, description, category, price, quantity, image_url } = data;
    const query = `UPDATE products SET name = ?, description = ?, category = ?, price = ?, 
                   quantity = ?, image_url = ? WHERE id = ?`;
    const [result] = await db.execute(query, [name, description, category, price, quantity, image_url, product_id]);
    return result;
  } catch (err) {
    console.error("Error in updateProductProcessor:", err);
    throw err;
  }
}

// Delete a product
export async function deleteProductProcessor(product_id) {
  try {
    const query = 'DELETE FROM products WHERE id = ?';
    const [result] = await db.execute(query, [product_id]);
    return result;
  } catch (err) {
    console.error("Error in deleteProductProcessor:", err);
    throw err;
  }
}
