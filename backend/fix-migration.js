const mysql = require('mysql2/promise');

async function fixMigration() {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'edor_mobile'
  });

  try {
    console.log('🔧 Suppression des contraintes de clés étrangères...');
    
    // Supprimer les contraintes de clés étrangères
    await connection.execute('SET FOREIGN_KEY_CHECKS = 0');
    
    // Supprimer les tables existantes
    console.log('🗑️ Suppression des tables existantes...');
    await connection.execute('DROP TABLE IF EXISTS messages');
    await connection.execute('DROP TABLE IF EXISTS conversations');
    
    // Réactiver les contraintes
    await connection.execute('SET FOREIGN_KEY_CHECKS = 1');
    
    console.log('✅ Tables supprimées avec succès !');
    console.log('🔄 Redémarrez le backend pour recréer les tables...');
    
  } catch (error) {
    console.error('❌ Erreur:', error.message);
  } finally {
    await connection.end();
  }
}

fixMigration();
