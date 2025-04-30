// Routes/consumerRoutes.js

import express from 'express';
import { getAllProducts, getProductById } from '../Controllers/consumerController.js';

const router = express.Router();

// Consumer routes
router.get('/products', getAllProducts);
router.get('/products/:productId', getProductById);

export default router;
