module.exports = {
    apps: [{
        name: 'edor-api',
        script: 'dist/main.js',
        cwd: '/path/to/your/backend',
        instances: 1,
        exec_mode: 'fork',
        env: {
            NODE_ENV: 'production',
            PORT: 8090,
            BASE_URL: 'http://localhost:8090'
        },
        env_production: {
            NODE_ENV: 'production',
            PORT: 8090,
            BASE_URL: 'http://localhost:8090'
        },
        env_development: {
            NODE_ENV: 'development',
            PORT: 8090,
            BASE_URL: 'http://localhost:8090'
        },
        // Configuration de redémarrage
        autorestart: true,
        watch: false,
        max_memory_restart: '1G',

        // Logs
        log_file: './logs/combined.log',
        out_file: './logs/out.log',
        error_file: './logs/error.log',
        log_date_format: 'YYYY-MM-DD HH:mm:ss Z',

        // Configuration avancée
        min_uptime: '10s',
        max_restarts: 10,
        restart_delay: 4000,

        // Variables d'environnement depuis .env
        env_file: '.env',

        // Health check
        health_check_grace_period: 3000,

        // Kill timeout
        kill_timeout: 5000,

        // Listen timeout
        listen_timeout: 3000,

        // Graceful shutdown
        kill_retry_time: 100
    }],

    // Configuration de déploiement
    deploy: {
        production: {
            user: 'root',
            host: '185.97.146.99',
            ref: 'origin/main',
            repo: 'git@github.com:andtit/edor-mobile.git',
            path: '/var/www/edor-api',
            'pre-deploy-local': '',
            'post-deploy': 'npm install && npm run build && pm2 reload ecosystem.config.js --env production',
            'pre-setup': ''
        }
    }
};