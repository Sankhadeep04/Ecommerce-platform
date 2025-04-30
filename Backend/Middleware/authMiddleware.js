import jwt from 'jsonwebtoken';

export function verifyToken(req, res, next) {
  const authHeader = req.headers['authorization'];

  // Check if token is present
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      message: 'Missing or invalid authorization header',
    });
  }

  const token = authHeader.split(' ')[1]; // Get the token after 'Bearer '

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET); // Use the same key you signed with
    req.user = decoded; // Attach decoded user info to request
    next(); // Proceed to next handler
  } catch (err) {
    return res.status(403).json({
      message: 'Invalid or expired token',
      error: err.message,
    });
  }
}
