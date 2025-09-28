// src/config/database.config.ts
import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import * as dotenv from 'dotenv';
dotenv.config();

export const databaseConfig: TypeOrmModuleOptions = {
  type: 'mysql',
  host: process.env.DB_HOST || '185.97.146.99',
  port: parseInt(process.env.DB_PORT || '8081'),
  username: process.env.DB_USERNAME || 'root',
  password: process.env.DB_PASSWORD || 'mot_de_passe_root',
  database: process.env.DB_DATABASE || 'edor_mobile',
  entities: [__dirname + '/../**/*.entity{.ts,.js}'],
  synchronize: true, // Force la synchronisation pour recréer les tables
  logging: true, // Active les logs pour voir les requêtes SQL
  dropSchema: false, // Ne pas supprimer toutes les tables
  // Options de connexion robustes
  extra: {
    connectionLimit: 10,
    acquireTimeout: 60000,
    timeout: 60000,
    reconnect: true,
    keepAlive: true,
    keepAliveInitialDelay: 0,
    // Gestion des déconnexions
    idleTimeout: 300000, // 5 minutes
    maxReconnects: 5,
    reconnectInterval: 2000, // 2 secondes
  },
  // Pool de connexions
  poolSize: 10,
  // Retry en cas d'échec
  retryAttempts: 3,
  retryDelay: 3000,
};
