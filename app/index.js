const express = require('express');
const winston = require('winston');
const LokiTransport = require('winston-loki');
const app = express();

const transports = [
    new winston.transports.Console()
];

if (process.env.LOKI_HOST) {
    console.log('Adding Loki transport');
    transports.push(new LokiTransport({
        host: process.env.LOKI_HOST,
        basicAuth: process.env.LOKI_BASIC_AUTH,
        json: true,
        labels: { app: process.env.RAILWAY_SERVICE_NAME || 'app', env: process.env.RAILWAY_ENVIRONMENT_NAME || 'local' }, // Customize labels as needed
        batching: false,
        onConnectionError: (err) => {
            console.error('Error connecting to Loki:', err);
        }
    }));
}

// Setup logger with conditional Loki transport
const logger = winston.createLogger({
    level: 'info',
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
    ),
    transports: transports
});

// Logging middleware to replace Morgan
app.use((req, res, next) => {
    res.on('finish', () => {
        logger.info('HTTP Access Log', {
            method: req.method,
            url: req.originalUrl,
            status: res.statusCode,
            ip: req.ip
        });
    });
    next();
});

// Index route
app.get('/', (req, res) => {
    logger.info(`Received request from ${req.ip}`);
    res.setHeader('Cache-Control', 'no-store');
    res.send('Hello, World!');
});

// Status route
app.get('/status', (req, res) => {
    logger.info(`Received request from ${req.ip}`);
    res.setHeader('Cache-Control', 'no-store');
    res.send('OK');
});

// Cache route
app.get('/cache-this', (req, res) => {
    logger.info(`Received request from ${req.ip}`);
    res.setHeader('Cache-Control', 'public, max-age=60');
    res.send(`Cache this response for 60s: ${Math.floor(Math.random() * 1000)}`);
});

// Set the port and start the server
const port = process.env.PORT || 8080;
app.listen(port, () => {
    logger.info(`Starting server on port ${port}`);
});
