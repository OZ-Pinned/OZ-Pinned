// middleware/authJWT.js
const { verify } = require("../auth/jwt-util");

const authJWT = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({ ok: false, message: "No token provided" });
  }

  const token = authHeader.split("Bearer ")[1];

  const result = verify(token);
  if (!result.ok) {
    return res.status(401).json({ ok: false, message: result.message });
  }

  req.user = result; // 이후 라우터에서 req.user.id, req.user.email 사용 가능
  next();
};

module.exports = authJWT;
