// auth/jwt-util.js
const jwt = require("jsonwebtoken");
const secret = process.env.JWT_SECRET;

const sign = (user) => {
  const payload = {
    id: user._id,
    email: user.email,
  };

  return jwt.sign(payload, secret, {
    algorithm: "HS256",
    expiresIn: "1h",
  });
};

const verify = (token) => {
  try {
    const decoded = jwt.verify(token, secret);
    return {
      ok: true,
      id: decoded.id,
      email: decoded.email,
    };
  } catch (e) {
    return {
      ok: false,
      message: e.message,
    };
  }
};

module.exports = { sign, verify };
