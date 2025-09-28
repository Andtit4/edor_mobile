// Script pour corriger la contrainte de clé étrangère assignedPrestataireId
const mysql = require('mysql2/promise');

async function fixPrestataireForeignKey() {
    const connection = await mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: '', // Mot de passe vide par défaut
        database: 'edor_mobile'
    });

    try {
        console.log('🔧 Correction de la contrainte de clé étrangère assignedPrestataireId...');

        // Désactiver les vérifications de clés étrangères
        await connection.execute('SET FOREIGN_KEY_CHECKS = 0');
        console.log('✅ Vérifications de clés étrangères désactivées');

        // Supprimer l'ancienne contrainte
        try {
            await connection.execute('ALTER TABLE service_requests DROP FOREIGN KEY FK_75cfadf75fb1477c26a9921d050');
            console.log('✅ Ancienne contrainte supprimée');
        } catch (error) {
            console.log('⚠️  Ancienne contrainte non trouvée ou déjà supprimée');
        }

        // Ajouter la nouvelle contrainte vers la table prestataires
        await connection.execute(`
      ALTER TABLE service_requests 
      ADD CONSTRAINT FK_service_requests_assigned_prestataire 
      FOREIGN KEY (assignedPrestataireId) REFERENCES prestataires(id) 
      ON DELETE SET NULL ON UPDATE CASCADE
    `);
        console.log('✅ Nouvelle contrainte ajoutée vers la table prestataires');

        // Réactiver les vérifications de clés étrangères
        await connection.execute('SET FOREIGN_KEY_CHECKS = 1');
        console.log('✅ Vérifications de clés étrangères réactivées');

        console.log('🎉 Correction terminée avec succès !');

    } catch (error) {
        console.error('❌ Erreur lors de la correction:', error.message);
    } finally {
        await connection.end();
    }
}

fixPrestataireForeignKey();