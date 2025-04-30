// Controllers/farmerController.js
import { addProductProcessor, getFarmerProductsProcessor, updateProductProcessor, deleteProductProcessor } from '../Processors/farmerProcessor.js';

// Add Product
export async function addProduct(req, res) {
  console.log("Add product called");
  try {
    const product = await addProductProcessor(req.body, req.params.id);
    console.log("Returned product:", product);
    res.status(201).json({ message: 'Product added successfully', product });
  } catch (error) {
    res.status(500).json({ message: 'Failed to add product', error: error.message });
  }
}

// Get Farmer's Products
export async function getFarmerProducts(req, res) {
  try {
    const products = await getFarmerProductsProcessor(req.params.id);  // need to change all those from promise to query 
    res.status(200).json({ products });
  } catch (error) {
    res.status(500).json({ message: 'Failed to fetch products', error: error.message });
  }
}

// Update Product
export async function updateProduct(req, res) {
  try {
    const updatedProduct = await updateProductProcessor(req.params.product_id, req.body);
    res.status(200).json({ message: 'Product updated successfully', updatedProduct });
  } catch (error) {
    res.status(500).json({ message: 'Failed to update product', error: error.message });
  }
}

// Delete Product
export async function deleteProduct(req, res) {
  try {
    await deleteProductProcessor(req.params.product_id);
    res.status(200).json({ message: 'Product deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Failed to delete product', error: error.message });
  }
}

