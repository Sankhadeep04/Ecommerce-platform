// Controllers/consumerController.js

import {
  getAllProductsProcessor,
  getProductByIdProcessor,
} from '../Processors/consumerProcessor.js';

export async function getAllProducts(req, res) {
  try {
    const products = await getAllProductsProcessor();
    res.status(200).json({ products });
  } catch (error) {
    res.status(500).json({
      message: 'Failed to fetch products',
      error: error.message,
    });
  }
}

export async function getProductById(req, res) {
  try {
    const product = await getProductByIdProcessor(req.params.productId);

    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    res.status(200).json({ product });
  } catch (error) {
    res.status(500).json({
      message: 'Failed to fetch product',
      error: error.message,
    });
  }
}
