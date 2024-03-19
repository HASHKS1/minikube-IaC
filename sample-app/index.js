// index.js
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  const apiKey = process.env.API_KEY;
  res.send(`<h1>API Key: ${apiKey}</h1>`);
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
