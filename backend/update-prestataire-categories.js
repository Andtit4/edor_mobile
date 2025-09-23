// Script pour mettre à jour les catégories des prestataires
const mysql = require('mysql2/promise');

async function updatePrestataireCategories() {
    const connection = await mysql.createConnection({
        host: '185.97.146.99',
        port: 8081,
        user: 'root',
        password: 'mot_de_passe_root',
        database: 'edor_mobile'
    });

    try {
        console.log('🔍 Connexion à la base de données...');

        // Vérifier les prestataires actuels
        const [prestataires] = await connection.execute(
            'SELECT id, name, category FROM prestataires'
        );

        console.log('📊 Prestataires actuels:', prestataires);

        // Mettre à jour les catégories
        const categories = ['Plomberie', 'Électricité', 'Jardinage'];

        for (let i = 0; i < prestataires.length; i++) {
            const category = categories[i % categories.length];
            await connection.execute(
                'UPDATE prestataires SET category = ? WHERE id = ?', [category, prestataires[i].id]
            );
            console.log(`✅ Prestataire ${prestataires[i].name} mis à jour vers catégorie: ${category}`);
        }

        // Vérifier les résultats
        const [updatedPrestataires] = await connection.execute(
            'SELECT id, name, category FROM prestataires'
        );

        console.log('📊 Prestataires mis à jour:', updatedPrestataires);

    } catch (error) {
        console.error('❌ Erreur:', error);
    } finally {
        await connection.end();
    }
}

updatePrestataireCategories();