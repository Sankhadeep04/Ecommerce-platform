// import db from './db.js'; // Import the database connection

// // Create a new user
// // export const createUser = (name, email, password_hash, role, phone) => {
// //   try {
// //     const query = `
// //     INSERT INTO users (name, email, password_hash, role, phone)
// //     VALUES (?, ?, ?, ?, ?)
// //     `;
// //     return db.query(query, [name, email, password_hash, role, phone]);
// //   }
// //   catch (err) {
// //     console.error("Error inserting user:", err);  // Log the error to the console for debugging
// //     throw new Error("Error user");
// //   }
// // };
// export const createUser = async (name, email, password_hash, role, phone) => {
//   try {
//     const query = `
//       INSERT INTO users (name, email, password_hash, role, phone)
//       VALUES (?, ?, ?, ?, ?)
//     `;
//     // Execute the query
//     const [rows, fields] = await db.query(query, [name, email, password_hash, role, phone]);

//     console.log('Inserted Rows:', rows); // Logs the inserted rows (should contain the new user)
//     console.log('Query Fields:', fields); // Logs metadata, e.g., affected rows or column names

//     if (rows.affectedRows > 0) {
//       return { message: 'User registered successfully', user: rows };
//     } else {
//       throw new Error('Failed to register user');
//     }
//   } catch (err) {
//     console.error("Error during user registration:", err);
//     throw new Error("Error registering user: " + err.message); // Include the error message in the response
//   }
// };

// // Get a user by email
// export const getUserByEmail = (email) => {
//   const query = 'SELECT * FROM users WHERE email = ?';
//   return db.query(query, [email])
//     .then(([results]) => results[0] || null); // Return the first user if found or null
// };

// // Get a user by ID
// export const getUserById = (id) => {
//   const query = 'SELECT * FROM users WHERE id = ?';
//   return db.query(query, [id])
//     .then(([results]) => results[0] || null); // Return the user if found or null
// };

// // Update user details
// export const updateUser = (id, name, email, phone) => {
//   const query = `
//     UPDATE users
//     SET name = ?, email = ?, phone = ?
//     WHERE id = ?
//   `;
//   return db.query(query, [name, email, phone, id]);
// };

// // Delete a user
// export const deleteUser = (id) => {
//   const query = 'DELETE FROM users WHERE id = ?';
//   return db.query(query, [id]);
// };


/* new code */
import db from './db.js'; // Import the database connection

// Create a new user
export const createUser = async (name, email, password_hash, role, phone) => {
  try {
    const query = `
      INSERT INTO users (name, email, password_hash, role, phone)
      VALUES (?, ?, ?, ?, ?)
    `;
    const [result] = await db.query(query, [name, email, password_hash, role, phone]);

    if (result.affectedRows > 0) {
      return {
        message: 'User registered successfully',
        userId: result.insertId
      };
    } else {
      throw new Error('Failed to register user');
    }
  } catch (err) {
    console.error('Error during user registration:', err);
    throw new Error('Error registering user: ' + err.message);
  }
};

// Get a user by email
export const getUserByEmail = async (email) => {
  try {
    const query = 'SELECT * FROM users WHERE email = ?';
    const [results] = await db.query(query, [email]);
    return results[0] || null;
  } catch (err) {
    throw new Error('Error fetching user by email: ' + err.message);
  }
};

// Get a user by ID
export const getUserById = async (id) => {
  try {
    const query = 'SELECT * FROM users WHERE id = ?';
    const [results] = await db.query(query, [id]);
    return results[0] || null;
  } catch (err) {
    throw new Error('Error fetching user by ID: ' + err.message);
  }
};

// Update user details
export const updateUser = async (id, name, email, phone) => {
  try {
    const query = `
      UPDATE users
      SET name = ?, email = ?, phone = ?
      WHERE id = ?
    `;
    const [result] = await db.query(query, [name, email, phone, id]);
    return result;
  } catch (err) {
    throw new Error('Error updating user: ' + err.message);
  }
};

// Delete a user
export const deleteUser = async (id) => {
  try {
    const query = 'DELETE FROM users WHERE id = ?';
    const [result] = await db.query(query, [id]);
    return result;
  } catch (err) {
    throw new Error('Error deleting user: ' + err.message);
  }
};
