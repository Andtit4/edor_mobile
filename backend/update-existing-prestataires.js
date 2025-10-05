// Script pour mettre à jour les prestataires existants avec "Général" comme catégorie
const mysql = require('mysql2/promise');

async function updateExistingPrestataires() {
    const connection = await mysql.createConnection({
        host: '185.97.146.99',
        port: 8081,
        user: 'root',
        password: 'mot_de_passe_root',
        database: 'edor_mobile'
    });

    try {
        console.log('🔍 Connexion à la base de données...');

        // Vérifier les prestataires avec "Général" comme catégorie
        const [prestataires] = await connection.execute(
            'SELECT id, name, category, location FROM prestataires WHERE category = "Général"'
        );

        console.log(`📊 ${prestataires.length} prestataires trouvés avec la catégorie "Général"`);

        if (prestataires.length === 0) {
            console.log('✅ Aucun prestataire à mettre à jour');
            return;
        }

        // Catégories disponibles
        const categories = [
            'menage',
            'plomberie', 
            'electricite',
            'bricolage',
            'jardinage',
            'transport',
            'cuisine',
            'beaute',
            'peinture',
            'climatisation',
            'securite',
            'autre'
        ];

        // Mettre à jour chaque prestataire
        for (let i = 0; i < prestataires.length; i++) {
            const prestataire = prestataires[i];
            
            // Assigner une catégorie basée sur l'index (pour la démo)
            // En production, vous pourriez analyser le nom ou la description
            const newCategory = categories[i % categories.length];
            
            await connection.execute(
                'UPDATE prestataires SET category = ? WHERE id = ?', 
                [newCategory, prestataire.id]
            );
            
            console.log(`✅ Prestataire ${prestataire.name} mis à jour: "Général" → "${newCategory}"`);
        }

        // Vérifier les résultats
        const [updatedPrestataires] = await connection.execute(
            'SELECT id, name, category, location FROM prestataires ORDER BY category'
        );

        console.log('\n📊 Prestataires mis à jour:');
        updatedPrestataires.forEach(p => {
            console.log(`   - ${p.name}: ${p.category} (${p.location})`);
        });

        // Statistiques par catégorie
        const [stats] = await connection.execute(
            'SELECT category, COUNT(*) as count FROM prestataires GROUP BY category ORDER BY count DESC'
        );

        console.log('\n📈 Statistiques par catégorie:');
        stats.forEach(stat => {
            console.log(`   - ${stat.category}: ${stat.count} prestataire(s)`);
        });

    } catch (error) {
        console.error('❌ Erreur:', error);
    } finally {
        await connection.end();
    }
}

updateExistingPrestataires();




