const mysql = require('mysql2/promise');

async function checkFcmTokens() {
  const connection = await mysql.createConnection({
    host: '185.97.146.99',
    port: 8081,
    user: 'root',
    password: 'mot_de_passe_root',
    database: 'edor_mobile'
  });

  try {
    console.log('🔍 Vérification des tokens FCM...\n');

    // Vérifier la structure de la table prestataires
    const [columns] = await connection.execute('DESCRIBE prestataires');
    console.log('📋 Colonnes de la table prestataires:');
    columns.forEach(col => {
      console.log(`  - ${col.Field}: ${col.Type} ${col.Null === 'YES' ? '(nullable)' : '(not null)'}`);
    });

    console.log('\n📊 Statistiques des prestataires:');
    
    // Compter tous les prestataires
    const [totalCount] = await connection.execute('SELECT COUNT(*) as total FROM prestataires');
    console.log(`  - Total prestataires: ${totalCount[0].total}`);

    // Compter par catégorie
    const [categories] = await connection.execute(`
      SELECT category, COUNT(*) as count 
      FROM prestataires 
      GROUP BY category 
      ORDER BY count DESC
    `);
    console.log('  - Par catégorie:');
    categories.forEach(cat => {
      console.log(`    * ${cat.category}: ${cat.count}`);
    });

    // Vérifier les tokens FCM
    const [fcmStats] = await connection.execute(`
      SELECT 
        COUNT(*) as total,
        COUNT(fcmToken) as with_token,
        COUNT(*) - COUNT(fcmToken) as without_token
      FROM prestataires
    `);
    console.log('\n🔔 Tokens FCM:');
    console.log(`  - Avec token: ${fcmStats[0].with_token}`);
    console.log(`  - Sans token: ${fcmStats[0].without_token}`);

    // Afficher quelques exemples de prestataires avec leurs tokens
    const [examples] = await connection.execute(`
      SELECT id, firstName, lastName, category, 
             CASE WHEN fcmToken IS NULL THEN 'NULL' ELSE 'PRÉSENT' END as token_status
      FROM prestataires 
      LIMIT 10
    `);
    console.log('\n👥 Exemples de prestataires:');
    examples.forEach(prestataire => {
      console.log(`  - ${prestataire.firstName} ${prestataire.lastName} (${prestataire.category}): ${prestataire.token_status}`);
    });

  } catch (error) {
    console.error('❌ Erreur:', error.message);
  } finally {
    await connection.end();
  }
}

checkFcmTokens();



