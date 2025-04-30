// import Product from '../Models/productModel.js';

// export async function getAllProductsProcessor() {
//   return await Product.find();
// }

// export async function getProductByIdProcessor(product_id) {
//   return await Product.findById(product_id);
// }

// Processors/consumerProcessor.js

import productModel from '../Models/productModel.js';

export async function getAllProductsProcessor() {
  try {
    const products = await productModel.getAllProducts();
    return products;
  } catch (error) {
    throw new Error('Failed to fetch all products: ' + error.message);
  }
}

export async function getProductByIdProcessor(product_id) {
  try {
    const product = await productModel.getProductById(product_id);
    if (!product) {
      throw new Error('Product not found');
    }
    return product;
  } catch (error) {
    throw new Error('Failed to fetch product by ID: ' + error.message);
  }
}
