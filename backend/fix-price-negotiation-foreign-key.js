// backend/fix-price-negotiation-foreign-key.js
const mysql = require('mysql2/promise');

async function fixPriceNegotiationForeignKey() {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'edor_mobile'
  });

  try {
    console.log('🔧 Correction de la contrainte de clé étrangère prestataire_id...');
    
    // Désactiver les vérifications de clés étrangères
    await connection.execute('SET FOREIGN_KEY_CHECKS = 0;');
    
    // Supprimer l'ancienne contrainte
    await connection.execute('ALTER TABLE `price_negotiations` DROP FOREIGN KEY `FK_53de3d569bc7b69fb51210ecb89`;');
    
    // Ajouter la nouvelle contrainte pointant vers la table prestataires
    await connection.execute('ALTER TABLE `price_negotiations` ADD CONSTRAINT `FK_prestataire_prestataires` FOREIGN KEY (`prestataire_id`) REFERENCES `prestataires` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;');
    
    // Réactiver les vérifications de clés étrangères
    await connection.execute('SET FOREIGN_KEY_CHECKS = 1;');
    
    console.log('🎉 Correction terminée avec succès !');
    
    // Vérifier la structure de la table
    const [constraints] = await connection.execute(`
      SELECT 
        CONSTRAINT_NAME,
        COLUMN_NAME,
        REFERENCED_TABLE_NAME,
        REFERENCED_COLUMN_NAME
      FROM information_schema.KEY_COLUMN_USAGE 
      WHERE TABLE_NAME = 'price_negotiations' 
      AND CONSTRAINT_NAME LIKE 'FK_%'
    `);
    
    console.log('📋 Contraintes actuelles:');
    constraints.forEach(constraint => {
      console.log(`  - ${constraint.CONSTRAINT_NAME}: ${constraint.COLUMN_NAME} -> ${constraint.REFERENCED_TABLE_NAME}.${constraint.REFERENCED_COLUMN_NAME}`);
    });
    
  } catch (error) {
    console.error('❌ Erreur lors de la correction de la clé étrangère:', error);
  } finally {
    await connection.end();
  }
}

fixPriceNegotiationForeignKey();

