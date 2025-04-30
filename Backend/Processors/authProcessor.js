// Processors/authProcessor.js

import { createUser, getUserByEmail } from '../Models/userModel.js';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';


export async function registerUser(req, res) {
  const { name, email, password, role, phone } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    await createUser(name, email, hashedPassword, role, phone);
    res.status(201).json({ message: 'User registered successfully' });
    } catch (err) 
    {
        console.error("Registration Error:", err);  // Good for debugging in terminal
        res.status(500).json({ 
          message: 'Error registering user', 
          error: err.message || 'Unknown error'
      });
    }
}

export async function loginUser(req, res) {
  const { email, password } = req.body;
  try {
    const user = await getUserByEmail(email);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }
    const token = jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET, { expiresIn: '1h' });
    res.status(200).json({ message: 'Login successful', token });
  } catch (err) {
    res.status(500).json({ message: 'Error logging in', error: err });
  }
}
