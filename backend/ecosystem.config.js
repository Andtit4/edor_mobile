module.exports = {
    apps: [{
        name: 'edor-api',
        script: 'dist/main.js',
        cwd: '/var/www/edor-api/backend',
        instances: 1,
        exec_mode: 'fork',
        env: {
            NODE_ENV: 'production',
            PORT: 8090,
            BASE_URL: 'http://185.97.146.99:8090',
            DB_HOST: '185.97.146.99',
            DB_PORT: '8081',
            DB_USERNAME: 'root',
            DB_PASSWORD: 'mot_de_passe_root',
            DB_DATABASE: 'edor_mobile',
            JWT_SECRET: 'your-secret-key-here',
            JWT_EXPIRES_IN: '7d'
        },
        env_production: {
            NODE_ENV: 'production',
            PORT: 8090,
            BASE_URL: 'http://185.97.146.99:8090',
            DB_HOST: '185.97.146.99',
            DB_PORT: '8081',
            DB_USERNAME: 'root',
            DB_PASSWORD: 'mot_de_passe_root',
            DB_DATABASE: 'edor_mobile',
            JWT_SECRET: 'your-secret-key-here',
            JWT_EXPIRES_IN: '7d'
        },
        env_development: {
            NODE_ENV: 'development',
            PORT: 8090,
            BASE_URL: 'http://185.97.146.99:8090',
            DB_HOST: '185.97.146.99',
            DB_PORT: '8081',
            DB_USERNAME: 'root',
            DB_PASSWORD: 'mot_de_passe_root',
            DB_DATABASE: 'edor_mobile',
            JWT_SECRET: 'your-secret-key-here',
            JWT_EXPIRES_IN: '7d'
        },

        // Configuration de redémarrage
        autorestart: true,
        watch: false,
        max_memory_restart: '1G',

        // Logs
        log_file: '/var/www/edor-api/backend/logs/combined.log',
        out_file: '/var/www/edor-api/backend/logs/out.log',
        error_file: '/var/www/edor-api/backend/logs/error.log',
        log_date_format: 'YYYY-MM-DD HH:mm:ss Z',

        // Configuration avancée
        min_uptime: '10s',
        max_restarts: 10,
        restart_delay: 4000,

        // Variables d'environnement depuis .env
        env_file: '/var/www/edor-api/backend/.env',

        // Health check
        health_check_grace_period: 3000,

        // Kill timeout
        kill_timeout: 5000,

        // Listen timeout
        listen_timeout: 3000,

        // Graceful shutdown
        kill_retry_time: 100,

        // Working directory pour les uploads
        working_dir: '/var/www/edor-api/backend'
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
            'post-deploy': 'cd backend && npm install && npm run build && pm2 reload ecosystem.config.js --env production',
            'pre-setup': 'mkdir -p /var/www/edor-api/backend/uploads/profiles && mkdir -p /var/www/edor-api/backend/uploads/service-requests && mkdir -p /var/www/edor-api/backend/logs && chmod 755 /var/www/edor-api/backend/uploads'
        }
    }
};