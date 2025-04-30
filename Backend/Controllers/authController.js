// // Controllers/authController.js
// import { registerUserProcessor, loginUserProcessor } from '../Processors/authProcessor.js';

// export async function registerUser(req, res) {
//   try {
//     const result = await registerUserProcessor(req.body);
//     res.status(201).json({ message: 'User registered successfully', data: result });
//   } catch (error) {
//     res.status(500).json({ message: 'Registration failed', error: error.message });
//   }
// }

// export async function loginUser(req, res) {
//   try {
//     const result = await loginUserProcessor(req.body);
//     res.status(200).json({ message: 'Login successful', data: result });
//   } catch (error) {
//     res.status(401).json({ message: 'Login failed', error: error.message });
//   }
// }

import { registerUserProcessor, loginUserProcessor } from '../Processors/authProcessor.js';

export async function registerUser(req, res) {
  try {
    const result = await registerUserProcessor(req.body);
    res.status(201).json({ message: 'User registered successfully', data: result, });
  }
  catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ message: 'Registration failed', error: error.message || 'Unknown error', });
  }
}

export async function loginUser(req, res) { 
  try { 
    const result = await loginUserProcessor(req.body); 
    res.status(200).json({ message: 'Login successful', data: result, });
  } 
  catch (error) { 
    console.error('Login error:', error); 
    res.status(401).json({ message: 'Login failed', error: error.message || 'Invalid credentials', }); 
  } 
}