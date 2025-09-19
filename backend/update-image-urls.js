// Script pour mettre à jour les URLs d'images existantes en base de données
// Usage: node update-image-urls.js

const mysql = require('mysql2/promise');

// Configuration de la base de données
const dbConfig = {
    host: '185.97.146.99',
    port: 8081,
    user: 'root',
    password: 'mot_de_passe_root',
    database: 'edor_mobile'
};

const oldBaseUrl = 'http://192.168.100.34:3000';
const newBaseUrl = 'http://185.97.146.99:8090';

async function updateImageUrls() {
    let connection;

    try {
        console.log('🔌 Connexion à la base de données...');
        connection = await mysql.createConnection(dbConfig);
        console.log('✅ Connexion établie');

        // Mettre à jour les URLs dans la table users
        console.log('\n📝 Mise à jour des URLs dans la table users...');
        const [userResults] = await connection.execute(
            `UPDATE users 
       SET profileImage = REPLACE(profileImage, ?, ?) 
       WHERE profileImage LIKE ?`, [oldBaseUrl, newBaseUrl, `${oldBaseUrl}%`]
        );
        console.log(`✅ ${userResults.affectedRows} utilisateurs mis à jour`);

        // Mettre à jour les URLs dans la table prestataires
        console.log('\n📝 Mise à jour des URLs dans la table prestataires...');
        const [prestataireResults] = await connection.execute(
            `UPDATE prestataires 
       SET profileImage = REPLACE(profileImage, ?, ?) 
       WHERE profileImage LIKE ?`, [oldBaseUrl, newBaseUrl, `${oldBaseUrl}%`]
        );
        console.log(`✅ ${prestataireResults.affectedRows} prestataires mis à jour`);

        // Mettre à jour les URLs dans la table service_requests (photos)
        console.log('\n📝 Mise à jour des URLs dans la table service_requests...');
        const [serviceRequestResults] = await connection.execute(
            `UPDATE service_requests 
       SET photos = REPLACE(photos, ?, ?) 
       WHERE photos LIKE ?`, [oldBaseUrl, newBaseUrl, `%${oldBaseUrl}%`]
        );
        console.log(`✅ ${serviceRequestResults.affectedRows} demandes de service mises à jour`);

        // Mettre à jour les URLs dans la table service_requests (clientImage)
        console.log('\n📝 Mise à jour des clientImage dans la table service_requests...');
        const [clientImageResults] = await connection.execute(
            `UPDATE service_requests 
       SET clientImage = REPLACE(clientImage, ?, ?) 
       WHERE clientImage LIKE ?`, [oldBaseUrl, newBaseUrl, `${oldBaseUrl}%`]
        );
        console.log(`✅ ${clientImageResults.affectedRows} images client mises à jour`);

        // Vérifier les résultats
        console.log('\n🔍 Vérification des URLs mises à jour...');

        const [userCheck] = await connection.execute(
            `SELECT COUNT(*) as count FROM users WHERE profileImage LIKE ?`, [`${newBaseUrl}%`]
        );
        console.log(`📊 Utilisateurs avec nouvelle URL: ${userCheck[0].count}`);

        const [prestataireCheck] = await connection.execute(
            `SELECT COUNT(*) as count FROM prestataires WHERE profileImage LIKE ?`, [`${newBaseUrl}%`]
        );
        console.log(`📊 Prestataires avec nouvelle URL: ${prestataireCheck[0].count}`);

        const [serviceRequestCheck] = await connection.execute(
            `SELECT COUNT(*) as count FROM service_requests WHERE photos LIKE ?`, [`%${newBaseUrl}%`]
        );
        console.log(`📊 Demandes de service avec nouvelle URL: ${serviceRequestCheck[0].count}`);

        console.log('\n🎉 Migration terminée avec succès!');
        console.log(`📝 Ancienne URL: ${oldBaseUrl}`);
        console.log(`📝 Nouvelle URL: ${newBaseUrl}`);

    } catch (error) {
        console.error('❌ Erreur lors de la migration:', error);
        process.exit(1);
    } finally {
        if (connection) {
            await connection.end();
            console.log('\n🔌 Connexion fermée');
        }
    }
}

// Exécuter la migration
updateImageUrls();