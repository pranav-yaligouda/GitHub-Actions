import { NODE_ENV, PORT } from './config/envconfig.js';
import express from 'express';

const app = express();

app.get('/', (req, res) => {
    res.send('Simple Express app for the CI/CD Actions');
})

app.listen(PORT, async () => {
    console.log(`Server listening on Port: ${PORT} at http://localhost:${PORT}`);
} );