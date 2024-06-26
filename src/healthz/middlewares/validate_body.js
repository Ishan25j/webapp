const { logger } = require('../../logging/logger');

const request_body = async(req, res, next) => {
    if (Object.keys(req.body).length || Object.keys(req.query).length) {
        res.set('Cache-Control', 'no-cache');
        logger.log({
            level: 'warn',
            severity: 'WARNING',
            message: 'POST /healthz API path',
            meta: `Invalid request body 400`
        });
        res.status(400).send();
    } else {
        req.start = Date.now();
        next();
    }
};



module.exports = request_body;