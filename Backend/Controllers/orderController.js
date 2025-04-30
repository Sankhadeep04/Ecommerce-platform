import db from '../Models/db.js'; // Ensure you're using the correct DB connection

// Create a new order
export const createOrder = (req, res) => {
  const { consumer_id, farmer_id, items, total_amount } = req.body;

  // Insert into orders table
  const orderQuery = 'INSERT INTO orders (consumer_id, farmer_id, total_amount) VALUES (?, ?, ?)';
  db.query(orderQuery, [consumer_id, farmer_id, total_amount], (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Error creating order', error: err });
    }

    const order_id = result.insertId;

    // Insert order items into the order_items table
    const orderItemsQuery = 'INSERT INTO order_items (order_id, product_id, quantity, price) VALUES ?';
    const orderItemsValues = items.map(item => [order_id, item.productId, item.quantity, item.price]);

    db.query(orderItemsQuery, [orderItemsValues], (err) => {
      if (err) {
        return res.status(500).json({ message: 'Error creating order items', error: err });
      }

      res.status(201).json({ message: 'Order created successfully', order_id });
    });
  });
};

// Get all orders for a user
export const getOrdersByUser = (req, res) => {
  const { userId } = req.params;

  const query = 'SELECT * FROM orders WHERE consumer_id = ?';
  db.query(query, [userId], (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Error retrieving orders', error: err });
    }
    res.status(200).json(results);
  });
};

// Get a single order by ID
export const getOrderById = (req, res) => {
  const { id } = req.params;

  const query = 'SELECT * FROM orders WHERE id = ?';
  db.query(query, [id], (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Error retrieving order', error: err });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: 'Order not found' });
    }
    res.status(200).json(results[0]);
  });
};

// Update order status
export const updateOrderStatus = (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  const query = 'UPDATE orders SET status = ? WHERE id = ?';
  db.query(query, [status, id], (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Error updating order status', error: err });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Order not found' });
    }
    res.status(200).json({ message: 'Order status updated successfully' });
  });
};

// Delete an order
export const deleteOrder = (req, res) => {
  const { id } = req.params;

  const query = 'DELETE FROM orders WHERE id = ?';
  db.query(query, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Error deleting order', error: err });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Order not found' });
    }
    res.status(200).json({ message: 'Order deleted successfully' });
  });
};
