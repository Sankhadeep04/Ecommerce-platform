// Routes/farmerRoutes.js

import express from 'express';
import { verifyToken } from '../Middleware/authMiddleware.js';
import { addProduct, getFarmerProducts, updateProduct, deleteProduct } from '../Controllers/farmerController.js';

const router = express.Router();


router.use(verifyToken);

// Farmer routes
router.post('/farmers/:id/products', addProduct);
router.get('/farmers/:id/products', getFarmerProducts);
router.put('/products/:productId', updateProduct);
router.delete('/products/:productId', deleteProduct);

export default router;
