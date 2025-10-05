import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddFcmTokenToUsers1737635000000 implements MigrationInterface {
  name = 'AddFcmTokenToUsers1737635000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Ajouter le champ fcmToken à la table users
    await queryRunner.query(`
      ALTER TABLE \`users\` 
      ADD COLUMN \`fcmToken\` varchar(255) NULL
    `);

    // Ajouter le champ fcmToken à la table prestataires
    await queryRunner.query(`
      ALTER TABLE \`prestataires\` 
      ADD COLUMN \`fcmToken\` varchar(255) NULL
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Supprimer le champ fcmToken de la table prestataires
    await queryRunner.query(`
      ALTER TABLE \`prestataires\` 
      DROP COLUMN \`fcmToken\`
    `);

    // Supprimer le champ fcmToken de la table users
    await queryRunner.query(`
      ALTER TABLE \`users\` 
      DROP COLUMN \`fcmToken\`
    `);
  }
}




